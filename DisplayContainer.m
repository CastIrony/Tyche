#import "DisplayContainer.h"

@interface DisplayContainer () 

@property (nonatomic, retain) NSMutableArray* keys;
@property (nonatomic, retain) NSMutableDictionary* hashtable;
@property (nonatomic, retain) NSMutableArray* objects;
@property (nonatomic, retain) NSMutableArray* topObjects;

@end

@implementation DisplayContainer

@synthesize keys;
@synthesize hashtable;
@synthesize objects;
@synthesize topObjects;

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
    return [[[self.hashtable] objectForKey:key] lastObject];
}

-(NSEnumerator*)keyEnumerator 
{
    return self.keys.objectEnumerator; 
}

-(NSEnumerator*)objectEnumerator 
{
    return self.objects.objectEnumerator; 
}

-(NSEnumerator*)topObjectEnumerator 
{
    return self.topObjects.objectEnumerator; 
}

-(NSEnumerator*)reverseKeyEnumerator 
{
    return self.keys.reverseObjectEnumerator; 
}

-(NSEnumerator*)reverseObjectEnumerator 
{
    return self.objects.reverseObjectEnumerator; 
}

-(NSEnumerator*)reverseTopObjectEnumerator 
{
    return self.topObjects.reverseObjectEnumerator; 
}

@end