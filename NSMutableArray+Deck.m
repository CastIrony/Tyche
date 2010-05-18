//
//  NSMutableArray+Shuffle.m
//  Tyche
//
//  Created by Joel Bernstein on 9/16/09.
//  Copyright 2009 Joel Bernstein. All rights reserved.
//

#import "NSMutableArray+Deck.h"

@implementation NSMutableArray (Deck)

-(void)shuffle 
{     
    srand48(time(NULL));
    
    for(int i = 0; i < 10; i++)
    {
        [self sortUsingFunction:randomSort context:nil]; 
    }
}

-(id)randomObject
{
    srand48(time(NULL));
    
    int objectIndex = arc4random() % self.count;
    
    return [self objectAtIndex:objectIndex];
}

-(id)popObject
{
    id object = [[[self lastObject] retain] autorelease];
    
    [self removeObject:object];
    
    return object;
}

@end