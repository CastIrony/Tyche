//
//  AnimationGroup.m
//  Studly
//
//  Created by Joel Bernstein on 2/8/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.
//

#import "NSString+Documents.h"
#import "AnimationGroup.h"

@interface AnimationGroup ()

@property (nonatomic, retain) NSMutableSet* tokens;

@end

@implementation AnimationGroup

@synthesize queue  = _queue;
@synthesize tokens = _tokens;
@synthesize work   = _work;

+(AnimationGroup*)animationGroup
{
    AnimationGroup* animationGroup = [[[AnimationGroup alloc] init] autorelease];
    
    return animationGroup;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.tokens = [NSMutableSet set];
        
        self.queue = dispatch_queue_create("AnimationGroupTokens", NULL);
    }
    
    return self;
}

-(void)addTimeDelta:(NSTimeInterval)delta
{
    [self redeemToken:[self acquireToken] atTimeDelta:delta];
}

-(void)addAbsoluteTime:(NSTimeInterval)time
{
    [self redeemToken:[self acquireToken] atAbsoluteTime:time];
}

-(void)addAnimation:(id<Animated>)animation
{
    [self redeemToken:[self acquireToken] afterAnimation:animation];
}

-(NSString*)acquireToken
{
    NSString* token = [NSString stringWithUUID];
    
    dispatch_sync(self.queue, ^{ [self.tokens addObject:token]; });
        
    return token;
}

-(void)redeemToken:(NSString*)token
{
    dispatch_async(self.queue, ^
    { 
        [self.tokens removeObject:token];
        [self checkTokens];
    });
}

-(void)redeemToken:(NSString*)token atTimeDelta:(NSTimeInterval)delta
{
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delta * NSEC_PER_SEC));
    
    dispatch_after(delay, self.queue, ^
    {
        [self.tokens removeObject:token];
        [self checkTokens];
    });
}

-(void)redeemToken:(NSString*)token atAbsoluteTime:(NSTimeInterval)time
{
    NSTimeInterval delta = time - CACurrentMediaTime();
    
    if(delta > 0.0)
    {
        [self redeemToken:token atTimeDelta:delta];
    }
    else
    {
        [self redeemToken:token];
    }
}

-(void)redeemToken:(NSString*)token afterAnimation:(id<Animated>)animation
{    
    [animation finishAndThen:^{ [self redeemToken:token]; }];
}

-(void)finishAndThen:(SimpleBlock)work
{    
    self.work = work;
    
    [self checkTokens];
}

-(void)checkTokens
{
    dispatch_async(self.queue, ^
    {         
        if(self.tokens.count == 0)
        {            
            if(self.work) 
            { 
                dispatch_sync(dispatch_get_main_queue(), self.work);
                
                self.work = nil;
            }
        }
    });
}

-(void)dealloc
{
    self.tokens = nil;
    self.work = nil;
    
    dispatch_release(self.queue);
}

@end