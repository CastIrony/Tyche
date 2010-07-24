#import "AnimatedFloat.h"

@implementation AnimatedFloat 

@synthesize startValue = _startValue;
@synthesize startTime  = _startTime;

@synthesize endValue   = _endValue;
@synthesize endTime    = _endTime;

@synthesize curve      = _curve; 

@dynamic value;
@dynamic hasEnded;

-(id)initWithStartValue:(GLfloat)startValue endValue:(GLfloat)endValue startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime
{
    self = [super init];
    
    if(self)
    {
        _startValue  = startValue;
        _startTime   = startTime;
        _endValue    = endValue;
        _endTime     = startTime + TIMESCALE * animate * (endTime - startTime);
        _curve       = AnimationEaseInOut;
    }
    
    return self;
}

+(id)withValue:(GLfloat)value
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    
    
    return [[[AnimatedFloat alloc] initWithStartValue:value endValue:value startTime:now endTime:now] autorelease];
}

-(void)setValue:(GLfloat)value forTime:(NSTimeInterval)time andThen:(simpleBlock)work
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    
        
    self.startValue = self.value;
    self.endValue = value;
    self.startTime = now;
    self.endTime = now + time;

    [self registerEvent:work];
}

-(void)setValue:(GLfloat)value withSpeed:(GLfloat)speed andThen:(simpleBlock)work
{    
    NSTimeInterval time = speed == 0 ? 0 : absf(self.value, value) / speed; 

    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    
   
    runAfterDelay(time, work);
    
    self.startValue = self.value;
    self.endValue = value;
    self.startTime = now;
    self.endTime = now + time;

    [self registerEvent:work];
}

-(void)registerEvent:(simpleBlock)work
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    

    if(now > self.endTime)
    {
        runLater(work);
    }
    else 
    {
        runAfterDelay(self.endTime - now, work);
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
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();
    
    if(now < self.startTime) { return self.startValue; }
    if(now > self.endTime)   { return self.endValue; }
    
    GLfloat delta = (now - self.startTime) / (self.endTime - self.startTime);
    
    GLfloat delta2 = delta * delta;
    GLfloat delta3 = delta * delta2;
        
    if(self.curve == AnimationEaseIn)    { delta = (3 * delta - delta3) / 2; }
    if(self.curve == AnimationEaseOut)   { delta = (3 * delta2 - delta3) / 2; }
    if(self.curve == AnimationEaseInOut) { delta = (3 * delta2 - 2 * delta3); }
    
    return (1.0 - delta) * self.startValue + (delta) * self.endValue;
}

-(BOOL)hasEnded
{
    return self.endTime < CFAbsoluteTimeGetCurrent();
}

@end
