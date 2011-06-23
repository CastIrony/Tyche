#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"

typedef enum 
{
    CameraStatusNormal,
    CameraStatusCardsFlipped
} 
CameraStatus;

@class GameRenderer;

@interface CameraController : NSObject 
{
    GameRenderer*     _renderer;
    BOOL              _menuVisible;
    CameraStatus      _status;
    AnimatedVector3D* _position;
    AnimatedVector3D* _lookAt;
    AnimatedFloat*    _pitchAngle;
    AnimatedFloat*    _pitchFactor;
    AnimatedFloat*    _rollAngle;
    NSNumber*         _isAutomatic;
}

@property (nonatomic, assign)   GameRenderer*      renderer;
@property (nonatomic, readonly) BOOL               isAutomatic;
@property (nonatomic, assign)   BOOL               menuVisible;
@property (nonatomic, assign)   CameraStatus       status;
@property (nonatomic, retain)   AnimatedVector3D*  position;
@property (nonatomic, retain)   AnimatedVector3D*  lookAt;
@property (nonatomic, retain)   AnimatedFloat*     pitchAngle;
@property (nonatomic, retain)   AnimatedFloat*     pitchFactor;
@property (nonatomic, retain)   AnimatedFloat*     rollAngle;

-(void)setMenuVisible:(BOOL)value;
-(void)setStatus:(CameraStatus)status;
-(void)updateCamera;
-(void)flattenAndThen:(SimpleBlock)work;
-(void)unflattenAndThen:(SimpleBlock)work;

@end
