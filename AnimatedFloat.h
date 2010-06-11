#import "Constants.h"
#import "Common.h"
#import "Geometry.h"

@interface AnimatedFloat : NSObject 
{
    GLfloat        _startValue;
    NSTimeInterval _startTime;
    simpleBlock          _onStart;      
    BOOL           _hasStarted;
     
    GLfloat        _endValue;
    NSTimeInterval _endTime;
    simpleBlock          _onEnd;    
    BOOL           _hasEnded;

    AnimationCurve _curve;
}

@property (nonatomic, assign)   GLfloat        startValue;
@property (nonatomic, assign)   NSTimeInterval startTime;
@property (nonatomic, copy)     simpleBlock          onStart;      
@property (nonatomic, readonly) BOOL           hasStarted;

@property (nonatomic, assign)   GLfloat        endValue;
@property (nonatomic, assign)   NSTimeInterval endTime;
@property (nonatomic, copy)     simpleBlock          onEnd;    
@property (nonatomic, readonly) BOOL           hasEnded;

@property (nonatomic, assign)   AnimationCurve curve;

@property (nonatomic, readonly)   GLfloat        value;

+(id)withValue:(GLfloat)value;
+(id)withStartValue:(GLfloat)startValue endValue:(GLfloat)endValue speed:(GLfloat)speed;
+(id)withStartValue:(GLfloat)startValue endValue:(GLfloat)endValue forTime:(NSTimeInterval)time;

-(NSString*)description;

@end
