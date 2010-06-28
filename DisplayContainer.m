#import "DisplayContainer.h"

@interface DisplayContainer () 

@property (nonatomic, retain) NSPredicate*         predicate;
@property (nonatomic, retain) NSMutableDictionary* hashtable;
@property (nonatomic, retain) NSMutableArray*      keys;
@property (nonatomic, retain) NSMutableArray*      liveKeys;
@property (nonatomic, retain) NSMutableArray*      objects;
@property (nonatomic, retain) NSMutableArray*      liveObjects;

+(DisplayContainer*)containerWithPredicate:(NSPredicate*)predicate hashtable:(NSMutableDictionary*)hashtable keys:(NSMutableArray*)keys;

-(void)updateObjectLists;

@end

@implementation DisplayContainer

@synthesize predicate;
@synthesize hashtable;
@synthesize keys;
@synthesize liveKeys;
@synthesize objects;
@synthesize liveObjects;

+(DisplayContainer*)containerWithFormat:(NSString*)format
{
    DisplayContainer* container = [[[DisplayContainer alloc] init] autorelease];
    
    container.predicate = [NSPredicate predicateWithFormat:format];
    
    return container;
}

+(DisplayContainer*)containerWithPredicate:(NSPredicate*)predicate hashtable:(NSMutableDictionary*)hashtable keys:(NSMutableArray*)keys
{
    DisplayContainer* container = [[[DisplayContainer alloc] init] autorelease];

    container.predicate = predicate;
    
    container.hashtable   = [hashtable mutableCopy];
    container.keys        = [keys mutableCopy];
    container.liveKeys    = [NSMutableArray array];
    container.objects     = [NSMutableArray array];
    container.liveObjects = [NSMutableArray array];
    
    for(id key in keys)
    {
        BOOL live = NO;
        
        for(id object in [container.hashtable objectForKey:key]) 
        {
            if([container.predicate evaluateWithObject:object])
            {
                [container.objects addObject:object];
                live = YES;
            }
        }
        
        if(live)
        {
            [container.liveKeys addObject:key];
            [container.liveObjects addObject:[[container.hashtable objectForKey:key] lastObject]];
        }
        else 
        {
            [container.hashtable removeObjectForKey:key];
            [container.keys removeObject:key];
        }
    }
    
    return container;
}

-(DisplayContainer*)insertObject:(id)object asFirstWithKey:(id)key 
{
    NSMutableArray*      newKeys      = [[self.keys      mutableCopy] autorelease];
    NSMutableDictionary* newHashtable = [[self.hashtable mutableCopy] autorelease];
    NSMutableArray*      newArray     = [newKeys containsObject:key] ? [[[newHashtable objectForKey:key] mutableCopy] autorelease] : [NSMutableArray array];
        
    [newArray removeObject:object];
    [newArray addObject:object];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:0];
    
    [newHashtable setValue:newArray forKey:key];
    
    return [DisplayContainer containerWithKeys:newKeys hashtable:newHashtable]; 
}

-(DisplayContainer*)insertObject:(id)object asLastWithKey:(id)key 
{
    NSMutableArray*      newKeys      = [[self.keys      mutableCopy] autorelease];
    NSMutableDictionary* newHashtable = [[self.hashtable mutableCopy] autorelease];
    NSMutableArray*      newArray     = [newKeys containsObject:key] ? [[[newHashtable objectForKey:key] mutableCopy] autorelease] : [NSMutableArray array];
    
    [newArray removeObject:object];
    [newArray addObject:object];
    
    [newKeys removeObject:key];
    [newKeys addObject:key];
    
    [newHashtable setValue:newArray forKey:key];
    
    return [DisplayContainer containerWithKeys:newKeys hashtable:newHashtable]; 
}

-(DisplayContainer*)insertObject:(id)object withKey:(id)key atIndex:(int)index 
{
    NSMutableArray*      newKeys      = [[self.keys      mutableCopy] autorelease];
    NSMutableDictionary* newHashtable = [[self.hashtable mutableCopy] autorelease];
    NSMutableArray*      newArray     = [newKeys containsObject:key] ? [[[newHashtable objectForKey:key] mutableCopy] autorelease] : [NSMutableArray array];
    
    [newArray removeObject:object];
    [newArray addObject:object];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:index];
    
    [newHashtable setValue:newArray forKey:key];
    
    return [DisplayContainer containerWithKeys:newKeys hashtable:newHashtable]; 
}

-(DisplayContainer*)insertObject:(id)object withKey:(id)key beforeKey:(id)target 
{
    if(![self.keys containsObject:target]) { return self; }

    NSMutableArray*      newKeys      = [[self.keys      mutableCopy] autorelease];
    NSMutableDictionary* newHashtable = [[self.hashtable mutableCopy] autorelease];
    NSMutableArray*      newArray     = [newKeys containsObject:key] ? [[[newHashtable objectForKey:key] mutableCopy] autorelease] : [NSMutableArray array];
    
    [newArray removeObject:object];
    [newArray addObject:object];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:[newKeys indexOfObject:target]];
    
    [newHashtable setValue:newArray forKey:key];
    
    return [DisplayContainer containerWithKeys:newKeys hashtable:newHashtable];  
}

-(DisplayContainer*)insertObject:(id)object withKey:(id)key afterKey:(id)target 
{
    if(![self.keys containsObject:target]) { return self; }

    NSMutableArray*      newKeys      = [[self.keys      mutableCopy] autorelease];
    NSMutableDictionary* newHashtable = [[self.hashtable mutableCopy] autorelease];
    NSMutableArray*      newArray     = [newKeys containsObject:key] ? [[[newHashtable objectForKey:key] mutableCopy] autorelease] : [NSMutableArray array];
    
    [newArray removeObject:object];
    [newArray addObject:object];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:[newKeys indexOfObject:target] + 1];
    
    [newHashtable setValue:newArray forKey:key];
    
    return [DisplayContainer containerWithKeys:newKeys hashtable:newHashtable]; 
}

-(DisplayContainer*)moveKeyToFirst:(id)key 
{
    if(![self.keys containsObject:key]) { return self; }

    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];

    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:0];
        
    return [DisplayContainer containerWithKeys:newKeys hashtable:self.hashtable]; 
}

-(DisplayContainer*)moveKeyToLast:(id)key 
{
    if(![self.keys containsObject:key]) { return self; }

    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys addObject:key];
    
    return [DisplayContainer containerWithKeys:newKeys hashtable:self.hashtable]; 
}

-(DisplayContainer*)moveKey:(id)key toIndex:(int)index 
{
    if(![self.keys containsObject:key]) { return self; }

    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:index];
    
    return [DisplayContainer containerWithKeys:newKeys hashtable:self.hashtable]; 
}

-(DisplayContainer*)moveKey:(id)key beforeKey:(id)target 
{
    if(![self.keys containsObject:key]) { return self; }
    if(![self.keys containsObject:target]) { return self; }
    
    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:[newKeys indexOfObject:target]];
    
    return [DisplayContainer containerWithKeys:newKeys hashtable:self.hashtable]; 
}

-(DisplayContainer*)moveKey:(id)key afterKey:(id)target 
{
    if(![self.keys containsObject:key]) { return self; }
    if(![self.keys containsObject:target]) { return self; }
    
    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:[newKeys indexOfObject:target] + 1];
    
    return [DisplayContainer containerWithKeys:newKeys hashtable:self.hashtable];
}

-(id)keyBefore:(id)target
{
    if(self.keys.count == 0) { return nil; }
    
    uint index = [self.keys indexOfObject:target];
    
    if(index == NSNotFound || index == 0) { return [self.keys objectAtIndex:0]; }
    
    return [self.keys objectAtIndex:index - 1];
}

-(id)keyAfter:(id)target
{
    if(self.keys.count == 0) { return nil; }
    
    uint index = [self.keys indexOfObject:target];
    
    if(index == NSNotFound || index == self.keys.count - 1) { return [self.keys lastObject]; }
    
    return [self.keys objectAtIndex:index + 1];    
}

-(NSArray*)objectsForKey:(id)key 
{
    return [self.hashtable objectForKey:key]; 
}

-(id)topObjectForKey:(id)key 
{
    return [[self.hashtable objectForKey:key] lastObject];
}

@end