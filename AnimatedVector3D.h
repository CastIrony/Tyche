#import "Constants.h"
#import "Common.h"
#import "Geometry.h"

@interface AnimatedVector3D : NSObject 

@property (nonatomic, assign)   Vector3D       startValue;
@property (nonatomic, assign)   NSTimeInterval startTime;
@property (nonatomic, copy)     simpleBlock    onStart;      
@property (nonatomic, readonly) BOOL           hasStarted;

@property (nonatomic, assign)   Vector3D       endValue;
@property (nonatomic, assign)   NSTimeInterval endTime;
@property (nonatomic, copy)     simpleBlock    onEnd;    
@property (nonatomic, readonly) BOOL           hasEnded;

@property (nonatomic, assign)   AnimationCurve curve;

@property (nonatomic, readonly)   Vector3D        value;

+(id)withValue:(Vector3D)value;

+(id)withStartValue:(Vector3D)startValue endValue:(Vector3D)endValue forTime:(NSTimeInterval)time;
+(id)withStartValue:(Vector3D)startValue endValue:(Vector3D)endValue speed:(GLfloat)speed;

-(NSString*)description;

@end