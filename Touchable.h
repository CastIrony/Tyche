/*
 *  Touchable.h
 *  Tyche
 *
 *  Created by Joel Bernstein on 7/26/09.
 *  Copyright 2009 Joel Bernstein. All rights reserved.
 *
 */

@class GameRenderer;

@protocol Touchable

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;

-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

//@property (nonatomic, assign) id owner;

//@property (nonatomic, assign) GameRenderer* renderer;

@end