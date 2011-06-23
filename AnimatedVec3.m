#import "AnimatedVec3.h"

@implementation AnimatedVec3 

@synthesize startValue = _startValue;
@synthesize startTime  = _startTime;

@synthesize endValue   = _endValue;
@synthesize endTime    = _endTime;

@synthesize curve      = _curve; 

@dynamic value;
@dynamic hasEnded;

+(id)vec3WithValue:(vec3)value
{
    NSTimeInterval now = CACurrentMediaTime();    
    
    AnimatedVec3* animatedVector = [[[AnimatedVec3 alloc] init] autorelease];
    
    animatedVector.startValue = value;
    animatedVector.endValue = value;
    animatedVector.startTime = now;
    animatedVector.endTime = now;
    
    return animatedVector;
}

-(void)setValue:(vec3)value
{
    NSTimeInterval now = CACurrentMediaTime();    
    
    self.startValue = value;
    self.endValue = value;
    self.startTime = now;
    self.endTime = now;
}

-(void)setValue:(vec3)value forTime:(NSTimeInterval)time
{
    NSTimeInterval now = CACurrentMediaTime();    
    
    self.startValue = self.value;
    self.endValue = value;
    self.startTime = now;
    self.endTime = now + time * TIMESCALE;
}

-(void)setValue:(vec3)value forTime:(NSTimeInterval)time andThen:(SimpleBlock)work
{
    NSTimeInterval now = CACurrentMediaTime();    
    
    self.startValue = self.value;
    self.endValue = value;
    self.startTime = now;
    self.endTime = now + time * TIMESCALE;
    
    [self finishAndThen:work];
}

-(void)setValue:(vec3)value forTime:(NSTimeInterval)time afterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work
{
    NSTimeInterval now = CACurrentMediaTime();    
    
    self.startValue = self.value;
    self.endValue = value;
    self.startTime = now + delay;
    self.endTime = now + (delay + time) * TIMESCALE;
    
    [self finishAndThen:work];
}

-(void)setValue:(vec3)value withSpeed:(GLfloat)speed
{    
    NSTimeInterval time = speed == 0 ? 0 : vec3Magnitude(vec3Subtract(value, self.value)) / speed; 
    
    NSTimeInterval now = CACurrentMediaTime();    
    
    self.startValue = self.value;
    self.endValue = value;
    self.startTime = now;
    self.endTime = now + time * TIMESCALE;
}

-(void)setValue:(vec3)value withSpeed:(GLfloat)speed andThen:(SimpleBlock)work
{    
    NSTimeInterval time = speed == 0 ? 0 : vec3Magnitude(vec3Subtract(value, self.value)) / speed; 
    
    NSTimeInterval now = CACurrentMediaTime();    
    
    self.startValue = self.value;
    self.endValue = value;
    self.startTime = now;
    self.endTime = now + time * TIMESCALE;
    
    [self finishAndThen:work];
}

-(void)setValue:(vec3)value withSpeed:(GLfloat)speed afterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work
{
    NSTimeInterval time = speed == 0 ? 0 : vec3Magnitude(vec3Subtract(value, self.value)) / speed; 
    
    NSTimeInterval now = CACurrentMediaTime();    
    
    self.startValue = self.value;
    self.endValue = value;
    self.startTime = now + delay;
    self.endTime = now + (delay + time) * TIMESCALE;
    
    [self finishAndThen:work];
}

-(void)finishAndThen:(SimpleBlock)work
{
    NSTimeInterval now = CACurrentMediaTime();    
    
    if(now > self.endTime)
    {
        RunLater(work);
    }
    else 
    {
        RunAfterDelay(self.endTime - now, work);
    }
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"[%f5] -> [%f5] (Duration:%f5)", _startValue, _endValue, _endTime - _startTime];
}

-(void)dealloc
{    
    [super dealloc];
}

-(GLfloat)delta
{
    NSTimeInterval now = CACurrentMediaTime();
    
    return clipFloat((now - self.startTime) / (self.endTime - self.startTime), 0, 1);
}

-(vec3)value
{
    NSTimeInterval now = CACurrentMediaTime();
    
    if(now < self.startTime) { return self.startValue; }
    if(now > self.endTime)   { return self.endValue; }
    
    GLfloat delta = [self delta];
    
    GLfloat delta2 = delta * delta;
    GLfloat delta3 = delta * delta2;
    
    if(self.curve == AnimationEaseIn)    { delta = (3 * delta - delta3) / 2; }
    if(self.curve == AnimationEaseOut)   { delta = (3 * delta2 - delta3) / 2; }
    if(self.curve == AnimationEaseInOut) { delta = (3 * delta2 - 2 * delta3); }
    
    return vec3Make((1.0 - delta) * self.startValue.x + (delta) * self.endValue.x, 
                        (1.0 - delta) * self.startValue.y + (delta) * self.endValue.y, 
                        (1.0 - delta) * self.startValue.z + (delta) * self.endValue.z);
}

-(BOOL)hasEnded
{
    return self.endTime + 0.1 < CACurrentMediaTime();
}

@end
