#import "Common.h"
#import "Geometry.h"
#import "Bezier.h"
#import "GLTexture.h"
#import "Projection.h"
#import "GLCardGroup.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "GameRenderer.h"
#import "TextureController.h"
#import "CameraController.h"

#import "GLCard.h"

@implementation GLCard

@synthesize renderer    = _renderer;
@synthesize cardGroup   = _cardGroup;
@synthesize angleJitter = _angleJitter;
@synthesize isDead      = _isDead;
@synthesize suit        = _suit;
@synthesize numeral     = _numeral;
@synthesize position    = _position;

@synthesize isHeld     = _isHeld;
@synthesize isSelected = _isSelected;
@synthesize angleFlip  = _angleFlip;
@synthesize angleFan   = _angleFan;
@synthesize location   = _location;

-(void)dealloc
{
    free(arrayVertex);
    free(arrayNormal);
    free(arrayTexture0);
    free(arrayTexture1);
    free(arrayMesh);
    
    [super dealloc];
}

-(id)initWithSuit:(int)suit numeral:(int)numeral
{
    int cardTesselationWidth  = 11;
    int cardTesselationHeight = 3;
    
    self = [super init];
    
    if(self)
    {   
        _numeral = numeral;
        _suit    = suit;
                
        arrayVertex  = malloc(cardTesselationWidth * cardTesselationHeight * sizeof(Vector3D));
        arrayNormal  = malloc(cardTesselationWidth * cardTesselationHeight * sizeof(Vector3D));
        arrayTexture0 = malloc(cardTesselationWidth * cardTesselationHeight * sizeof(Vector2D));
        arrayTexture1 = malloc(cardTesselationWidth * cardTesselationHeight * sizeof(Vector2D));
        arrayMesh    = malloc((cardTesselationWidth - 1) * (cardTesselationHeight - 1) * 6 * sizeof(GLushort));
        
        textureSizeCard       = Vector2DMake(172.0 / 1024.0, 252.0 / 1024.0);
        textureSizeLabel      = Vector2DMake(116.0 / 1024.0,  62.0 / 1024.0);
        
        textureOffsetCard[ 0] = Vector2DMake(826.0 / 1024.0, 702.0 / 1024.0); // Shadow
        textureOffsetCard[ 1] = Vector2DMake( 26.0 / 1024.0,  36.0 / 1024.0); // Ace
        textureOffsetCard[ 2] = Vector2DMake(226.0 / 1024.0,  36.0 / 1024.0); // 2
        textureOffsetCard[ 3] = Vector2DMake(428.0 / 1024.0,  36.0 / 1024.0); // 3
        textureOffsetCard[ 4] = Vector2DMake(626.0 / 1024.0,  36.0 / 1024.0); // 4
        textureOffsetCard[ 5] = Vector2DMake(826.0 / 1024.0,  36.0 / 1024.0); // 5
        textureOffsetCard[ 6] = Vector2DMake( 26.0 / 1024.0, 369.0 / 1024.0); // 6
        textureOffsetCard[ 7] = Vector2DMake(226.0 / 1024.0, 369.0 / 1024.0); // 7
        textureOffsetCard[ 8] = Vector2DMake(426.0 / 1024.0, 369.0 / 1024.0); // 8
        textureOffsetCard[ 9] = Vector2DMake(626.0 / 1024.0, 369.0 / 1024.0); // 9
        textureOffsetCard[10] = Vector2DMake(826.0 / 1024.0, 369.0 / 1024.0); // 10
        textureOffsetCard[11] = Vector2DMake( 26.0 / 1024.0, 702.0 / 1024.0); // Jack
        textureOffsetCard[12] = Vector2DMake(226.0 / 1024.0, 702.0 / 1024.0); // Queen
        textureOffsetCard[13] = Vector2DMake(426.0 / 1024.0, 702.0 / 1024.0); // King
        textureOffsetCard[14] = Vector2DMake(626.0 / 1024.0, 702.0 / 1024.0); // Back
        
        self.isHeld     = [AnimatedFloat withValue:0];
        self.isSelected = [AnimatedFloat withValue:0];
        self.angleFlip  = [AnimatedFloat withValue:0];
        self.angleFan   = [AnimatedFloat withValue:0];
        
        self.location   = [AnimatedVector3D withValue:Vector3DMake(0, 0, 0)];
    }
    
    return self;
}

-(void)drawFront
{    
    int cardTesselationWidth  = 9;
    int cardTesselationHeight = 3;
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
//    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:[NSString stringWithFormat:@"suit%d", _suit]]);
    
    GLfloat held = self.isHeld.value     * 0.5 + 0.5;
        
    GLfloat lightness = self.renderer.lightness.value;
    
    glColor4f(lightness, lightness, lightness, held);
    
    GenerateBezierVertices(arrayVertex,  cardTesselationWidth, cardTesselationHeight, _controlPointsFront);
    GenerateBezierNormals (arrayNormal,  cardTesselationWidth, cardTesselationHeight, _controlPointsFront);
    GenerateBezierMesh    (arrayMesh,    cardTesselationWidth, cardTesselationHeight);
    
    glVertexPointer  (3, GL_FLOAT, 0, arrayVertex);
    glNormalPointer  (   GL_FLOAT, 0, arrayNormal);
        
    
    
    
    
    
    
    
    
    GenerateBezierTextures(arrayTexture0, cardTesselationWidth, cardTesselationHeight, Vector2DMake(1, 1), Vector2DMake(0, 0));
    GenerateBezierTextures(arrayTexture1, cardTesselationWidth, cardTesselationHeight, textureSizeCard, textureOffsetCard[self.numeral]);
        
    glClientActiveTexture(GL_TEXTURE0); 
    glActiveTexture(GL_TEXTURE0); 
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"cards"]);
    glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0);      
    
    glClientActiveTexture(GL_TEXTURE1); 
    glActiveTexture(GL_TEXTURE1); 
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:[NSString stringWithFormat:@"suit%d", _suit]]);
    glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture1);      
    
    glDrawElements(GL_TRIANGLES, (cardTesselationWidth - 1) * (cardTesselationHeight - 1) * 6, GL_UNSIGNED_SHORT, arrayMesh);
    
    glClientActiveTexture(GL_TEXTURE1); 
    glActiveTexture(GL_TEXTURE1); 
    glBindTexture(GL_TEXTURE_2D, 0);
    glClientActiveTexture(GL_TEXTURE0); 
    glActiveTexture(GL_TEXTURE0); 
    
    
    
    
    
    
    
}

-(void)drawBack
{
    int cardTesselationWidth  = 5;
    int cardTesselationHeight = 3;
        
    GLfloat held = self.isHeld.value     * 0.5 + 0.5;
    
    GLfloat lightness = self.renderer.lightness.value;
    
    glColor4f(lightness, lightness, lightness, held);
    
    TinyProfilerStart(20); GenerateBezierVertices(arrayVertex,   cardTesselationWidth, cardTesselationHeight, _controlPointsBack);                      TinyProfilerStop(20);         
    TinyProfilerStart(21); GenerateBezierNormals (arrayNormal,   cardTesselationWidth, cardTesselationHeight, _controlPointsBack);                      TinyProfilerStop(21);
    TinyProfilerStart(22); GenerateBezierMesh    (arrayMesh,     cardTesselationWidth, cardTesselationHeight);                                          TinyProfilerStop(22);
    TinyProfilerStart(23); GenerateBezierTextures(arrayTexture0, cardTesselationWidth, cardTesselationHeight, Vector2DMake(1, 1), Vector2DMake(0, 0)); TinyProfilerStop(23);
    TinyProfilerStart(24); GenerateBezierTextures(arrayTexture1, cardTesselationWidth, cardTesselationHeight, textureSizeCard, textureOffsetCard[14]); TinyProfilerStop(24);
    
    glVertexPointer  (3, GL_FLOAT, 0, arrayVertex);                                                                             
    glNormalPointer  (   GL_FLOAT, 0, arrayNormal);                                                                             
    
    TinyProfilerStart(25); 
    
    glClientActiveTexture(GL_TEXTURE0); 
    glActiveTexture(GL_TEXTURE0); 
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"cards"]);
    glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0);      
    
    TinyProfilerStop(25); 
    TinyProfilerStart(26); 
    
    glClientActiveTexture(GL_TEXTURE1); 
    glActiveTexture(GL_TEXTURE1); 
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"suit0"]);
    glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture1);      
    
    TinyProfilerStop(26); 
    TinyProfilerStart(27); 
    
    glDrawElements(GL_TRIANGLES, (cardTesselationWidth - 1) * (cardTesselationHeight - 1) * 6, GL_UNSIGNED_SHORT, arrayMesh);

    TinyProfilerStop(27); 
    
    glClientActiveTexture(GL_TEXTURE1); 
    glActiveTexture(GL_TEXTURE1); 
    glBindTexture(GL_TEXTURE_2D, 0);
    glClientActiveTexture(GL_TEXTURE0); 
    glActiveTexture(GL_TEXTURE0); 
}

-(void)drawShadow
{
    
    int cardTesselationWidth  = 5;
    int cardTesselationHeight = 3;
    
    glDisable(GL_CULL_FACE);
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"suit0"]);
    
    GLfloat held = self.isHeld.value * 0.5 + 0.5;
    
    glColor4f(1, 1, 1, held);    
    
    GenerateBezierVertices(arrayVertex,   cardTesselationWidth, cardTesselationHeight, _controlPointsShadow);
    GenerateBezierNormals (arrayNormal,   cardTesselationWidth, cardTesselationHeight, _controlPointsShadow);
    GenerateBezierTextures(arrayTexture0, cardTesselationWidth, cardTesselationHeight, textureSizeCard, textureOffsetCard[0]);
    GenerateBezierMesh    (arrayMesh,     cardTesselationWidth, cardTesselationHeight);
    
    glVertexPointer  (3, GL_FLOAT, 0, arrayVertex);
    glNormalPointer  (   GL_FLOAT, 0, arrayNormal);
    glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0);            
    
    glDrawElements(GL_TRIANGLES, (cardTesselationWidth - 1) * (cardTesselationHeight - 1) * 6, GL_UNSIGNED_SHORT, arrayMesh);
    
    glEnable(GL_CULL_FACE);
}

-(void)drawLabel
{
    if(self.angleFlip.value < 90)
    {        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
        //Vector3D arrayVertex [4];
        //Vector3D arrayNormal [4];
        //Vector2D arrayTexture[4];
        
        //GLushort arrayMesh[6];  
        
        GenerateBezierVertices(arrayVertex,  2, 2, _controlPointsLabel);
        GenerateBezierNormals (arrayNormal,  2, 2, _controlPointsLabel);
        GenerateBezierMesh    (arrayMesh,    2, 2);
        
        glVertexPointer  (3, GL_FLOAT, 0, arrayVertex);
        glNormalPointer  (   GL_FLOAT, 0, arrayNormal);

        // HOLD
        {
            glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"hold"]);
            
            glColor4f(1, 1, 1, self.isHeld.value);
                        
            GenerateBezierTextures(arrayTexture0, 2, 2, Vector2DMake(1,1), Vector2DMake(0,0));
            
            glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0);
            
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, arrayMesh);
        }
        
        // DRAW
        {
            glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"draw"]);
            
            glColor4f(1, 1, 1, (1 - self.isHeld.value) / 2);
            
            GenerateBezierTextures(arrayTexture0, 2, 2, Vector2DMake(1,1), Vector2DMake(0,0));
            
            glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0);
            
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, arrayMesh);
        }
    }
}

-(void)generateWithBendFactor:(GLfloat)bendFactor
{
    Vector3D baseCorners[] = 
    {
        Vector3DMake( 2.0,  0.0,  3.0),
        Vector3DMake( 2.0,  0.0, -3.0),
        Vector3DMake(-2.0,  0.0,  3.0),
        Vector3DMake(-2.0,  0.0, -3.0)
    };
    
    Vector3D labelCorners[] = 
    {
        Vector3DMake(-0.7,  0.0,  3.0),
        Vector3DMake(-0.7,  0.0,  3.5),
        Vector3DMake( 0.7,  0.0,  3.0),
        Vector3DMake( 0.7,  0.0,  3.5)
    };

    GenerateBezierControlPoints(_controlPointsBase,  baseCorners);
    GenerateBezierControlPoints(_controlPointsLabel, labelCorners);
        
    _controlPointsFront[ 0] = _controlPointsBase [ 0];
    _controlPointsFront[ 1] = _controlPointsBase [ 1];
    _controlPointsFront[ 2] = _controlPointsBase [ 2];
    _controlPointsFront[ 3] = _controlPointsBase [ 3];
    
    _controlPointsFront[ 4] = _controlPointsBase [ 4];
    _controlPointsFront[ 5] = _controlPointsBase [ 5];
    _controlPointsFront[ 6] = _controlPointsBase [ 6];
    _controlPointsFront[ 7] = _controlPointsBase [ 7];
    
    _controlPointsFront[ 8] = _controlPointsBase [ 8];
    _controlPointsFront[ 9] = _controlPointsBase [ 9];
    _controlPointsFront[10] = _controlPointsBase [10];
    _controlPointsFront[11] = _controlPointsBase [11];
    
    _controlPointsFront[12] = _controlPointsBase [12];
    _controlPointsFront[13] = _controlPointsBase [13];
    _controlPointsFront[14] = _controlPointsBase [14];
    _controlPointsFront[15] = _controlPointsBase [15];
        
    _controlPointsBack[ 0]  = _controlPointsBase [ 3];
    _controlPointsBack[ 1]  = _controlPointsBase [ 2];
    _controlPointsBack[ 2]  = _controlPointsBase [ 1];
    _controlPointsBack[ 3]  = _controlPointsBase [ 0];
    
    _controlPointsBack[ 4]  = _controlPointsBase [ 7];
    _controlPointsBack[ 5]  = _controlPointsBase [ 6];
    _controlPointsBack[ 6]  = _controlPointsBase [ 5];
    _controlPointsBack[ 7]  = _controlPointsBase [ 4];
    
    _controlPointsBack[ 8]  = _controlPointsBase [11];
    _controlPointsBack[ 9]  = _controlPointsBase [10];
    _controlPointsBack[10]  = _controlPointsBase [ 9];
    _controlPointsBack[11]  = _controlPointsBase [ 8];
    
    _controlPointsBack[12]  = _controlPointsBase [15];
    _controlPointsBack[13]  = _controlPointsBase [14];
    _controlPointsBack[14]  = _controlPointsBase [13];
    _controlPointsBack[15]  = _controlPointsBase [12];
    
    _controlPointsShadow[ 0] = _controlPointsBase [ 3];
    _controlPointsShadow[ 1] = _controlPointsBase [ 2];
    _controlPointsShadow[ 2] = _controlPointsBase [ 1];
    _controlPointsShadow[ 3] = _controlPointsBase [ 0];
    
    _controlPointsShadow[ 4] = _controlPointsBase [ 7];
    _controlPointsShadow[ 5] = _controlPointsBase [ 6];
    _controlPointsShadow[ 6] = _controlPointsBase [ 5];
    _controlPointsShadow[ 7] = _controlPointsBase [ 4];
    
    _controlPointsShadow[ 8] = _controlPointsBase [11];
    _controlPointsShadow[ 9] = _controlPointsBase [10];
    _controlPointsShadow[10] = _controlPointsBase [ 9];
    _controlPointsShadow[11] = _controlPointsBase [ 8];
    
    _controlPointsShadow[12] = _controlPointsBase [15];
    _controlPointsShadow[13] = _controlPointsBase [14];
    _controlPointsShadow[14] = _controlPointsBase [13];
    _controlPointsShadow[15] = _controlPointsBase [12];
    
    [self rotateWithAngle:self.angleFlip.value aroundPoint:Vector3DMake(0.0, 0.0, 0.0) andAxis:Vector3DMake(0.0, 0.0, 1.0)];
    [self rotateWithAngle:self.angleJitter aroundPoint:Vector3DMake(0.0, 0.0, 0.0) andAxis:Vector3DMake(0.0, 1.0, 0.0)];
    [self rotateWithAngle:bendFactor * self.angleFan.value aroundPoint:Vector3DMake(0.0, 0.0, -30.0) andAxis:Vector3DMake(0.0, 1.0, 0.0)];
    
    [self bendWithAngle:bendFactor * 108 aroundPoint:Vector3DMake(0.0, 0.0, 0.0) andAxis:Vector3DMake(1.0, 0.0, 0.0)];
    
    [self scaleWithFactor:Vector3DMake(1.0, 1.2, 1.0) fromPoint:Vector3DMake(0.0, 0.0, 0.0)];
    
    [self translateWithVector:Vector3DMake(0, -1.0 * sin(DEGREES_TO_RADIANS(self.angleFlip.value)), 0)];
    [self translateWithVector:self.location.value];
    
    [self flattenShadow];
}

-(void)rotateWithAngle:(GLfloat)angle aroundPoint:(Vector3D)point andAxis:(Vector3D)axis
{   
    rotateVectors(_controlPointsShadow, 16, angle, point, axis);
    rotateVectors(_controlPointsFront,  16, angle, point, axis);
    rotateVectors(_controlPointsBack,   16, angle, point, axis);
    rotateVectors(_controlPointsLabel,  16, angle, point, axis);
}

-(void)bendWithAngle:(GLfloat)angle aroundPoint:(Vector3D)point andAxis:(Vector3D)axis
{   
    rotateVectors(_controlPointsShadow,  8, angle, point, axis);
    rotateVectors(_controlPointsFront,   8, angle, point, axis);
    rotateVectors(_controlPointsBack,    8, angle, point, axis);
    rotateVectors(_controlPointsLabel,  16, angle, point, axis);
}

-(void)scaleWithFactor:(Vector3D)factor fromPoint:(Vector3D)point
{
    for(int i = 0; i < 16; i++)
    {
        _controlPointsShadow[i].x = (_controlPointsShadow[i].x - point.x) * factor.x + point.x;
        _controlPointsShadow[i].y = (_controlPointsShadow[i].y - point.y) * factor.y + point.y;
        _controlPointsShadow[i].z = (_controlPointsShadow[i].z - point.z) * factor.z + point.z;
        
        _controlPointsFront[i].x  = (_controlPointsFront[i].x  - point.x) * factor.x + point.x;
        _controlPointsFront[i].y  = (_controlPointsFront[i].y  - point.y) * factor.y + point.y;
        _controlPointsFront[i].z  = (_controlPointsFront[i].z  - point.z) * factor.z + point.z;
        
        _controlPointsBack[i].x   = (_controlPointsBack[i].x   - point.x) * factor.x + point.x;
        _controlPointsBack[i].y   = (_controlPointsBack[i].y   - point.y) * factor.y + point.y;
        _controlPointsBack[i].z   = (_controlPointsBack[i].z   - point.z) * factor.z + point.z;
        
        _controlPointsLabel[i].x  = (_controlPointsLabel[i].x   - point.x) * factor.x + point.x;
        _controlPointsLabel[i].y  = (_controlPointsLabel[i].y   - point.y) * factor.y + point.y;
        _controlPointsLabel[i].z  = (_controlPointsLabel[i].z   - point.z) * factor.z + point.z;
    }
}

-(void)scaleShadowWithFactor:(Vector3D)factor fromPoint:(Vector3D)point
{
    for(int i = 0; i < 16; i++)
    {
        _controlPointsShadow[i].x = (_controlPointsShadow[i].x - point.x) * factor.x + point.x;
        _controlPointsShadow[i].y = (_controlPointsShadow[i].y - point.y) * factor.y + point.y;
        _controlPointsShadow[i].z = (_controlPointsShadow[i].z - point.z) * factor.z + point.z;
    }
}

-(void)translateWithVector:(Vector3D)vector
{
    for(int i = 0; i < 16; i++)
    {
        _controlPointsShadow[i].x = _controlPointsShadow[i].x + vector.x;
        _controlPointsShadow[i].y = _controlPointsShadow[i].y + vector.y;
        _controlPointsShadow[i].z = _controlPointsShadow[i].z + vector.z;
        
        _controlPointsFront[i].x  = _controlPointsFront[i].x  + vector.x;
        _controlPointsFront[i].y  = _controlPointsFront[i].y  + vector.y;
        _controlPointsFront[i].z  = _controlPointsFront[i].z  + vector.z;
        
        _controlPointsBack[i].x   = _controlPointsBack[i].x   + vector.x;
        _controlPointsBack[i].y   = _controlPointsBack[i].y   + vector.y;
        _controlPointsBack[i].z   = _controlPointsBack[i].z   + vector.z;
        
        _controlPointsLabel[i].x   = _controlPointsLabel[i].x   + vector.x;
        _controlPointsLabel[i].y   = _controlPointsLabel[i].y   + vector.y;
        _controlPointsLabel[i].z   = _controlPointsLabel[i].z   + vector.z;
    }
}

-(void)flattenShadow
{
    Vector3D light = Vector3DMake(0, -20, 0);
    
    for(int i = 0; i < 16; i++)
    {
        _controlPointsShadow[i] = Vector3DProjectShadow(light, _controlPointsShadow[i]);
    }
}

@end

@implementation GLCard (Touchable)

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    GLfloat model_view[16];
    glGetFloatv(GL_MODELVIEW_MATRIX, model_view);
    
    GLfloat projection[16];
    glGetFloatv(GL_PROJECTION_MATRIX, projection);
    
    GLint viewport[4];
    glGetIntegerv(GL_VIEWPORT, viewport);
	
    Vector2D points[16];
    ProjectVectors(_controlPointsFront, points, 16, model_view, projection, viewport);
    
    GLushort triangles[54];
    GenerateBezierMesh(triangles, 4, 4);
    
    CGPoint touchPoint = [touch locationInView:touch.view];
    
    Vector2D touchLocation = Vector2DMake(touchPoint.x, 480 - touchPoint.y);
    
    return TestTriangles(touchLocation, points, triangles, 18) ? self : object;
}

-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point
{
    GLfloat angle = self.renderer.camera.pitchAngle.value * self.renderer.camera.pitchFactor.value;
    
    if(angle > 60)
    {
        [self.cardGroup startDragForCard:self];
    }
}

-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    //int target = 4 - ((pointTo.y - 48.0) / 96.0);
    int target = ((pointTo.y) / 96.0);
    
    if(target < 0) { target = 0; }
    if(target > 4) { target = 4; }
    
    GLfloat delta = pointTo.y - pointFrom.y;
    
    [self.cardGroup dragCardToTarget:target withDelta:delta];
}

-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    GLfloat angle = self.renderer.camera.pitchAngle.value * self.renderer.camera.pitchFactor.value;
    
    [self.cardGroup stopDrag];

    GLfloat delta = absf(pointFrom.y, pointTo.y);
        
    if(delta < 20)
    {
        if(angle > 60)
        {
            [self.renderer.gameController cardFrontTouched:self.position];
        }
        else
        {            
            [self.renderer.gameController cardBackTouched:self.position];
        }
    }
}

@end