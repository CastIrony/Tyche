//
//  AnimationGroup.h
//  Studly
//
//  Created by Joel Bernstein on 2/8/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.
//

#import "Common.h"

@protocol Animated

-(void)finishAndThen:(SimpleBlock)work;

@end

@interface AnimationGroup : NSObject <Animated>

@property (nonatomic, assign) dispatch_queue_t queue;
@property (nonatomic, copy) SimpleBlock work;

+(AnimationGroup*)animationGroup;

-(void)addAbsoluteTime:(NSTimeInterval)time;
-(void)addTimeDelta:(NSTimeInterval)delta;
-(void)addAnimation:(id<Animated>)animation;

-(NSString*)acquireToken;

-(void)redeemToken:(NSString*)token;
-(void)redeemToken:(NSString*)token atAbsoluteTime:(NSTimeInterval)time;
-(void)redeemToken:(NSString*)token atTimeDelta:(NSTimeInterval)delta;
-(void)redeemToken:(NSString*)token afterAnimation:(id<Animated>)animation;

-(void)finishAndThen:(SimpleBlock)work;
-(void)checkTokens;

@end
