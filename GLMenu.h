#import "Geometry.h"
#import "Touchable.h"

@class AnimatedFloat;
@class AnimatedVector3D;
@class TextController;
@class TextControllerPageMarker;
@class MenuController;
@class GLTexture;
@class GLDots;

@interface GLMenu : NSObject
{
    Vector3D   _controlPoints[16];
    
    Vector2D   _textureOffset;
    Vector2D   _textureSize;

    Vector3D*  _arrayVertex;
    Vector3D*  _arrayNormal;
    Vector2D*  _arrayTexture;
    GLushort*  _arrayMesh;
}

@property (nonatomic, retain) TextController* textController;

@property (nonatomic, retain) GLDots* dots;

@property (nonatomic, assign) GLfloat  angleJitter;
@property (nonatomic, assign) GLfloat  angleSin;

@property (nonatomic, assign) GLfloat           lightness;
@property (nonatomic, retain) AnimatedFloat*    opacity;
@property (nonatomic, retain) AnimatedVector3D* location;
@property (nonatomic, assign) id owner;


-(void)reset;

-(void)draw;

-(void)rotateWithAngle:(GLfloat)angle aroundPoint:(Vector3D)point andAxis:(Vector3D)axis;
-(void)scaleWithFactor:(Vector3D)factor fromPoint:(Vector3D)point;
-(void)translateWithVector:(Vector3D)vector;

@end

@interface GLMenu (Touchable) <Touchable>

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;
-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end