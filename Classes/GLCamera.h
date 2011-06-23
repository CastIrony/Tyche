#import "AnimatedFloat.h"
#import "AnimatedVec3.h"

typedef enum 
{
    CameraStatusNormal,
    CameraStatusCardsFlipped
} 
GLCameraStatus;

@class GLRenderer;

@interface GLCamera : NSObject 

+(GLCamera*)camera;

@property (nonatomic, assign) BOOL           isAutomatic;
@property (nonatomic, assign) BOOL           menuVisible;
@property (nonatomic, assign) GLCameraStatus status;
@property (nonatomic, assign) GLRenderer*    renderer;
@property (nonatomic, retain) AnimatedVec3*  position;
@property (nonatomic, retain) AnimatedVec3*  lookAt;
@property (nonatomic, retain) AnimatedFloat* pitchAngle;
@property (nonatomic, retain) AnimatedFloat* pitchFactor;
@property (nonatomic, retain) AnimatedFloat* rollAngle;
@property (nonatomic, retain) AnimatedFloat* flipAngle;

-(void)setMenuVisible:(BOOL)value;
-(void)setStatus:(GLCameraStatus)status;
-(void)updateCamera;

@end
