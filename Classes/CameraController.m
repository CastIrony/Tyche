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
    //if(!_isAutomatic) { _isAutomatic = 1;[[NSUserDefaults standardUserDefaults] objectForKey:@"automatic_camera"]; }
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
        if(self.renderer.animated)
        {
            self.pitchFactor = [AnimatedFloat    withStartValue:self.pitchFactor.value endValue:0                         forTime:1]; self.pitchFactor.curve = AnimationEaseInOut;
            self.pitchAngle  = [AnimatedFloat    withStartValue:self.pitchAngle.value  endValue:0                         forTime:1]; self.pitchAngle.curve  = AnimationEaseInOut;
            self.rollAngle   = [AnimatedFloat    withStartValue:self.rollAngle.value   endValue:0                         forTime:1]; self.rollAngle.curve   = AnimationEaseInOut;
            self.position    = [AnimatedVector3D withStartValue:self.position.value    endValue:Vector3DMake(0, 0.0, -11) forTime:1]; self.position.curve    = AnimationEaseInOut;
            self.lookAt      = [AnimatedVector3D withStartValue:self.lookAt.value      endValue:Vector3DMake(0, 0.0,   0) forTime:1]; self.lookAt.curve      = AnimationEaseInOut;
        }
        else 
        {
            self.pitchFactor = [AnimatedFloat    withValue:0]; 
            self.pitchAngle  = [AnimatedFloat    withValue:0]; 
            self.rollAngle   = [AnimatedFloat    withValue:0]; 
            self.position    = [AnimatedVector3D withValue:Vector3DMake(0, 0.0, -11)]; 
            self.lookAt      = [AnimatedVector3D withValue:Vector3DMake(0, 0.0,  0)]; 
        }
    }
    else 
    {
        if(self.status == CameraStatusCardsFlipped)
        {
            if(self.renderer.animated)
            {
                self.pitchAngle  = [AnimatedFloat    withStartValue:self.pitchAngle.value  endValue:  0                       forTime:1]; self.pitchAngle.curve  = AnimationEaseInOut;
                self.rollAngle   = [AnimatedFloat    withStartValue:self.rollAngle.value   endValue:-90                       forTime:1]; self.rollAngle.curve   = AnimationEaseInOut;
                self.position    = [AnimatedVector3D withStartValue:self.position.value    endValue:Vector3DMake(0, 2.3, -25) forTime:1]; self.position.curve    = AnimationEaseInOut;
                self.lookAt      = [AnimatedVector3D withStartValue:self.lookAt.value      endValue:Vector3DMake(0, 2.3,   0) forTime:1]; self.lookAt.curve      = AnimationEaseInOut;
            }
            else 
            {
                self.pitchAngle  = [AnimatedFloat    withValue:  0];
                self.rollAngle   = [AnimatedFloat    withValue:-90];
                self.position    = [AnimatedVector3D withValue:Vector3DMake(0, 2.3, -25)];
                self.lookAt      = [AnimatedVector3D withValue:Vector3DMake(0, 2.3,   0)];
            }
        }
        else 
        {
            if(self.renderer.animated)
            {
                self.pitchAngle  = [AnimatedFloat    withStartValue:self.pitchAngle.value  endValue:  0                       forTime:1]; self.pitchAngle.curve  = AnimationEaseInOut;
                self.rollAngle   = [AnimatedFloat    withStartValue:self.rollAngle.value   endValue:-90                       forTime:1]; self.rollAngle.curve   = AnimationEaseInOut;
                self.position    = [AnimatedVector3D withStartValue:self.position.value    endValue:Vector3DMake(0, 2.3, -21) forTime:1]; self.position.curve    = AnimationEaseInOut; 
                self.lookAt      = [AnimatedVector3D withStartValue:self.lookAt.value      endValue:Vector3DMake(0, 2.3,   0) forTime:1]; self.lookAt.curve      = AnimationEaseInOut; 
            }
            else 
            {
                self.pitchAngle  = [AnimatedFloat    withValue:  0];
                self.rollAngle   = [AnimatedFloat    withValue:-90];
                self.position    = [AnimatedVector3D withValue:Vector3DMake(0, 2.3, -21)];  
                self.lookAt      = [AnimatedVector3D withValue:Vector3DMake(0, 2.3,   0)];  
            }
        }
    }
}

-(void)flattenAndThen:(simpleBlock)work
{
    self.pitchFactor = [AnimatedFloat withStartValue:self.pitchFactor.value endValue:1 forTime:(self.pitchAngle.value / 45.0)]; 
    
    self.pitchFactor.curve = AnimationEaseInOut;
    self.pitchFactor.onEnd = work;
}

-(void)unflattenAndThen:(simpleBlock)work
{
    self.pitchFactor = [AnimatedFloat withStartValue:self.pitchFactor.value endValue:1 forTime:(self.pitchAngle.value / 45.0)]; 
    
    self.pitchFactor.curve = AnimationEaseInOut;
    self.pitchFactor.onEnd = work;
}

@end