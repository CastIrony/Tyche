/*
 *  Touchable.h
 *  Studly
 *
 *  Created by Joel Bernstein on 7/26/09.
 *  Copyright 2009 Joel Bernstein. All rights reserved.
 *
 */

@class GLRenderer;

@protocol Touchable

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;

-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end