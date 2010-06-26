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
    DisplayContainer* container = [[[DisplayContainer alloc] init] autorelease];
    
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
    
    NSMutableArray* newArray;
    
    if([newKeys containsObject:key])
    {
        newArray = [[[newHashtable objectForKey:key] mutableCopy] autorelease];
        
        if([newArray containsObject:object]) { [newArray removeObject:object]; }
        
        [newArray addObject:object];
        
        [newKeys removeObject:key];
    }
    else 
    {
        newArray = [NSMutableArray arrayWithObject:object];
    }

    [newKeys insertObject:key atIndex:0];
    [newHashtable setValue:newArray forKey:key];
    
    return [DisplayContainer containerWithKeys:newKeys hashtable:newHashtable]; 
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
    return [self.hashtable objectForKey:key]; 
}

-(id)topObjectForKey:(id)key 
{
    return [[self.hashtable objectForKey:key] lastObject];
}

@end