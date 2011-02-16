#import "Constants.h"
#import "Common.h"
#import "AnimationGroup.h"

@interface AnimatedFloat : NSObject <Animated>

@property (nonatomic, assign)   GLfloat        startValue;
@property (nonatomic, assign)   NSTimeInterval startTime;

@property (nonatomic, assign)   GLfloat        endValue;
@property (nonatomic, assign)   NSTimeInterval endTime;

@property (nonatomic, assign)   AnimationCurve curve;

@property (nonatomic, readonly) GLfloat value;
@property (nonatomic, readonly) BOOL    hasEnded;

+(id)withValue:(GLfloat)value;

-(void)setValue:(GLfloat)value;

-(void)setValue:(GLfloat)value forTime:(NSTimeInterval)time;
-(void)setValue:(GLfloat)value forTime:(NSTimeInterval)time andThen:(SimpleBlock)work;
-(void)setValue:(GLfloat)value forTime:(NSTimeInterval)time afterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work;

-(void)setValue:(GLfloat)value withSpeed:(GLfloat)speed;
-(void)setValue:(GLfloat)value withSpeed:(GLfloat)speed andThen:(SimpleBlock)work;
-(void)setValue:(GLfloat)value withSpeed:(GLfloat)speed afterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work;

-(void)registerEvent:(SimpleBlock)work;

-(NSString*)description;

@end
