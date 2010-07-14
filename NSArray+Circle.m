#import "NSArray+Circle.h"

@implementation NSArray (Circle)

-(id)objectBefore:(id)object
{
    int objectIndex = [self indexOfObject:object] - 1;
    
    if(objectIndex == -1)
    {
        return [self lastObject];
    }
    else
    {
        return [self objectAtIndex:(objectIndex)];
    }
}

-(id)objectAfter:(id)object
{
    int objectIndex = [self indexOfObject:object] + 1;
    
    if(objectIndex == (int)self.count)
    {
        return [self objectAtIndex:0];
    }
    else
    {
        return [self objectAtIndex:(objectIndex)];
    }    
}

-(NSArray*)commonObjectsWithArray:(NSArray*)array
{
    NSMutableArray* common = [[[NSMutableArray alloc] init] autorelease];
    
    for(id object in self) 
    { 
        if([array containsObject:object]) 
        { 
            [common addObject:object]; 
        } 
    }
    
    return common;
}

-(id)objectBefore:(id)object commonWithArray:(NSArray*)array
{
    NSArray* common = [self commonObjectsWithArray:array];
    
    int objectIndex = [common indexOfObject:object] - 1;
    
    if(objectIndex == -1)
    {
        return [common lastObject];
    }
    else
    {
        return [common objectAtIndex:(objectIndex)];
    }
}

-(id)objectAfter:(id)object commonWithArray:(NSArray*)array
{
    NSArray* common = [self commonObjectsWithArray:array];
    
    int objectIndex = [common indexOfObject:object] + 1;
    
    if(objectIndex == (int)common.count)
    {
        return [common objectAtIndex:0];
    }
    else
    {
        return [common objectAtIndex:(objectIndex)];
    }    
}

-(NSArray*)map:(id(^)(id obj))block
{
    NSMutableArray* new = [NSMutableArray array];
    
    for(id obj in self)
    {
        id newObj = block(obj);
        [new addObject: newObj ? newObj : [NSNull null]];
    }
    
    return new;
}

@end
