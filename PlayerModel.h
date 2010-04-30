#import "Geometry.h"
#import "CardModel.h"

typedef enum 
{
    PlayerStatusNoCards,
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
    PlayerStatusReturningCards
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
@property (nonatomic, retain) NSMutableDictionary* chips;

@property (nonatomic, assign)   int chipTotal;
@property (nonatomic, readonly) int betTotal;

@property (nonatomic, readonly) int cardsMarked;

-(id)init;
-(id)proxyForJson;
+(id)withDictionary:(NSDictionary*)dictionary;

@end