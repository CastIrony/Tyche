#import "DisplayContainer.h"

@interface DisplayContainer () 

@property (nonatomic, retain) NSPredicate*         alive;
@property (nonatomic, retain) NSPredicate*         dead;

@property (nonatomic, retain) NSMutableDictionary* hashtable;    // live dying dead?
@property (nonatomic, retain) NSMutableArray*      keys;         // live dying dead?
@property (nonatomic, retain) NSMutableArray*      objects;      // live dying dead?
@property (nonatomic, retain) NSMutableArray*      liveKeys;     // live 
@property (nonatomic, retain) NSMutableArray*      liveObjects;  // live 

@end

@implementation DisplayContainer

@synthesize alive;
@synthesize dead;
@synthesize hashtable;
@synthesize keys;
@synthesize objects;
@synthesize liveKeys;
@synthesize liveObjects;

+(DisplayContainer*)container
{
    return [[[DisplayContainer alloc] init] autorelease];
}

//+(DisplayContainer*)containerWithPredicate:(NSPredicate*)predicate hashtable:(NSMutableDictionary*)hashtable keys:(NSMutableArray*)keys liveKeys:(NSMutableArray*)liveKeys
//{
//    DisplayContainer* container = [[[DisplayContainer alloc] init] autorelease];
//
//    container.predicate = predicate;
//    
//    container.hashtable   = hashtable;
//    container.keys        = keys;
//    container.liveKeys    = liveKeys;
//    container.objects     = [NSMutableArray array];
//    container.liveObjects = [NSMutableArray array];
//    
//    for(id key in keys)
//    {
//        BOOL allDead = YES;
//        
//        for(id object in [container.hashtable objectForKey:key]) 
//        {
//            if([container.predicate evaluateWithObject:object])
//            {
//                [container.objects addObject:object];
//                allDead = NO;
//            }
//            else 
//            {
//                [[container.hashtable objectForKey:key] removeObject:object];
//            }
//        }
//        
//        if(allDead)
//        {
//            [container.hashtable removeObjectForKey:key];
//            [container.keys removeObject:key];
//        }
//        else 
//        {
//            if([liveKeys containsObject:key])
//            {
//                [container.liveObjects addObject:[[container.hashtable objectForKey:key] lastObject]];
//            }
//        }
//    }
//    
//    return container;
//}

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
}

-(void)moveKeyToFirst:(id)key 
{
    if(![self.keys containsObject:key]) { return; }

    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];

    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:0];
        
    self.keys = newKeys;
}

-(void)moveKeyToLast:(id)key 
{
    if(![self.keys containsObject:key]) { return; }

    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys addObject:key];
    
    self.keys = newKeys;
}

-(void)moveKey:(id)key toIndex:(int)index 
{
    if(![self.keys containsObject:key]) { return; }

    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:index];
    
    self.keys = newKeys;
}

-(void)moveKey:(id)key beforeKey:(id)target 
{
    if(![self.keys containsObject:key]) { return; }
    if(![self.keys containsObject:target]) { return; }
    
    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:[newKeys indexOfObject:target]];
    
    self.keys = newKeys;
}

-(void)moveKey:(id)key afterKey:(id)target 
{
    if(![self.keys containsObject:key]) { return; }
    if(![self.keys containsObject:target]) { return; }
    
    NSMutableArray* newKeys = [[self.keys mutableCopy] autorelease];
    
    [newKeys removeObject:key];
    [newKeys insertObject:key atIndex:[newKeys indexOfObject:target] + 1];
    
    self.keys = newKeys;
}

-(void)prune
{
    //return [DisplayContainer containerWithPredicate:self.predicate hashtable:self.hashtable keys:self.keys];
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
    return nil;
}

-(id)liveKeyAfter:(id)target
{
    return nil;
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