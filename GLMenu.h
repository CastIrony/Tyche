#import "MC3DVector.h"
#import "Touchable.h"
#import "DisplayContainer.h"

@class AnimatedFloat;
@class AnimatedVec3;
@class GLTextController;
@class TextControllerPageMarker;
@class GLMenuController;
@class GLTexture;
@class GLDots;

@interface GLMenu : NSObject <Touchable, Displayable>
{
    vec3   _controlPoints[16];
    
    vec2   _textureOffset;
    vec2   _textureSize;

    vec3*  _arrayVertex;
    vec3*  _arrayNormal;
    vec2*  _arrayTexture;
    GLushort*  _arrayMesh;
}

@property (nonatomic, retain) GLTextController* textController;

@property (nonatomic, retain) GLDots* dots;

@property (nonatomic, assign) GLfloat  angleJitter;
@property (nonatomic, assign) GLfloat  angleSin;

@property (nonatomic, assign) GLfloat           lightness;
@property (nonatomic, retain) AnimatedFloat*    opacity;
@property (nonatomic, retain) AnimatedFloat*    death;
@property (nonatomic, retain) AnimatedFloat*    location;
@property (nonatomic, assign) id owner;
@property (nonatomic, copy)   NSString*         key;


-(void)reset;

-(void)draw;

-(void)rotateWithAngle:(GLfloat)angle aroundPoint:(vec3)point andAxis:(vec3)axis;
-(void)scaleWithFactor:(vec3)factor fromPoint:(vec3)point;
-(void)translateWithVector:(vec3)vector;

@end