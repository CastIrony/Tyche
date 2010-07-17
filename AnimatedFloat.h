#import "Constants.h"
#import "Common.h"
#import "Geometry.h"

@interface AnimatedFloat : NSObject 

@property (nonatomic, assign)   GLfloat        startValue;
@property (nonatomic, assign)   NSTimeInterval startTime;
@property (nonatomic, copy)     simpleBlock    onStart;      
@property (nonatomic, assign)   BOOL           hasStarted;

@property (nonatomic, assign)   GLfloat        endValue;
@property (nonatomic, assign)   NSTimeInterval endTime;
@property (nonatomic, copy)     simpleBlock    onEnd;    
@property (nonatomic, assign)   BOOL           hasEnded;

@property (nonatomic, assign)   AnimationCurve curve;

@property (nonatomic, readonly) GLfloat      value;

+(id)withValue:(GLfloat)value;
+(id)withStartValue:(GLfloat)startValue endValue:(GLfloat)endValue forTime:(NSTimeInterval)time;
+(id)withStartValue:(GLfloat)startValue endValue:(GLfloat)endValue speed:(GLfloat)speed;

-(NSString*)description;

@end
