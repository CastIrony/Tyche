#import "Geometry.h"
#import "CardModel.h"

@interface PlayerModel : NSObject 

@property (nonatomic, assign) int status; // context of status depends on the specific game controller

@property (nonatomic, retain) NSMutableArray*      cards;
@property (nonatomic, retain) NSMutableArray*      cardsToAdd;
@property (nonatomic, retain) NSMutableArray*      cardsToRemove;
@property (nonatomic, retain) NSMutableDictionary* chips;

@property (nonatomic, assign)   int chipTotal;
@property (nonatomic, readonly) int betTotal;
@property (nonatomic, readonly) int numberOfCardsMarked;
@property (nonatomic, readonly) NSArray* cardKeys;
@property (nonatomic, readonly) NSArray* heldKeys;

-(id)init;
-(id)proxyForJson;
+(id)withDictionary:(NSDictionary*)dictionary;

@end