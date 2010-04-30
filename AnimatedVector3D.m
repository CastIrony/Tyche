#import "AnimatedVector3D.h"

@interface AnimatedVector3D ()

@property (nonatomic, assign) BOOL hasStarted;
@property (nonatomic, assign) BOOL hasEnded;

@end

@implementation AnimatedVector3D 

@synthesize startValue = _startValue;
@synthesize startTime  = _startTime;
@synthesize onStart    = _onStart;      
@synthesize hasStarted = _hasStarted;

@synthesize endValue   = _endValue;
@synthesize endTime    = _endTime;
@synthesize onEnd      = _onEnd;    
@synthesize hasEnded   = _hasEnded;
@synthesize curve      = _curve; 

@dynamic value;

-(id)initWithStartValue:(Vector3D)startValue endValue:(Vector3D)endValue startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime onStart:(block)onStart onEnd:(block)onEnd
{
    self = [super init];
    
    if(self)
    {
        _startValue  = startValue;
        _startTime   = startTime;
        _endValue    = endValue;
        _endTime     = startTime + TIMESCALE * (endTime - startTime);
        _hasStarted  = NO;
        _hasEnded    = NO;
        _curve       = AnimationLinear;
        
        self.onStart = onStart;      
        self.onEnd   = onEnd;  
    }
    
    return self;
}

+(id)withValue:(Vector3D)value
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    
    
    return [[[AnimatedVector3D alloc] initWithStartValue:value endValue:value startTime:now endTime:now onStart:nil onEnd:nil] autorelease];
}

+(id)withStartValue:(Vector3D)startValue endValue:(Vector3D)endValue speed:(GLfloat)speed
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    
    
    if(speed == 0)
    {
        return [[[AnimatedVector3D alloc] initWithStartValue:startValue endValue:endValue startTime:now endTime:now onStart:nil onEnd:nil] autorelease];
    }
    else 
    {
        Vector3D difference = Vector3DMakeWithStartAndEndPoints(startValue, endValue);
                
        GLfloat length = Vector3DMagnitude(difference);
       
        return [[[AnimatedVector3D alloc] initWithStartValue:startValue endValue:endValue startTime:now endTime:now + length / abs(speed) onStart:nil onEnd:nil] autorelease];
    }
}

+(id)withStartValue:(Vector3D)startValue endValue:(Vector3D)endValue forTime:(NSTimeInterval)timeInterval
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    
    
    return [[[AnimatedVector3D alloc] initWithStartValue:startValue endValue:endValue startTime:now endTime:now + timeInterval onStart:nil onEnd:nil] autorelease];
}

-(void)dealloc
{
    [_onStart release];
    [_onEnd   release];
    
    [super dealloc];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"[%f5, %f5, %f5] -> [%f5, %f5, %f5]", _startValue.x, _startValue.y, _startValue.z, _endValue.x, _endValue.y, _endValue.z];
}

-(Vector3D)value
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();
    
    if(now > self.startTime && !self.hasStarted) 
    {
        if(self.onStart) { self.onStart(); } 
        self.hasStarted = YES;         
    }
    
    if(now > self.endTime && !self.hasEnded) 
    { 
        if(self.onEnd) { self.onEnd(); }
        self.hasEnded = YES; 
    }
    
    if(now < self.startTime) { return self.startValue; }
    if(now > self.endTime)   { return self.endValue; }
    
    GLfloat delta = (now - self.startTime) / (self.endTime - self.startTime);
    
    GLfloat delta2 = delta * delta;
    GLfloat delta3 = delta * delta2;
    
    GLfloat proportion = delta;
    
    if(self.curve == AnimationEaseIn)
    {
        proportion = (3 * delta - delta3) / 2; 
    }
    
    if(self.curve == AnimationEaseOut)
    {
        proportion = (3 * delta2 - delta3) / 2;
    }
    
    if(self.curve == AnimationEaseInOut)
    {
        proportion = 3 * delta2 - 2 * delta3;
    }
    
    return Vector3DInterpolate(self.startValue, self.endValue, proportion);
}

-(void)setValue:(Vector3D)value
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();
    
    self.startTime  = now;
    self.endTime    = now;
    self.startValue = value;
    self.endValue   = value;
    self.hasStarted = YES;
    self.hasEnded   = YES;
}

@end