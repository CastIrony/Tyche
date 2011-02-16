#import "Geometry.h"
#import "CardModel.h"

@interface PlayerModel : NSObject 

@property (nonatomic, assign) int status; // context of status depends on the specific game controller

@property (nonatomic, retain) NSMutableArray*      cards;
@property (nonatomic, retain) NSMutableDictionary* chips;

@property (nonatomic, assign)   int chipTotal;
@property (nonatomic, readonly) int betTotal;
@property (nonatomic, readonly) int numberOfCardsMarked;
@property (nonatomic, readonly) NSArray* cardKeys;

@property (nonatomic, readonly) NSArray* heldKeys;
@property (nonatomic, readonly) NSArray* heldCards;

@property (nonatomic, readonly) NSArray* drawnKeys;
@property (nonatomic, readonly) NSArray* drawnCards;

-(id)init;
-(id)proxyForJson;

-(void)cancelBets;
-(void)allIn;

+(id)withDictionary:(NSDictionary*)dictionary;

@end