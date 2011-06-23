#import "AnimationGroup.h"
#import "Common.h"

@class DisplayContainer;



@protocol Displayable <NSObject>

@property (nonatomic, assign) DisplayContainer* displayContainer;
@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) BOOL isAlive;

-(void)appearAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work;
-(void)dieAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work;

@optional

-(void)drawWithKey:(id<NSCopying>)key;

-(void)absorb:(id<Displayable>)newObject;
-(void)reincarnate:(id<Displayable>)oldObject;

@end



@interface DisplayItem : NSObject

+(DisplayItem*)displayItemWithKey:(id<NSCopying>)key object:(id<Displayable>)object;

@property (nonatomic, copy)   id<NSCopying>     key;
@property (nonatomic, retain) id<Displayable> object;

@end



@interface DisplayContainer : NSObject <Animated>

+(DisplayContainer*)container;

@property (nonatomic, copy, readonly) NSDictionary* liveDictionary;  
@property (nonatomic, copy, readonly) NSArray*      keys;       
@property (nonatomic, copy, readonly) NSArray*      objects;    
@property (nonatomic, copy, readonly) NSArray*      liveKeys;   
@property (nonatomic, copy, readonly) NSArray*      liveObjects;

@property (nonatomic, assign) NSTimeInterval delay;

-(void)setLiveKeys:(NSArray*)newLiveKeys liveDictionary:(NSDictionary*)newLiveDictionary andThen:(SimpleBlock)work;

-(NSArray*)objectsForKey:(id<NSCopying>)key;
-(id<Displayable>)liveObjectForKey:(id<NSCopying>)key;

-(void)finishAndThen:(SimpleBlock)work;

@end


