#import "Geometry.h"
#import "CardModel.h"

typedef enum 
{    
    PlayerStatusShouldDealCards,
    PlayerStatusDealingCards,
    PlayerStatusDealtCards,
    
    PlayerStatusShouldDrawCards,
    PlayerStatusDrawingCards,
    PlayerStatusDrawnCards,
    
    PlayerStatusShouldShowCards,
    PlayerStatusShowingCards,
    PlayerStatusShownCards,
    
    PlayerStatusShouldReturnCards,
    PlayerStatusReturningCards,
    PlayerStatusNoCards
} 
PlayerStatus;

@interface PlayerModel : NSObject 
{
    PlayerStatus         _status;
    
    NSMutableArray*      _cards;
    NSMutableDictionary* _chips;
}

@property (nonatomic, assign) PlayerStatus status;

@property (nonatomic, retain) NSMutableArray*      cards;
@property (nonatomic, retain) NSMutableArray*      cardsToAdd;
@property (nonatomic, retain) NSMutableArray*      cardsToRemove;
@property (nonatomic, retain) NSMutableDictionary* chips;

@property (nonatomic, assign)   int chipTotal;
@property (nonatomic, readonly) int betTotal;

@property (nonatomic, readonly) int cardsMarked;
@property (nonatomic, readonly) NSArray* cardKeys;
@property (nonatomic, readonly) NSArray* heldKeys;

-(id)init;
-(id)proxyForJson;
+(id)withDictionary:(NSDictionary*)dictionary;

@end