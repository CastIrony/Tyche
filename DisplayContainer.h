

@interface DisplayContainer : NSObject 
{
    
}

@property (nonatomic, retain) NSMutableArray*      keys;
@property (nonatomic, retain) NSMutableDictionary* hashtable;
@property (nonatomic, retain) NSMutableArray*      objects;
@property (nonatomic, retain) NSMutableArray*      topObjects;

+(DisplayContainer*)container;

-(DisplayContainer*)insertObject:(id)object asFirstWithKey:(id)key;
-(DisplayContainer*)insertObject:(id)object asLastWithKey:(id)key;
-(DisplayContainer*)insertObject:(id)object withKey:(id)key atIndex:(int)index;
-(DisplayContainer*)insertObject:(id)object withKey:(id)key beforeKey:(id)before;
-(DisplayContainer*)insertObject:(id)object withKey:(id)key afterKey:(id)after;

-(DisplayContainer*)moveKeyToFirst:(id)key;
-(DisplayContainer*)moveKeyToLast:(id)key;
-(DisplayContainer*)moveKey:(id)key toIndex:(int)index;
-(DisplayContainer*)moveKey:(id)key beforeKey:(id)before;
-(DisplayContainer*)moveKey:(id)key afterKey:(id)after;

-(DisplayContainer*)pruneObjectsForKey:(id)key toFormat:(NSString*)format;

-(NSArray*)objectsForKey:(id)key;
-(id)topObjectForKey:(id)key;

-(NSEnumerator*)keyEnumerator;
-(NSEnumerator*)objectEnumerator;
-(NSEnumerator*)topObjectEnumerator;

-(NSEnumerator*)reverseKeyEnumerator;
-(NSEnumerator*)reverseObjectEnumerator;
-(NSEnumerator*)reverseTopObjectEnumerator;

@end
