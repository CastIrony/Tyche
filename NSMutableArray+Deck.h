//
//  NSMutableArray+Shuffle.h
//  Studly
//
//  Created by Joel Bernstein on 9/16/09.
//  Copyright 2009 Joel Bernstein. All rights reserved.
//

#import "MC3DVector.h"

@interface NSMutableArray (Deck)

-(void)shuffle;
-(id)randomObject;
-(id)popObject;

@end