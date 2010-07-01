#import "Killable.h"

@interface DisplayContainer : NSObject 

@property (nonatomic, retain) NSPredicate* alive;
@property (nonatomic, retain) NSPredicate* dead;

@property (nonatomic, retain, readonly) NSMutableDictionary* hashtable;
@property (nonatomic, retain, readonly) NSMutableArray* keys;
@property (nonatomic, retain, readonly) NSMutableArray* liveKeys;
@property (nonatomic, retain, readonly) NSMutableArray* objects;
@property (nonatomic, retain, readonly) NSMutableArray* liveObjects;

+(DisplayContainer*)container;

-(void)insertObject:(id<Killable>)object asFirstWithKey:(id<NSCopying>)key;
-(void)insertObject:(id<Killable>)object asLastWithKey:(id<NSCopying>)key;
-(void)insertObject:(id<Killable>)object withKey:(id<NSCopying>)key atIndex:(int)index;
-(void)insertObject:(id<Killable>)object withKey:(id<NSCopying>)key beforeKey:(id)target;
-(void)insertObject:(id<Killable>)object withKey:(id<NSCopying>)key afterKey:(id)target;

-(void)moveKeyToFirst:(id)key;
-(void)moveKeyToLast:(id)key;
-(void)moveKey:(id)key toIndex:(int)index;
-(void)moveKey:(id)key beforeKey:(id)target;
-(void)moveKey:(id)key afterKey:(id)target;

-(void)pruneLiveForKey:(id)key;
-(void)pruneDeadForKey:(id)key;

-(id)keyBefore:(id)target;
-(id)keyAfter:(id)target;
-(id)liveKeyBefore:(id)target;
-(id)liveKeyAfter:(id)target;

-(NSArray*)objectsForKey:(id)key;
-(id)liveObjectForKey:(id)key;

@end
