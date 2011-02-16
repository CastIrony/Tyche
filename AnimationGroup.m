//
//  AnimationGroup.m
//  Tyche
//
//  Created by Joel Bernstein on 2/8/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.
//

#import "AnimationGroup.h"

@implementation AnimationGroup

@synthesize animations = _animations;
@synthesize lastEndTime = _lastEndTime;

+(AnimationGroup*)animationGroup
{
    AnimationGroup* animationGroup = [[[AnimationGroup alloc] init] autorelease];
    
    animationGroup.animations = [NSSet set];
    animationGroup.lastEndTime = CACurrentMediaTime();
    
    return animationGroup;
}

-(void)addNewAbsoluteTime:(NSTimeInterval)time
{
    NSTimeInterval now = CACurrentMediaTime();    
    
    if(time > self.lastEndTime)
    {
        self.lastEndTime = time;
    }
}

-(void)addNewTime:(NSTimeInterval)delta
{
    [self addNewAbsoluteTime:CACurrentMediaTime() + delta];
}

-(void)addAnimation:(id<Animated>)animation
{
    [self addNewAbsoluteTime:animation.endTime];
}

-(void)finishAnimationsAndThen:(SimpleBlock)work
{
    NSTimeInterval now = CACurrentMediaTime();
    
    NSTimeInterval delta = self.lastEndTime - now;
    
    if (delta <= 0.0) 
    {
        RunLater(work);
    }
    else
    {
        RunAfterDelay(delta, work);
    }
}

@end