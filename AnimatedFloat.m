#import "AnimatedFloat.h"

@implementation AnimatedFloat 

@synthesize startValue = _startValue;
@synthesize startTime  = _startTime;

@synthesize endValue   = _endValue;
@synthesize endTime    = _endTime;

@synthesize curve      = _curve; 

@dynamic proportion;
@dynamic value;
@dynamic hasEnded;

+(id)floatWithValue:(GLfloat)value
{
    NSTimeInterval now = CACurrentMediaTime();    
    
    AnimatedFloat* animatedFloat = [[[AnimatedFloat alloc] init] autorelease];
    
    animatedFloat.startValue = value;
    animatedFloat.endValue   = value;
    animatedFloat.startTime  = now;
    animatedFloat.endTime    = now;
    
    return animatedFloat;
}

-(GLfloat)proportion
{
    NSTimeInterval now = CACurrentMediaTime();
    
    return clipFloat((now - self.startTime) / (self.endTime - self.startTime), 0, 1);
}

-(void)setValue:(GLfloat)value
{
    NSTimeInterval now = CACurrentMediaTime();    
    
    self.startValue = value;
    self.endValue   = value;
    self.startTime  = now;
    self.endTime    = now;
}

-(void)setValue:(GLfloat)value forTime:(NSTimeInterval)time
{
    GLfloat proportion = self.proportion;
        
    NSTimeInterval now = CACurrentMediaTime();    
    
    BOOL finished = YES;//within(proportion, 1.000, 0.001);
    
    NSTimeInterval endTime    = now + time * TIMESCALE;
    GLfloat        endValue   = value;
    NSTimeInterval startTime  = finished ? now        : endTime  - (endTime  - now)        / (1.0 - proportion);
    GLfloat        startValue = finished ? self.value : endValue - (endValue - self.value) / (1.0 - proportion);
    
    self.endTime    = endTime;
    self.startTime  = startTime;
    self.endValue   = endValue;
    self.startValue = startValue;
}

-(void)setValue:(GLfloat)value forTime:(NSTimeInterval)time andThen:(SimpleBlock)work
{
    GLfloat proportion = self.proportion;
    GLfloat currentValue = proportion * self.endValue + (1.0 - proportion) * self.startValue;
    
    NSTimeInterval now = CACurrentMediaTime();    
        
    BOOL finished = YES;//within(proportion, 1.000, 0.001);
    
    NSTimeInterval endTime    = now + time * TIMESCALE;
    GLfloat        endValue   = value;
    NSTimeInterval startTime  = finished ? now        : (endTime * proportion - now) / (proportion - 1.0);
    GLfloat        startValue = finished ? self.value : endValue + ((currentValue - endValue) / (now - endTime)) * (startTime - endTime);
        
    self.endTime    = endTime;
    self.startTime  = startTime;
    self.endValue   = endValue;
    self.startValue = startValue;

    [self finishAndThen:work];
}

-(void)setValue:(GLfloat)value forTime:(NSTimeInterval)time afterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work
{
    GLfloat proportion = self.proportion;
    
    NSTimeInterval now = CACurrentMediaTime();    
        
    BOOL finished = YES;//within(proportion, 1.000, 0.001);
    
    NSTimeInterval endTime    = now + time * TIMESCALE;
    GLfloat        endValue   = value;
    NSTimeInterval startTime  = finished ? now        : now        - (endTime  - now)        / (1.0 - proportion);
    GLfloat        startValue = finished ? self.value : self.value - (endValue - self.value) / (1.0 - proportion);
    
    self.endTime    = endTime + TIMESCALE * delay;
    self.startTime  = startTime + TIMESCALE * delay;
    self.endValue   = endValue;
    self.startValue = startValue;

    [self finishAndThen:work];
}

-(void)setValue:(GLfloat)value withSpeed:(GLfloat)speed
{    
    GLfloat proportion = self.proportion;
    
    NSTimeInterval time = speed == 0 ? 0 : distance(self.value, value) / speed; 

    NSTimeInterval now = CACurrentMediaTime();    
    
    BOOL finished = YES;//within(proportion, 1.000, 0.001);
    
    NSTimeInterval endTime    = now + time * TIMESCALE;
    GLfloat        endValue   = value;
    NSTimeInterval startTime  = finished ? now        : now        - (endTime  - now)        / (1.0 - proportion);
    GLfloat        startValue = finished ? self.value : self.value - (endValue - self.value) / (1.0 - proportion);
    
    self.endTime    = endTime;
    self.startTime  = startTime;
    self.endValue   = endValue;
    self.startValue = startValue;
}

-(void)setValue:(GLfloat)value withSpeed:(GLfloat)speed andThen:(SimpleBlock)work
{    
    GLfloat proportion = self.proportion;
    
    NSTimeInterval time = speed == 0 ? 0 : distance(self.value, value) / speed; 

    NSTimeInterval now = CACurrentMediaTime();    
       
    BOOL finished = YES;//within(proportion, 1.000, 0.001);
    
    NSTimeInterval endTime    = now + time * TIMESCALE;
    GLfloat        endValue   = value;
    NSTimeInterval startTime  = finished ? now        : now        - (endTime  - now)        / (1.0 - proportion);
    GLfloat        startValue = finished ? self.value : self.value - (endValue - self.value) / (1.0 - proportion);
    
    self.endTime    = endTime;
    self.startTime  = startTime;
    self.endValue   = endValue;
    self.startValue = startValue;

    [self finishAndThen:work];
}

-(void)setValue:(GLfloat)value withSpeed:(GLfloat)speed afterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work
{
    GLfloat proportion = self.proportion;
    
    NSTimeInterval time = speed == 0 ? 0 : distance(self.value, value) / speed; 

    NSTimeInterval now = CACurrentMediaTime();    
    
    BOOL finished = YES;//within(proportion, 1.000, 0.001);
    
    NSTimeInterval endTime    = now + time * TIMESCALE;
    GLfloat        endValue   = value;
    NSTimeInterval startTime  = finished ? now        : now        - (endTime  - now)        / (1.0 - proportion);
    GLfloat        startValue = finished ? self.value : self.value - (endValue - self.value) / (1.0 - proportion);
    
    self.endTime    = endTime + TIMESCALE * delay;
    self.startTime  = startTime + TIMESCALE * delay;
    self.endValue   = endValue;
    self.startValue = startValue;

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

-(GLfloat)value
{
    NSTimeInterval now = CACurrentMediaTime();
    
    if(now < self.startTime) { return self.startValue; }
    if(now > self.endTime)   { return self.endValue; }
    
    GLfloat proportion = [self proportion];
    
    GLfloat proportion2 = proportion * proportion;
    GLfloat proportion3 = proportion * proportion2;
        
    if(self.curve == AnimationEaseIn)    { proportion = (3 * proportion - proportion3) / 2; }
    if(self.curve == AnimationEaseOut)   { proportion = (3 * proportion2 - proportion3) / 2; }
    if(self.curve == AnimationEaseInOut) { proportion = (3 * proportion2 - 2 * proportion3); }
    
    return (1.0 - proportion) * self.startValue + (proportion) * self.endValue;
}

-(BOOL)hasEnded
{
    return self.endTime + 0.1 < CACurrentMediaTime();
}

@end
