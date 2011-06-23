#import "AnimatedFloat.h"
#import "Bezier.h"
#import "GLTexture.h"
#import "GLMenu.h"

#import "GLDots.h"

@implementation GLDots

@synthesize texture;
@synthesize menu;

-(void)dealloc
{
    free(_arrayVertex);
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
        _arrayVertex      = malloc(4 * sizeof(vec3));
        _arrayNormal      = malloc(4 * sizeof(vec3));
        _arrayTexture     = malloc(4 * sizeof(vec2));
        _arrayMesh        = malloc(6 * sizeof(GLushort));
    }
    
    return self;
}

-(void)draw
{
    if(!self.texture) { return; }
        
    glColor4f(0.5, 0, 0, self.menu.opacity.value * 0.75);
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glBindTexture(GL_TEXTURE_2D, self.texture.name);
    
    glVertexPointer  (3, GL_FLOAT, 0, _arrayVertex);
    glNormalPointer  (   GL_FLOAT, 0, _arrayNormal);
    glTexCoordPointer(2, GL_FLOAT, 0, _arrayTexture);            
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, _arrayMesh);   
}

-(void)setDots:(int)dots current:(int)current;
{
    if(dots < 2)
    {
        self.texture = nil;
        
        return;
    }
    
    self.texture = [[[GLTexture alloc] initWithDots:dots current:current] autorelease];
    
    GLfloat height = self.texture.contentSize.height / 100;
    GLfloat width = self.texture.contentSize.width / 100; 
        
    vec3 baseCorners[] = 
    {
        vec3Make(-width / 2,  0.0, 2.6),
        vec3Make(-width / 2,  0.0, 2.6 - height),
        vec3Make( width / 2,  0.0, 2.6),
        vec3Make( width / 2,  0.0, 2.6 - height)
    };
    
    GenerateBezierControlPoints(_controlPoints, baseCorners);
    
    GenerateBezierVertices(_arrayVertex,      2, 2, _controlPoints);
    GenerateBezierNormals (_arrayNormal,      2, 2, _controlPoints);
    GenerateBezierTextures(_arrayTexture,     2, 2, vec2Make(1, 1), vec2Make(0, 0));
    GenerateBezierMesh    (_arrayMesh,        2, 2);
}

@end
