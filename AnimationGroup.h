//
//  AnimationGroup.h
//  Tyche
//
//  Created by Joel Bernstein on 2/8/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.
//

#import "Common.h"

@protocol Animated

@property (nonatomic, assign)   GLfloat        startValue;
@property (nonatomic, assign)   NSTimeInterval startTime;

@property (nonatomic, assign)   GLfloat        endValue;
@property (nonatomic, assign)   NSTimeInterval endTime;

@property (nonatomic, assign)   AnimationCurve curve;

@property (nonatomic, readonly) GLfloat        value;
@property (nonatomic, readonly) BOOL           hasEnded;

-(void)registerEvent:(SimpleBlock)work;

@end

@interface AnimationGroup : NSObject

@property (nonatomic, copy) NSSet* animations;
@property (nonatomic, assign) NSTimeInterval lastEndTime;

+(AnimationGroup*)animationGroup;

-(void)addNewAbsoluteTime:(NSTimeInterval)time;
-(void)addNewTime:(NSTimeInterval)delta;
-(void)addAnimation:(id<Animated>)animation;
-(void)finishAnimationsAndThen:(SimpleBlock)work;

@end