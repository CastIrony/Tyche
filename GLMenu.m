#import "Constants.h"
#import "Geometry.h"
#import "GLTexture.h"
#import "Bezier.h"
#import "Projection.h"
#import "GLLabel.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "TextController.h"
#import "TextControllerMainMenu.h"
#import "TextureController.h"

#import "GLMenu.h"

@implementation GLMenu

@synthesize texture        = _texture;
@synthesize textController = _textController;
@synthesize angleJitter    = _angleJitter;
@synthesize angleSin       = _angleSin;

@synthesize lightness       = _lightness;
@synthesize opacity        = _opacity;
@synthesize location       = _location;
@synthesize owner          = _owner;
@synthesize textureDots    = _textureDots;

-(void)dealloc
{
    free(_arrayVertex);
    free(_arrayVertexDots);
    free(_arrayNormal);
    free(_arrayTexture);
    free(_arrayMesh);
    
    [super dealloc];
}

-(id)init
{    
    self = [super init];
    
    if(self)
    {           
        _arrayVertexDots  = malloc(4 * sizeof(Vector3D));
        _arrayVertex      = malloc(4 * sizeof(Vector3D));
        _arrayNormal      = malloc(4 * sizeof(Vector3D));
        _arrayTexture     = malloc(4 * sizeof(Vector2D));
        _arrayMesh        = malloc(6 * sizeof(GLushort));
        
        self.opacity  = [AnimatedFloat withValue:1];
        self.location = [AnimatedVector3D withValue:Vector3DMake(0, 0, 0)];
        
        self.textureDots = [[[GLTexture alloc] initWithDots:23 current:4] autorelease];
        
        [self reset];
    }
    
    return self;
}

-(void)reset
{
    _textureSize   = Vector2DMake(1,1);
    _textureOffset = Vector2DMake(0,0);
        
    Vector3D baseCorners[] = 
    {
        Vector3DMake(-2.0,  0.0,  3.0),
        Vector3DMake(-2.0,  0.0, -3.0),
        Vector3DMake( 2.0,  0.0,  3.0),
        Vector3DMake( 2.0,  0.0, -3.0)
    };
    
    Vector3D baseCornersDots[] = 
    {
        Vector3DMake(-1.5,  0.0, 2.5),
        Vector3DMake(-1.5,  0.0, 1.0),
        Vector3DMake( 1.5,  0.0, 2.5),
        Vector3DMake( 1.5,  0.0, 1.0)
    };
    
    GenerateBezierControlPoints(_controlPoints, baseCorners);
    GenerateBezierControlPoints(_controlPointsDots, baseCornersDots);

    GenerateBezierVertices(_arrayVertex,      2, 2, _controlPoints);
    GenerateBezierVertices(_arrayVertexDots,  2, 2, _controlPointsDots);
    GenerateBezierNormals (_arrayNormal,      2, 2, _controlPoints);
    GenerateBezierTextures(_arrayTexture,     2, 2, _textureSize, _textureOffset);
    GenerateBezierMesh    (_arrayMesh,        2, 2);
}

-(void)draw
{    
    if(self.opacity.value < (0.001)) { return; }
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

    
    TRANSACTION_BEGIN
    {
        glTranslatef(self.location.value.x, self.location.value.y, self.location.value.z);

        glRotatef(self.angleSin, 0, 1, 0);
        
        
        glColor4f(self.opacity.value * self.lightness, self.opacity.value * self.lightness, self.opacity.value * self.lightness, self.opacity.value);
        
        glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"cards"]);
        
        glVertexPointer  (3, GL_FLOAT, 0, _arrayVertex);
        glNormalPointer  (   GL_FLOAT, 0, _arrayNormal);
        glTexCoordPointer(2, GL_FLOAT, 0, _arrayTexture);            
        
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, _arrayMesh);

        
        glColor4f(0, 0, 0, self.opacity.value);
        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        glBindTexture(GL_TEXTURE_2D, self.textureDots.name);
        
        glVertexPointer  (3, GL_FLOAT, 0, _arrayVertexDots);
        glNormalPointer  (   GL_FLOAT, 0, _arrayNormal);
        glTexCoordPointer(2, GL_FLOAT, 0, _arrayTexture);            

        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, _arrayMesh);

        
        self.textController.opacity = self.opacity.value;
        self.textController.lightness = self.lightness;
        
        [self.textController draw];
    }
    TRANSACTION_END
    
    static int counter = 0;
    
    counter++;
}

-(void)rotateWithAngle:(GLfloat)angle aroundPoint:(Vector3D)point andAxis:(Vector3D)axis
{    
    rotateVectors(_controlPoints, 16, angle, point, axis);
}

-(void)scaleWithFactor:(Vector3D)factor fromPoint:(Vector3D)point
{
    for(int i = 0; i < 16; i++)
    {
        _controlPoints[i].x = (_controlPoints[i].x - point.x) * factor.x + point.x;
        _controlPoints[i].y = (_controlPoints[i].y - point.y) * factor.y + point.y;
        _controlPoints[i].z = (_controlPoints[i].z - point.z) * factor.z + point.z;
    }
}

-(void)translateWithVector:(Vector3D)vector
{
    for(int i = 0; i < 16; i++)
    {
        _controlPoints[i].x = _controlPoints[i].x + vector.x;
        _controlPoints[i].y = _controlPoints[i].y + vector.y;
        _controlPoints[i].z = _controlPoints[i].z + vector.z;
    }
}

@end

@implementation GLMenu (Touchable)

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    GLfloat model_view[16];

    TRANSACTION_BEGIN
    {
        glTranslatef(self.location.value.x, self.location.value.y, self.location.value.z);
        
        glRotatef(/*self.angleJitter + */self.angleSin, 0, 1, 0);

        id<Touchable> touchedLabel = [self.textController testTouch:touch withPreviousObject:object];
        
        if(touchedLabel != object) { return touchedLabel; }
        
        glGetFloatv(GL_MODELVIEW_MATRIX, model_view);
    }
    TRANSACTION_END
    
    GLfloat projection[16];
    glGetFloatv(GL_PROJECTION_MATRIX, projection);
    
    GLint viewport[4];
    glGetIntegerv(GL_VIEWPORT, viewport);
	
    Vector2D points[16];
    ProjectVectors(_controlPoints, points, 16, model_view, projection, viewport);
    
    GLushort triangles[54];
    GenerateBezierMesh(triangles, 4, 4);
    
    CGPoint touchPoint = [touch locationInView:touch.view];
    
    Vector2D touchLocation = Vector2DMake(touchPoint.x, 480 - touchPoint.y);
    
    return TestTriangles(touchLocation, points, triangles, 18) ? self : object;
}

-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point
{
    [self.owner handleTouchDown:touch fromPoint:point];
}

-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    [self.owner handleTouchMoved:touch fromPoint:pointFrom toPoint:pointTo];
}

-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    [self.owner handleTouchUp:touch fromPoint:pointFrom toPoint:pointTo];
}

@end