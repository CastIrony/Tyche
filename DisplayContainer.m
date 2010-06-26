#import "DisplayContainer.h"

@interface DisplayContainer () 

@property (nonatomic, retain) NSMutableArray* keys;
@property (nonatomic, retain) NSMutableDictionary* hashtable;
@property (nonatomic, retain) NSMutableArray* objects;
@property (nonatomic, retain) NSMutableArray* topObjects;

+(DisplayContainer*)containerWithKeys:(NSMutableArray*)keys hashtable:(NSMutableDictionary*)hashtable;

-(void)updateObjectLists;

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
    DisplayContainer* container = [DisplayContainer container];
    
    container.keys = keys;
    container.hashtable = hashtable;
    
    [container updateObjectLists];
    
    return container;
}

-(void)updateObjectLists
{
    NSMutableArray* newObjects = [NSMutableArray array];
    NSMutableArray* newTopObjects = [NSMutableArray array];
    
    for(id key in self.keys)
    {
        for(id object in [self.hashtable objectForKey:key]) 
        {
            [newObjects addObject:object];
        }
        
        [newTopObjects addObject:[[self.hashtable objectForKey:key] lastObject]];
    }
    
    self.objects = newObjects;
    self.topObjects = newTopObjects;
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

-(DisplayContainer*)moveKey:(id)key beforeKey:(id)before 
{
    if(![self.keys containsObject:key]) { return self; }
    if(![self.keys containsObject:before]) { return self; }
    
    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:[newKeys indexOfObject:before]];
    
    return [DisplayContainer containerWithKeys:newKeys hashtable:self.hashtable]; 
}

-(DisplayContainer*)moveKey:(id)key afterKey:(id)after 
{
    if(![self.keys containsObject:key]) { return self; }
    if(![self.keys containsObject:after]) { return self; }
    
    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:[newKeys indexOfObject:after] + 1];
    
    return [DisplayContainer containerWithKeys:newKeys hashtable:self.hashtable];
}


-(DisplayContainer*)pruneObjectsForKey:(id)key toFormat:(NSString*)format 
{
    if(![self.keys containsObject:key]) { return self; }
    
    NSMutableDictionary* newHashtable = [[self.hashtable mutableCopy] autorelease];
    NSMutableArray* newArray = [[[newHashtable objectForKey:key] mutableCopy] autorelease];

    [newArray filterUsingPredicate:[NSPredicate predicateWithFormat:format]];
    
    [newHashtable setValue:newArray forKey:key];
    
    return [DisplayContainer containerWithKeys:self.keys hashtable:newHashtable]; 
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