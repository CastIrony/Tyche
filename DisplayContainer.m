#import "NSArray+Diff.h"
#import "NSArray+Circle.h"
#import "AnimationGroup.h"
#import "DisplayContainer.h"
#import "JSON.h"

@interface DisplayContainer () 

@property (nonatomic, retain) NSDictionary* dictionary;  
@property (nonatomic, retain) NSDictionary* liveDictionary;  
@property (nonatomic, retain) NSArray*      keys;       
@property (nonatomic, retain) NSArray*      objects;    
@property (nonatomic, retain) NSArray*      liveKeys;   
@property (nonatomic, retain) NSArray*      liveObjects;

-(void)generateObjectLists;

@end

@implementation DisplayContainer

@synthesize dictionary      = _dictionary;
@synthesize liveDictionary  = _liveDictionary;
@synthesize keys            = _keys;
@synthesize objects         = _objects;
@synthesize liveKeys        = _liveKeys;
@synthesize liveObjects     = _liveObjects;
@synthesize delay           = _delay;

-(id)init
{
    self = [super init];
    
    if(self) 
    {
        self.liveDictionary  = [NSDictionary dictionary];
        self.dictionary  = [NSDictionary dictionary];
        self.objects     = [NSArray array];
        self.keys        = [NSArray array];
        self.liveObjects = [NSArray array];
        self.liveKeys    = [NSArray array];
        self.delay = 0;
    }
    
    return self;
}

+(DisplayContainer*)container
{
    return [[[DisplayContainer alloc] init] autorelease];
}

-(void)setKeys:(NSArray*)keys andDictionary:(NSDictionary*)dictionary;
{
    [self setKeys:keys dictionary:dictionary andThen:nil];
}

-(void)setKeys:(NSArray*)newLiveKeys dictionary:(NSDictionary*)newLiveDictionary andThen:(SimpleBlock)work
{
    AnimationGroup* animationGroup = [AnimationGroup animationGroup];
    
    NSTimeInterval currentDelay = 0;

    JBDiffResult* diffResult = [self.keys diffWithArray:newLiveKeys];
    
    NSMutableIndexSet* redundantIndexes = [NSMutableIndexSet indexSet];
    NSMutableArray* movedKeys = [NSMutableArray array];
    
    for(NSUInteger i = [diffResult.combinedDeletedIndexes firstIndex]; i != NSNotFound; i = [diffResult.combinedDeletedIndexes indexGreaterThanIndex:i]) 
    {
        NSString* deletedKey = [diffResult.combinedArray objectAtIndex:i];
        
        if([diffResult.insertedObjects containsObject:deletedKey])
        {
            [redundantIndexes addIndex:i];
            [movedKeys addObject:deletedKey];
        }
    }
    
    NSArray* newKeys = [diffResult.combinedArray arrayByRemovingIndexes:redundantIndexes];
    NSArray* missingKeys = [diffResult.deletedObjects arrayByRemovingObjectsInArray:movedKeys];

    NSMutableDictionary* newDictionary = [[self.dictionary mutableCopy] autorelease];
    
    for(NSString* key in missingKeys.reverseObjectEnumerator)
    {
        id<Perishable> object = [[self.dictionary objectForKey:key] lastObject];
        
        if(object.isAlive) 
        { 
            [object killAfterDelay:currentDelay andThen:nil];
            
            [animationGroup addNewTime:currentDelay];
            
            currentDelay += self.delay;
        }
    }
    
    for(NSString* key in newLiveKeys)
    {
        NSMutableArray* objectList = [[[self.dictionary objectForKey:key] mutableCopy] autorelease];
        
        if(!objectList) { objectList = [NSMutableArray array]; }
        
        id<Perishable> oldObject = [objectList lastObject];
        id<Perishable> newObject = [newLiveDictionary objectForKey:key];
        
        oldObject = oldObject.isAlive ? oldObject : nil;
        
        if([oldObject isEqual:newObject])
        {
            if(oldObject && [newObject respondsToSelector:@selector(absorb:)])
            {
                [oldObject absorb:newObject];
            }
        }
        else
        {
            newObject.displayContainer = self;
        
            if([newObject respondsToSelector:@selector(appearAfterDelay:)])
            {
                [newObject appearAfterDelay:currentDelay];
            }

            if(oldObject && [newObject respondsToSelector:@selector(reincarnateFrom:)])
            {
                [newObject reincarnateFrom:oldObject];
            }
                
            [oldObject killAfterDelay:currentDelay andThen:nil]; 

            [animationGroup addNewTime:currentDelay];

            currentDelay += self.delay;

            [objectList addObject:newObject];
        }
        
        [newDictionary setObject:objectList forKey:key];
    }
    
    self.dictionary = newDictionary;
    self.keys       = newKeys;

    [self generateObjectLists];
    
    [animationGroup finishAnimationsAndThen:work];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"DisplayContainer with objects:%@ keys:%@ liveObjects:%@ liveKeys:%@", self.objects, self.keys, self.liveObjects, self.liveKeys];
}

-(void)generateObjectLists
{
    NSMutableDictionary* newLiveDictionary = [NSMutableDictionary dictionary];
    NSMutableArray* newObjects     = [NSMutableArray array];
    NSMutableArray* newLiveObjects = [NSMutableArray array];
    NSMutableArray* newLiveKeys    = [NSMutableArray array];
        
    for(id key in self.keys)
    {
        for(id object in [self.dictionary objectForKey:key])
        {
            [newObjects addObject:object];
        }
        
        id<Perishable> topObject = [[self.dictionary objectForKey:key] lastObject];
                
        if(topObject.isAlive)
        {
            [newLiveDictionary setObject:topObject forKey:key];
            [newLiveObjects addObject:topObject];
            [newLiveKeys addObject:key];
        }
    }
    
    self.liveDictionary = newLiveDictionary;
    self.objects     = newObjects;
    self.liveObjects = newLiveObjects;
    self.liveKeys    = newLiveKeys; 
}

-(void)pruneDead
{    
    if(self.dictionary.count == 0 && self.keys.count == 0) { return; }

    NSMutableDictionary* newDictionary = [NSMutableDictionary dictionary];
    NSMutableArray* newKeys = [NSMutableArray array];
    
    for(NSString* key in self.keys)
    {
        BOOL allDead = YES;
    
        NSArray* objectList = [self.dictionary objectForKey:key];

        NSMutableArray* newObjectList = [NSMutableArray array];

        for(id<Perishable> object in objectList)
        {
            if(!object.isDead)
            {
                [newObjectList addObject:object];
                
                allDead = NO;
            }
        }
        
        if(!allDead)
        {
            [newDictionary setObject:newObjectList forKey:key];
            [newKeys addObject:key];
        }
    }
        
    self.dictionary = newDictionary;
    self.keys = newKeys;
    
    [self generateObjectLists];
}

-(NSArray*)objectsForKey:(id)key 
{
    return [self.dictionary objectForKey:key]; 
}

-(id)liveObjectForKey:(id)key 
{
    if(![self.liveKeys containsObject:key]) { return nil; }
    
    return [[self.dictionary objectForKey:key] lastObject];
}

@end