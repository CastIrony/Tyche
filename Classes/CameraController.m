#import "GameRenderer.h"
#import "CameraController.h"

@implementation CameraController

@synthesize renderer    = _renderer;
@synthesize position    = _position;
@synthesize lookAt      = _lookAt;
@synthesize pitchAngle  = _pitchAngle;
@synthesize pitchFactor = _pitchFactor;
@synthesize rollAngle   = _rollAngle;

@dynamic isAutomatic;
@dynamic status;
@dynamic menuVisible;

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.lookAt      = [AnimatedVector3D withValue:Vector3DMake(0, 2.3,   0)];  
        self.position    = [AnimatedVector3D withValue:Vector3DMake(0, 2.3, -21)];  
        self.pitchAngle  = [AnimatedFloat    withValue:  0                      ];
        self.rollAngle   = [AnimatedFloat    withValue:-90                      ];
        self.pitchFactor = [AnimatedFloat    withValue:  1                      ];
    }
    
    return self;
}

-(BOOL)isAutomatic
{
    if(!_isAutomatic) { _isAutomatic = [NSNumber numberWithBool:!(TARGET_IPHONE_SIMULATOR)]; }
    
    return [_isAutomatic boolValue];
}

-(BOOL)menuVisible
{
    return _menuVisible;
}

-(void)setMenuVisible:(BOOL)value
{
    _menuVisible = value;
    
    [self updateCamera];
}

-(CameraStatus)status
{     
    return _status;
}

-(void)setStatus:(CameraStatus)status
{
    _status = status;
    
    [self updateCamera];
}

-(void)updateCamera
{
    if(self.menuVisible)
    {
        [self.pitchFactor setValue:0 forTime:1 andThen:nil]; 
//        [self.pitchAngle  setValue:0 forTime:1 andThen:nil]; 
        [self.rollAngle   setValue:0 forTime:1 andThen:nil]; 
        self.position    = [AnimatedVector3D withStartValue:self.position.value    endValue:Vector3DMake(0, 0.0, -8 * ZOOMSCALE) forTime:1];  
        self.lookAt      = [AnimatedVector3D withStartValue:self.lookAt.value      endValue:Vector3DMake(0, 0.0,   0) forTime:1]; 
    }
    else 
    {
        if(self.status == CameraStatusCardsFlipped)
        {
            [self.pitchFactor setValue:1   forTime:1 andThen:nil]; 
//            [self.pitchAngle  setValue:0   forTime:1 andThen:nil]; 
            [self.rollAngle   setValue:-90 forTime:1 andThen:nil]; 
            
            self.position    = [AnimatedVector3D withStartValue:self.position.value    endValue:Vector3DMake(0, 2.3, -25 * ZOOMSCALE) forTime:1]; 
            self.lookAt      = [AnimatedVector3D withStartValue:self.lookAt.value      endValue:Vector3DMake(0, 2.3,   0) forTime:1]; 
        }
        else 
        {
            [self.pitchFactor setValue:1   forTime:1 andThen:nil]; 
//            [self.pitchAngle  setValue:0   forTime:1 andThen:nil]; 
            [self.rollAngle   setValue:-90 forTime:1 andThen:nil]; 

            self.position    = [AnimatedVector3D withStartValue:self.position.value    endValue:Vector3DMake(0, 2.3, -21 * ZOOMSCALE) forTime:1];  
            self.lookAt      = [AnimatedVector3D withStartValue:self.lookAt.value      endValue:Vector3DMake(0, 2.3,   0) forTime:1];  
        }
    }
}

//TODO: one of these is wrong, but I think it was intentional

-(void)flattenAndThen:(simpleBlock)work
{
    [self.pitchFactor setValue:1 forTime:(self.pitchAngle.value / 45.0) andThen:work]; 
}

-(void)unflattenAndThen:(simpleBlock)work
{
    [self.pitchFactor setValue:1 forTime:(self.pitchAngle.value / 45.0) andThen:work]; 
}

@end