#import "Constants.h"
#import "Geometry.h"
#import "Bezier.h"
#import "GLTexture.h"
#import "Projection.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "TextureController.h"

#import "GLSplash.h"

@implementation GLSplash

@synthesize renderer      = _renderer;
@synthesize opacity       = _opacity;

-(id)init
{
    self = [super init];
    
    if(self) 
    {   
        self.opacity = [AnimatedFloat withValue:1];
    }
    
    return self;
}


-(void)draw
{
    if(self.opacity.value < 1.0 / 256.0) { return; }
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"splash"]);
            
    Vector3D borderArrayVertex1[4];
    GLushort borderArrayMesh1[6];
    Vector2D borderArrayTextures[4];
    
    borderArrayVertex1[0] = Vector3DMake(-.8, -1.2, -2.99);  
    borderArrayVertex1[1] = Vector3DMake( .8, -1.2, -2.99);  
    borderArrayVertex1[2] = Vector3DMake(-.8,  1.2, -2.99);  
    borderArrayVertex1[3] = Vector3DMake( .8,  1.2, -2.99); 

    borderArrayTextures[0] = Vector2DMake(0, 1);
    borderArrayTextures[1] = Vector2DMake(1, 1);
    borderArrayTextures[2] = Vector2DMake(0, 0);
    borderArrayTextures[3] = Vector2DMake(1, 0);
    
    GenerateBezierMesh(borderArrayMesh1, 2, 2);
        
    glDisableClientState(GL_NORMAL_ARRAY);
                         
    glNormal3f(0.0, 0.0, 1.0);
    
    glColor4f(self.opacity.value, self.opacity.value, self.opacity.value, self.opacity.value);

    glTexCoordPointer(2, GL_FLOAT, 0, borderArrayTextures);
    glVertexPointer  (3, GL_FLOAT, 0, borderArrayVertex1);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, borderArrayMesh1); 
        
    glEnableClientState(GL_NORMAL_ARRAY);
}

@end
