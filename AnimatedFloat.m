#import "AnimatedFloat.h"

@interface AnimatedFloat ()

@property (nonatomic, assign) BOOL hasStarted;
@property (nonatomic, assign) BOOL hasEnded;

@end

@implementation AnimatedFloat 

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

-(id)initWithStartValue:(GLfloat)startValue endValue:(GLfloat)endValue startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime onStart:(block)onStart onEnd:(block)onEnd
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

+(id)withValue:(GLfloat)value
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    
    
    return [[[AnimatedFloat alloc] initWithStartValue:value endValue:value startTime:now endTime:now onStart:nil onEnd:nil] autorelease];
}

+(id)withStartValue:(GLfloat)startValue endValue:(GLfloat)endValue speed:(GLfloat)speed
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    
    
    if(speed == 0)
    {
        return [[[AnimatedFloat alloc] initWithStartValue:startValue endValue:endValue startTime:now endTime:now onStart:nil onEnd:nil] autorelease];
    }
    else 
    {
        return [[[AnimatedFloat alloc] initWithStartValue:startValue endValue:endValue startTime:now endTime:now + absf(endValue, startValue) / speed onStart:nil onEnd:nil] autorelease];
    }
}

+(id)withStartValue:(GLfloat)startValue endValue:(GLfloat)endValue forTime:(NSTimeInterval)timeInterval
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    
    
    return [[[AnimatedFloat alloc] initWithStartValue:startValue endValue:endValue startTime:now endTime:now + timeInterval onStart:nil onEnd:nil] autorelease];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"[%f5] -> [%f5]", _startValue, _endValue];
}

-(void)dealloc
{
    [_onStart release];
    [_onEnd   release];
    
    [super dealloc];
}

-(GLfloat)value
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();
    
    if(now > self.startTime && !self.hasStarted) 
    {
        if(self.onStart) { runLater(self.onStart); } 
        self.hasStarted = YES;         
    }
    
    if(now > self.endTime && !self.hasEnded) 
    { 
        if(self.onEnd) { runLater(self.onEnd); }
        self.hasEnded = YES; 
    }
    
    if(now < self.startTime) { return self.startValue; }
    if(now > self.endTime)   { return self.endValue; }
    
    GLfloat delta = (now - self.startTime) / (self.endTime - self.startTime);
    
    GLfloat proportion = delta;
    
    if(self.curve == AnimationEaseIn)    { proportion = (3 * delta - delta * delta * delta) / 2; }
    if(self.curve == AnimationEaseOut)   { proportion = (3 * delta * delta - delta * delta * delta) / 2; }
    if(self.curve == AnimationEaseInOut) { proportion = (3 * delta * delta - 2 * delta * delta * delta); }
     
    return (1.0 - proportion) * self.startValue + (proportion) * self.endValue;
}

-(void)setValue:(GLfloat)value
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
