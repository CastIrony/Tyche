#import "Constants.h"
#import "Common.h"
#import "MC3DVector.h"
#import "AnimationGroup.h"

@interface AnimatedVec3 : NSObject <Animated>

@property (nonatomic, assign)   vec3       startValue;
@property (nonatomic, assign)   NSTimeInterval startTime;

@property (nonatomic, assign)   vec3       endValue;
@property (nonatomic, assign)   NSTimeInterval endTime;

@property (nonatomic, assign)   AnimationCurve curve;

@property (nonatomic, readonly) vec3 value;
@property (nonatomic, readonly) BOOL     hasEnded;

+(id)vec3WithValue:(vec3)value;

-(void)setValue:(vec3)value;

-(void)setValue:(vec3)value forTime:(NSTimeInterval)time;
-(void)setValue:(vec3)value forTime:(NSTimeInterval)time andThen:(SimpleBlock)work;
-(void)setValue:(vec3)value forTime:(NSTimeInterval)time afterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work;

-(void)setValue:(vec3)value withSpeed:(GLfloat)speed;
-(void)setValue:(vec3)value withSpeed:(GLfloat)speed andThen:(SimpleBlock)work;
-(void)setValue:(vec3)value withSpeed:(GLfloat)speed afterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work;

-(void)finishAndThen:(SimpleBlock)work;

-(NSString*)description;

@end
