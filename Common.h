#import "Constants.h"
#import "NSObject+Blocks.h"
#import "TinyProfiler.h"

#define TRANSACTION_BEGIN glPushMatrix(); @try
#define TRANSACTION_END @catch(NSException* exception) { NSLog(@"Error in transaction: %@", exception.callStackSymbols ); } @finally { glPopMatrix(); }

typedef void(^SimpleBlock)(void);

#define RUNBLOCK(work) if(work) { work(); }

static void RunUrgentlyInBackground(SimpleBlock block)
{
    if(!block) { return; }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block);
}

static void RunInBackground(SimpleBlock block)
{
    if(!block) { return; }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

static void RunOnMainThread(BOOL wait, SimpleBlock block)
{    
    if(!block) { return; }

    dispatch_async(dispatch_get_main_queue(), block);
}

static void RunLater(SimpleBlock block)
{
    if(!block) { return; }
    
    dispatch_async(dispatch_get_main_queue(), block);
}

static void RunAfterDelay(NSTimeInterval delay, SimpleBlock block)
{
    if(!block) { return; }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

static inline BOOL within(GLfloat float1, GLfloat float2, GLfloat epsilon)
{
    return float1 < float2 ? (float2 - float1 < epsilon) : (float1 - float2 < epsilon);
}

static inline GLfloat absf(GLfloat float1, GLfloat float2)
{
    return float1 < float2 ? float2 - float1 : float1 - float2;
}

static int roundPowerTwo(int number)
{
    if(number < 1) { return 0; }
    
    int result = 1;
    
    while(result < number) { result = result * 2; }
    
    return result;
}

static int clipInt(int value, int min, int max)
{
    if(value > max) { return max; }
    if(value < min) { return min; }
    
    return value;
}

static GLfloat clipFloat(GLfloat value, GLfloat min, GLfloat max)
{
    if(value > max) { return max; }
    if(value < min) { return min; }
    
    return value;
}

static GLfloat randomFloat(GLfloat min, GLfloat max)
{
    return drand48() * (max - min) + min;
}

static int randomSort(id obj1, id obj2, void* context) 
{     
    return (arc4random() % 3 - 1); // returns random number -1 0 1 
}

enum 
{
    AnimationEaseInOut,
    AnimationEaseIn,
    AnimationEaseOut,
    AnimationLinear
};
typedef NSUInteger AnimationCurve;
