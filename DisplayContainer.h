@interface DisplayContainer : NSObject 

@property (nonatomic, retain, readonly) NSPredicate* predicate;

@property (nonatomic, retain, readonly) NSMutableDictionary* hashtable;
@property (nonatomic, retain, readonly) NSMutableArray* keys;
@property (nonatomic, retain, readonly) NSMutableArray* liveKeys;
@property (nonatomic, retain, readonly) NSMutableArray* objects;
@property (nonatomic, retain, readonly) NSMutableArray* liveObjects;

+(DisplayContainer*)containerWithFormat:(NSString*)format;

-(DisplayContainer*)insertObject:(id)object asFirstWithKey:(id)key;
-(DisplayContainer*)insertObject:(id)object asLastWithKey:(id)key;
-(DisplayContainer*)insertObject:(id)object withKey:(id)key atIndex:(int)index;
-(DisplayContainer*)insertObject:(id)object withKey:(id)key beforeKey:(id)target;
-(DisplayContainer*)insertObject:(id)object withKey:(id)key afterKey:(id)target;

-(DisplayContainer*)moveKeyToFirst:(id)key;
-(DisplayContainer*)moveKeyToLast:(id)key;
-(DisplayContainer*)moveKey:(id)key toIndex:(int)index;
-(DisplayContainer*)moveKey:(id)key beforeKey:(id)target;
-(DisplayContainer*)moveKey:(id)key afterKey:(id)target;

-(DisplayContainer*)prune;

-(id)keyBefore:(id)target;
-(id)keyAfter:(id)target;
-(id)liveKeyBefore:(id)target;
-(id)liveKeyAfter:(id)target;

-(NSArray*)objectsForKey:(id)key;
-(id)liveObjectForKey:(id)key;

@end
