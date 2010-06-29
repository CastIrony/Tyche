#import "DisplayContainer.h"

@interface DisplayContainer () 

@property (nonatomic, retain) NSMutableDictionary* hashtable;    // live dying dead?

@property (nonatomic, retain) NSMutableArray*      keys;         // live dying dead?
@property (nonatomic, retain) NSMutableArray*      objects;      // live dying dead?
@property (nonatomic, retain) NSMutableArray*      liveKeys;     // live 
@property (nonatomic, retain) NSMutableArray*      liveObjects;  // live 

-(void)generateObjectLists;

@end

@implementation DisplayContainer

@synthesize alive;
@synthesize dead;
@synthesize hashtable;
@synthesize keys;
@synthesize objects;
@synthesize liveKeys;
@synthesize liveObjects;

-(id)init
{
    self = [super init];
    
    if(self) 
    {
        self.hashtable   = [NSMutableDictionary dictionary];
        
        self.objects     = [NSMutableArray array];
        self.keys        = [NSMutableArray array];
        self.liveObjects = [NSMutableArray array];
        self.liveKeys    = [NSMutableArray array];
    }
    
    return self;
}

+(DisplayContainer*)container
{
    return [[[DisplayContainer alloc] init] autorelease];
}

-(void)generateObjectLists
{
    NSMutableArray* newObjects     = [NSMutableArray array];
    NSMutableArray* newLiveObjects = [NSMutableArray array];
    NSMutableArray* newLiveKeys    = [NSMutableArray array];
    
    for(id key in self.keys)
    {
        for(id object in [self.hashtable objectForKey:key])
        {
            [newObjects addObject:object];
        }
        
        id topObject = [[self.hashtable objectForKey:key] lastObject];
        
        if([self.alive evaluateWithObject:topObject])
        {
            [newLiveObjects addObject:topObject];
            [newLiveKeys addObject:key];
        }
    }
    
    self.objects = newObjects;
    self.liveObjects = newLiveObjects;
    self.liveKeys = newLiveKeys;
}

-(void)insertObject:(id)object asFirstWithKey:(id)key 
{
    NSMutableArray*      newKeys      = [[self.keys      mutableCopy] autorelease];
    NSMutableDictionary* newHashtable = [[self.hashtable mutableCopy] autorelease];
    NSMutableArray*      newArray     = [newKeys containsObject:key] ? [[[newHashtable objectForKey:key] mutableCopy] autorelease] : [NSMutableArray array];
        
    [newArray removeObject:object];
    [newArray addObject:object];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:0];
    
    [newHashtable setValue:newArray forKey:key];
    
    self.hashtable = newHashtable;
    self.keys = newKeys;
    
    [self generateObjectLists];
}

-(void)insertObject:(id)object asLastWithKey:(id)key
{
    NSMutableArray*      newKeys      = [[self.keys      mutableCopy] autorelease];
    NSMutableDictionary* newHashtable = [[self.hashtable mutableCopy] autorelease];
    NSMutableArray*      newArray     = [newKeys containsObject:key] ? [[[newHashtable objectForKey:key] mutableCopy] autorelease] : [NSMutableArray array];
    
    [newArray removeObject:object];
    [newArray addObject:object];
    
    [newKeys removeObject:key];
    [newKeys addObject:key];
    
    [newHashtable setValue:newArray forKey:key];
    
    self.hashtable = newHashtable;
    self.keys = newKeys;
    
    [self generateObjectLists];
}

-(void)insertObject:(id)object withKey:(id)key atIndex:(int)index 
{
    NSMutableArray*      newKeys      = [[self.keys      mutableCopy] autorelease];
    NSMutableDictionary* newHashtable = [[self.hashtable mutableCopy] autorelease];
    NSMutableArray*      newArray     = [newKeys containsObject:key] ? [[[newHashtable objectForKey:key] mutableCopy] autorelease] : [NSMutableArray array];
    
    [newArray removeObject:object];
    [newArray addObject:object];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:index];
    
    [newHashtable setValue:newArray forKey:key];
    
    self.hashtable = newHashtable;
    self.keys = newKeys;

    [self generateObjectLists];
}

-(void)insertObject:(id)object withKey:(id)key beforeKey:(id)target 
{
    if(![self.keys containsObject:target]) { return; }

    NSMutableArray*      newKeys      = [[self.keys      mutableCopy] autorelease];
    NSMutableDictionary* newHashtable = [[self.hashtable mutableCopy] autorelease];
    NSMutableArray*      newArray     = [newKeys containsObject:key] ? [[[newHashtable objectForKey:key] mutableCopy] autorelease] : [NSMutableArray array];
    
    [newArray removeObject:object];
    [newArray addObject:object];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:[newKeys indexOfObject:target]];
    
    [newHashtable setValue:newArray forKey:key];
    
    self.hashtable = newHashtable;
    self.keys = newKeys;
    
    [self generateObjectLists];
}

-(void)insertObject:(id)object withKey:(id)key afterKey:(id)target 
{
    if(![self.keys containsObject:target]) { return; }

    NSMutableArray*      newKeys      = [[self.keys      mutableCopy] autorelease];
    NSMutableDictionary* newHashtable = [[self.hashtable mutableCopy] autorelease];
    NSMutableArray*      newArray     = [newKeys containsObject:key] ? [[[newHashtable objectForKey:key] mutableCopy] autorelease] : [NSMutableArray array];
    
    [newArray removeObject:object];
    [newArray addObject:object];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:[newKeys indexOfObject:target] + 1];
    
    [newHashtable setValue:newArray forKey:key];
    
    self.hashtable = newHashtable;
    self.keys = newKeys;
    
    [self generateObjectLists];
}

-(void)moveKeyToFirst:(id)key 
{
    if(![self.keys containsObject:key]) { return; }

    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];

    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:0];
        
    self.keys = newKeys;
    
    [self generateObjectLists];
}

-(void)moveKeyToLast:(id)key 
{
    if(![self.keys containsObject:key]) { return; }

    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys addObject:key];
    
    self.keys = newKeys;
    
    [self generateObjectLists];
}

-(void)moveKey:(id)key toIndex:(int)index 
{
    if(![self.keys containsObject:key]) { return; }

    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:index];
    
    self.keys = newKeys;
    
    [self generateObjectLists];
}

-(void)moveKey:(id)key beforeKey:(id)target 
{
    if(![self.keys containsObject:key]) { return; }
    if(![self.keys containsObject:target]) { return; }
    
    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:[newKeys indexOfObject:target]];
    
    self.keys = newKeys;
    
    [self generateObjectLists];
}

-(void)moveKey:(id)key afterKey:(id)target 
{
    if(![self.keys containsObject:key]) { return; }
    if(![self.keys containsObject:target]) { return; }
    
    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:[newKeys indexOfObject:target] + 1];
    
    self.keys = newKeys;
    
    [self generateObjectLists];
}

-(void)pruneLiveForKey:(id)key
{
    NSMutableArray* newLiveObjects = [[self.liveObjects mutableCopy] autorelease];
    NSMutableArray* newLiveKeys    = [[self.liveKeys    mutableCopy] autorelease];
        
    id topObject = [[self.hashtable objectForKey:key] lastObject];
    
    if(![self.alive evaluateWithObject:topObject])
    {
        [newLiveObjects removeObject:topObject];
        [newLiveKeys    removeObject:key];
    }
    
    self.liveObjects = newLiveObjects;
    self.liveKeys    = newLiveKeys;
    
    [self generateObjectLists];
}

-(void)pruneDeadForKey:(id)key
{
    NSMutableDictionary* newHashtable = [[self.hashtable mutableCopy] autorelease];
    NSMutableArray*      newKeys      = [[self.keys      mutableCopy] autorelease];
    NSMutableArray*      newObjects   = [[self.objects   mutableCopy] autorelease];
    
    BOOL allDead = YES;
    
    for(id object in [self.hashtable objectForKey:key]) 
    {
        if([self.dead evaluateWithObject:object])
        {
            [[newHashtable objectForKey:key] removeObject:object];
        }
        else 
        {
            allDead = NO;
        }

    }
    
    if(allDead)
    {
        [newHashtable removeObjectForKey:key];
        [newKeys removeObject:key];
    }
    
    self.hashtable = newHashtable;
    self.keys      = newKeys;
    self.objects   = newObjects;
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

-(id)liveKeyBefore:(id)target
{
    if(self.liveKeys.count == 0) { return nil; }
    
    uint index = [self.liveKeys indexOfObject:target];
    
    if(index == NSNotFound || index == 0) { return [self.liveKeys objectAtIndex:0]; }
    
    return [self.liveKeys objectAtIndex:index - 1];
}

-(id)liveKeyAfter:(id)target
{
    if(self.liveKeys.count == 0) { return nil; }
    
    uint index = [self.liveKeys indexOfObject:target];
    
    if(index == NSNotFound || index == self.liveKeys.count - 1) { return [self.liveKeys lastObject]; }
    
    return [self.liveKeys objectAtIndex:index + 1];   
}

-(NSArray*)objectsForKey:(id)key 
{
    return [self.hashtable objectForKey:key]; 
}

-(id)liveObjectForKey:(id)key 
{
    if(![self.liveKeys containsObject:key]) { return nil; }
    
    return [[self.hashtable objectForKey:key] lastObject];
}

@end