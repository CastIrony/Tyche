#import "DisplayContainer.h"

@interface DisplayContainer () 
{
    
}

@implementation DisplayContainer

@synthesize keys;
@synthesize hashtable;

+(DisplayContainer*)container 
{
    return [[[DisplayContainer alloc] init] autorelease];
}

+(DisplayContainer*)containerWithKeys:(NSMutableArray*)keys hashtable:(NSMutableDictionary*)hashtable 
{
    DisplayContainer* container = [[[DisplayContainer alloc] init] autorelease];
    
    container.keys = keys;
    container.hashtable = hashtable;
    
    return container;
}

-(DisplayContainer*)insertObject:(id)object asFirstWithKey:(id)key 
{
    if([self.keys containsObject:key])
    {
        
    }
    else 
    {
        [self.hashtable setValue:object forKey:key];
        [self.keys insertObject:object atIndex:0];
    }

    return self; 
}

-(DisplayContainer*)insertObject:(id)object asLastWithKey:(id)key 
{
    if([self.keys containsObject:key])
    {
        
    }
    else 
    {
        [self.hashtable setValue:object forKey:key];
        [self.keys addObject:object];
    }
    
    return self; 
}

-(DisplayContainer*)insertObject:(id)object withKey:(id)key atIndex:(int)index 
{
    if([self.keys containsObject:key])
    {
        
    }
    else 
    {
        [self.hashtable setValue:object forKey:key];
        [self.keys insertObject:object atIndex:index];
    }
    
    return self; 
}

-(DisplayContainer*)insertObject:(id)object withKey:(id)key beforeKey:(id)before 
{
    return self; 
}

-(DisplayContainer*)insertObject:(id)object withKey:(id)key afterKey:(id)after 
{
    return self; 
}


-(DisplayContainer*)moveKeyToFirst:(id)key 
{
    return self; 
}

-(DisplayContainer*)moveKeyToLast:(id)key 
{
    return self; 
}

-(DisplayContainer*)moveKey:(id)key toIndex:(int)index 
{
    return self; 
}

-(DisplayContainer*)moveKey:(id)key beforeKey:(id)before 
{
    return self; 
}

-(DisplayContainer*)moveKey:(id)key afterKey:(id)after 
{
    return self; 
}


-(DisplayContainer*)pruneObjectsForKey:(id)key toFormat:(NSString*)format 
{
    return self; 
}


-(NSArray*)objectsForKey:(id)key 
{
    return nil; 
}

-(id)topObjectForKey:(id)key 
{
    return nil; 
}

-(NSEnumerator*)keyEnumerator 
{
    return nil; 
}

-(NSEnumerator*)objectEnumerator 
{
    return nil; 
}

-(NSEnumerator*)topObjectEnumerator 
{
    return nil; 
}


-(NSEnumerator*)reverseKeyEnumerator 
{
    return nil; 
}

-(NSEnumerator*)reverseObjectEnumerator 
{
    return nil; 
}

-(NSEnumerator*)reverseTopObjectEnumerator 
{
    return nil; 
}

@end