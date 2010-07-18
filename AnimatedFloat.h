#import "Constants.h"
#import "Common.h"
#import "Geometry.h"

@interface AnimatedFloat : NSObject 

@property (nonatomic, assign)   GLfloat        startValue;
@property (nonatomic, assign)   NSTimeInterval startTime;
@property (nonatomic, assign)   BOOL           hasStarted;

@property (nonatomic, assign)   GLfloat        endValue;
@property (nonatomic, assign)   NSTimeInterval endTime;
@property (nonatomic, assign)   BOOL           hasEnded;

@property (nonatomic, assign)   AnimationCurve curve;

@property (nonatomic, readonly) GLfloat      value;

+(id)withValue:(GLfloat)value;

-(void)setValue:(GLfloat)value forTime:(NSTimeInterval)time andThen:(simpleBlock)work;
-(void)setValue:(GLfloat)value withSpeed:(GLfloat)time andThen:(simpleBlock)work;

-(NSString*)description;

@end
