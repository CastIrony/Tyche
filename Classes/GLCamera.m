#import "GLRenderer.h"
#import "GLCamera.h"

@implementation GLCamera

+(GLCamera*)camera
{
    return [[[GLCamera alloc] init] autorelease];
}

@synthesize renderer    = _renderer;
@synthesize position    = _position;
@synthesize lookAt      = _lookAt;
@synthesize pitchAngle  = _pitchAngle;
@synthesize pitchFactor = _pitchFactor;
@synthesize rollAngle   = _rollAngle;
@synthesize flipAngle   = _flipAngle;
@synthesize isAutomatic = _isAutomatic;
@synthesize status      = _status;
@synthesize menuVisible = _menuVisible;

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.lookAt      = [AnimatedVec3 vec3WithValue:vec3Make(0, 2.3,   0)];  
        self.position    = [AnimatedVec3 vec3WithValue:vec3Make(0, 2.3, -21)];  
        self.pitchAngle  = [AnimatedFloat floatWithValue:  0];
        self.rollAngle   = [AnimatedFloat floatWithValue:-90];
        self.pitchFactor = [AnimatedFloat floatWithValue:  1];
        self.status      = CameraStatusNormal;
        
        self.isAutomatic = !TARGET_IPHONE_SIMULATOR;
        
        [self updateCamera];
    }
    
    return self;
}

-(void)setMenuVisible:(BOOL)value
{
    _menuVisible = value;
    
    [self updateCamera];
}

-(void)setStatus:(GLCameraStatus)status
{
    _status = status;
    
    [self updateCamera];
}

-(void)updateCamera
{
    if(self.menuVisible)
    {
        [self.pitchFactor setValue:0 forTime:1]; 
        [self.rollAngle   setValue:0 forTime:1]; 
        
        [self.position setValue:vec3Make(0, 0.0, -9 * ZOOMSCALE) forTime:1];  
        [self.lookAt setValue:vec3Make(0, 0.0, 0) forTime:1]; 
    }
    else 
    {
        if(self.status == CameraStatusCardsFlipped)
        {
            [self.pitchFactor setValue:1   forTime:1]; 
            [self.rollAngle   setValue:-90 forTime:1]; 
            
            [self.position setValue:vec3Make(0, 2.3, -25 * ZOOMSCALE) forTime:1]; 
            [self.lookAt setValue:vec3Make(0, 2.3, 0) forTime:1]; 
        }
        else 
        {
            [self.pitchFactor setValue:1   forTime:1]; 
            [self.rollAngle   setValue:-90 forTime:1]; 

            [self.position setValue:vec3Make(0, 2.3, -21 * ZOOMSCALE) forTime:1];  
            [self.lookAt setValue:vec3Make(0, 2.3,   0) forTime:1];  
        }
    }
}

//TODO: one of these is wrong, but I think it was intentional

-(void)flattenAndThen:(SimpleBlock)work
{
    [self.pitchFactor setValue:1 forTime:(self.pitchAngle.value / 45.0) andThen:work]; 
}

-(void)unflattenAndThen:(SimpleBlock)work
{
    [self.pitchFactor setValue:1 forTime:(self.pitchAngle.value / 45.0) andThen:work]; 
}

@end