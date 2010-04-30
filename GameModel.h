@class PlayerModel;

typedef enum 
{
    GameStatusSinglePlayer,
    GameStatusPreDeal,
    GameStatusDealingCards,
    GameStatusMarkCards,
    GameStatusDrawingCards,
    GameStatusFold,
    GameStatusBet,
    GameStatusCall
} 
GameStatus;

@interface GameModel : NSObject 
{
    NSMutableArray*      _playerIds;
    NSMutableDictionary* _players;
    NSMutableArray*      _deck;
    NSMutableArray*      _discard;
    GameStatus           _status;
}

@property (nonatomic, retain) NSMutableArray*      playerIds;
@property (nonatomic, retain) NSMutableDictionary* players;
@property (nonatomic, retain) NSMutableArray*      deck;
@property (nonatomic, retain) NSMutableArray*      discard;
@property (nonatomic, assign) GameStatus           status;

+(id)withDictionary:(NSDictionary*)dictionary;
-(id)proxyForJson;

-(NSMutableArray*)getCards:(int)count;

@end
