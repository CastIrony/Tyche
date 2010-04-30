#import "Common.h"

@class GameRenderer;
@class GameModel;
@class PlayerModel;

@interface GameController : NSObject
{
    GameRenderer* _renderer;
    GameModel*    _game;
    NSDictionary* _cardLongNames;
    NSDictionary* _cardShortNames;
    NSArray*      _rankLevels;
    NSDictionary* _rankNames;
}

@property (nonatomic, assign)   GameRenderer* renderer;
@property (nonatomic, retain)   GameModel*    game;
@property (nonatomic, readonly) NSString*     myPeerId;
@property (nonatomic, readonly) PlayerModel*  player;

+(GameController*)loadWithRenderer:(GameRenderer*)renderer;

-(void)saveData;

-(void)newDeckAndThen:(block)work;
-(void)newGameAndThen:(block)work;
-(void)newHandAndThen:(block)work;
-(void)endGameAndThen:(block)work;
-(void)endHandAndThen:(block)work;
-(void)drawCardsAndThen:(block)work;
-(void)dealCards:(NSMutableArray*)cards andThen:(block)work;
-(void)discardCards:(NSMutableArray*)cards andThen:(block)work;

-(NSString*)scoreHand;
-(NSString*)scoreHandHigh;
-(NSString*)scoreHandLow;

-(void)givePrize;
-(void)updateRenderer;

-(void)moveCardIndex:(int)initialIndex toIndex:(int)finalIndex;

-(void)labelTouchedWithKey:(NSString*)key;

-(void)chipTouchedUpWithKey:(NSString*)key;
-(void)chipTouchedDownWithKey:(NSString*)key;

-(void)cardFrontTouched:(int)card;
-(void)cardBackTouched:(int)card;

-(void)emptySpaceTouched;

@end
