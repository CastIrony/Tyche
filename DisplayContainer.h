#import "Common.h"

@class DisplayContainer;

@protocol Perishable <NSObject>

@property (nonatomic, assign) DisplayContainer* displayContainer;
@property (nonatomic, copy) id<NSCopying> key;

@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) BOOL isAlive;

-(void)killAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work;

@optional

-(void)appearAfterDelay:(NSTimeInterval)delay;

-(void)absorb:(id<Perishable>)newObject;
-(void)reincarnateFrom:(id<Perishable>)oldObject;

@end

@interface DisplayContainer : NSObject 

@property (nonatomic, retain, readonly) NSDictionary* dictionary;
@property (nonatomic, retain, readonly) NSDictionary* liveDictionary;
@property (nonatomic, retain, readonly) NSArray* keys;
@property (nonatomic, retain, readonly) NSArray* liveKeys;
@property (nonatomic, retain, readonly) NSArray* objects;
@property (nonatomic, retain, readonly) NSArray* liveObjects;

@property (nonatomic, assign) NSTimeInterval delay;

+(DisplayContainer*)container;

-(void)setKeys:(NSArray*)keys andDictionary:(NSDictionary*)dictionary;
-(void)setKeys:(NSArray*)keys dictionary:(NSDictionary*)dictionary andThen:(SimpleBlock)work;

-(void)generateObjectLists;
-(void)pruneDead;

-(NSArray*)objectsForKey:(id<NSCopying>)key;
-(id<Perishable>)liveObjectForKey:(id<NSCopying>)key;

@end
