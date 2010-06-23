#import "Constants.h"
#import "Common.h"
#import "Geometry.h"

@class GLTexture;
@class GLMenu;

@interface GLDots : NSObject 
{
    Vector3D   _controlPoints[16];
    Vector3D   _controlPointsDots[16];
    
    Vector2D   _textureOffset;
    Vector2D   _textureSize;
    
    Vector3D*  _arrayVertex;
    Vector3D*  _arrayNormal;
    Vector2D*  _arrayTexture;
    GLushort*  _arrayMesh;
}

@property (nonatomic, retain) GLTexture* texture;

-(void)setDots:(int)dots current:(int)current;

-(void)draw;

@end
