#import "NSArray+JBCommon.h"
#import "AnimationGroup.h"
#import "DisplayContainer.h"
#import "JSON.h"



@implementation DisplayItem

+(DisplayItem*)displayItemWithKey:(id<NSCopying>)key object:(id<Displayable>)object
{
    DisplayItem* displayItem = [[[DisplayItem alloc] init] autorelease];

    displayItem.key = key;
    displayItem.object = object;
    
    return displayItem;
}

@synthesize key;
@synthesize object;

@end



@interface DisplayContainer () 

@property (nonatomic, copy) NSDictionary* dictionary;  
@property (nonatomic, copy) NSDictionary* liveDictionary;  
@property (nonatomic, copy) NSArray*      keys;       
@property (nonatomic, copy) NSArray*      objects;    
@property (nonatomic, copy) NSArray*      liveKeys;   
@property (nonatomic, copy) NSArray*      liveObjects;
@property (nonatomic, copy) NSArray*      displayItems;

@property (nonatomic, assign) NSTimeInterval endTime;

-(void)generateObjectLists;
-(void)pruneDead;

@end



@implementation DisplayContainer

+(DisplayContainer*)container
{
    return [[[DisplayContainer alloc] init] autorelease];
}

@synthesize liveDictionary = _liveDictionary;
@synthesize dictionary     = _dictionary;
@synthesize keys           = _keys;
@synthesize objects        = _objects;
@synthesize liveKeys       = _liveKeys;
@synthesize liveObjects    = _liveObjects;
@synthesize displayItems   = _displayItems;
@synthesize delay          = _delay;
@synthesize endTime        = _endTime;

-(id)init
{
    self = [super init];
    
    if(self) 
    {
        self.liveDictionary = [NSDictionary dictionary];
        self.dictionary     = [NSDictionary dictionary];
        self.keys           = [NSArray array];
        self.objects        = [NSArray array];
        self.liveKeys       = [NSArray array];
        self.liveObjects    = [NSArray array];
        self.displayItems   = [NSArray array];
        self.delay          = 0;
        self.endTime        = CACurrentMediaTime();
    }
    
    return self;
}

-(void)setLiveKeys:(NSArray*)newLiveKeys liveDictionary:(NSDictionary*)newLiveDictionary andThen:(SimpleBlock)work
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
    
    NSArray* newKeys = [diffResult.combinedArray arrayByRemovingObjectsAtIndexes:redundantIndexes];
    NSArray* missingKeys = [diffResult.deletedObjects arrayByRemovingObjectsInArray:movedKeys];

    NSMutableDictionary* newDictionary = [[self.dictionary mutableCopy] autorelease];
    
    for(NSString* key in missingKeys.reverseObjectEnumerator)
    {
        id<Displayable> object = [[self.dictionary objectForKey:key] lastObject];
        
        if(object.isAlive) 
        { 
            [object dieAfterDelay:currentDelay andThen:nil];
            
            [animationGroup addTimeDelta:currentDelay];
            
            currentDelay += self.delay;
            
            self.endTime = CACurrentMediaTime() + currentDelay;
        }
    }
    
    for(NSString* key in newLiveKeys)
    {
        NSMutableArray* objectList = [[[self.dictionary objectForKey:key] mutableCopy] autorelease];
        
        if(!objectList) { objectList = [NSMutableArray array]; }
        
        id<Displayable> oldObject = [objectList lastObject];
        id<Displayable> newObject = [newLiveDictionary objectForKey:key];
        
        oldObject = oldObject.isAlive ? oldObject : nil;
        newObject.displayContainer = self;

        if([oldObject isEqual:newObject])
        {
            if(oldObject && [newObject respondsToSelector:@selector(absorb:)])
            {
                [oldObject absorb:newObject];
            }
        }
        else
        {
            if(oldObject && [newObject respondsToSelector:@selector(reincarnate:)])
            {
                [newObject reincarnate:oldObject];
            }

            if([newObject respondsToSelector:@selector(appearAfterDelay:andThen:)])
            {
                [newObject appearAfterDelay:currentDelay andThen:nil];
            }
            
            [oldObject dieAfterDelay:currentDelay andThen:nil]; 

            self.endTime = CACurrentMediaTime() + currentDelay;

            [animationGroup addAbsoluteTime:self.endTime];

            currentDelay += self.delay;
            
            [objectList addObject:newObject];
        }
        
        [newDictionary setObject:objectList forKey:key];
    }
    
    self.dictionary = newDictionary;
    self.keys       = newKeys;

    [self generateObjectLists];
    
    [animationGroup finishAndThen:work];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"DisplayContainer with objects:%@ keys:%@ liveObjects:%@ liveKeys:%@", self.objects, self.keys, self.liveObjects, self.liveKeys];
}

-(void)generateObjectLists
{
    NSMutableDictionary* newLiveDictionary = [NSMutableDictionary dictionary];
    NSMutableArray* newObjects      = [NSMutableArray array];
    NSMutableArray* newDisplayItems = [NSMutableArray array];
    NSMutableArray* newLiveObjects  = [NSMutableArray array];
    NSMutableArray* newLiveKeys     = [NSMutableArray array];
        
    for(id key in self.keys)
    {
        for(id<Displayable> object in [self.dictionary objectForKey:key])
        {
            if(object.isDead) { continue; }
                
            [newObjects addObject:object];
            
            [newDisplayItems addObject:[DisplayItem displayItemWithKey:key object:object]];
        }
        
        id<Displayable> topObject = [[self.dictionary objectForKey:key] lastObject];
                
        if(topObject.isAlive)
        {
            [newLiveDictionary setObject:topObject forKey:key];
            [newLiveObjects addObject:topObject];
            [newLiveKeys addObject:key];
        }
    }
    
    self.liveDictionary = newLiveDictionary;
    self.objects        = newObjects;
    self.displayItems   = newDisplayItems;
    self.liveObjects    = newLiveObjects;
    self.liveKeys       = newLiveKeys; 
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

        for(id<Displayable> object in objectList)
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

-(void)finishAndThen:(SimpleBlock)work
{
    NSTimeInterval now = CACurrentMediaTime();    
    
    if(now > self.endTime)
    {
        RunLater(work);
    }
    else 
    {
        RunAfterDelay(self.endTime - now, work);
    }
}

@end