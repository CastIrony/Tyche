#import "Constants.h"
#import "Common.h"
#import "MC3DVector.h"

@class GLTexture;
@class GLMenu;

@interface GLDots : NSObject 
{
    vec3   _controlPoints[16];
    
    vec3*  _arrayVertex;
    vec3*  _arrayNormal;
    vec2*  _arrayTexture;
    GLushort*  _arrayMesh;
}

@property (nonatomic, retain) GLTexture* texture;
@property (nonatomic, assign) GLMenu* menu;

-(void)setDots:(int)dots current:(int)current;

-(void)draw;

@end
