//
//  NSMutableArray+Shuffle.h
//  Tyche
//
//  Created by Joel Bernstein on 9/16/09.
//  Copyright 2009 Joel Bernstein. All rights reserved.
//

#import "Geometry.h"

@interface NSMutableArray (Deck)

-(void)shuffle;
-(id)randomObject;
-(id)popObject;

@end