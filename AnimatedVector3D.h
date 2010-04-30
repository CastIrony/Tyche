#import "Constants.h"
#import "Common.h"
#import "Geometry.h"

@interface AnimatedVector3D : NSObject 
{
    Vector3D       _startValue;
    NSTimeInterval _startTime;
    block          _onStart;      
    BOOL           _hasStarted;
    
    Vector3D       _endValue;
    NSTimeInterval _endTime;
    block          _onEnd;    
    BOOL           _hasEnded;

    AnimationCurve _curve;
}

@property (nonatomic, assign)   Vector3D       startValue;
@property (nonatomic, assign)   NSTimeInterval startTime;
@property (nonatomic, copy)     block          onStart;      
@property (nonatomic, readonly) BOOL           hasStarted;

@property (nonatomic, assign)   Vector3D       endValue;
@property (nonatomic, assign)   NSTimeInterval endTime;
@property (nonatomic, copy)     block          onEnd;    
@property (nonatomic, readonly) BOOL           hasEnded;

@property (nonatomic, assign)   AnimationCurve curve;

@property (nonatomic, assign)   Vector3D        value;

+(id)withValue:(Vector3D)value;

+(id)withStartValue:(Vector3D)startValue endValue:(Vector3D)endValue speed:(GLfloat)speed;
+(id)withStartValue:(Vector3D)startValue endValue:(Vector3D)endValue forTime:(NSTimeInterval)time;

-(NSString*)description;

@end