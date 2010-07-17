#import "Common.h"

@class GameRenderer;
@class GameModel;
@class PlayerModel;

@interface GameController : NSObject
{
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

-(void)newGameAndThen:(simpleBlock)work;
-(void)newDeckAndThen:(simpleBlock)work;
-(void)newHandAndThen:(simpleBlock)work;
-(void)drawCardsAndThen:(simpleBlock)work;

-(NSString*)scoreHand;
-(NSString*)scoreHandHigh;
-(NSString*)scoreHandLow;

-(void)givePrize;
-(void)updateStatusAndThen:(simpleBlock)work;
-(void)updateCardsAndThen:(simpleBlock)work;
-(void)updateChipsAndThen:(simpleBlock)work;

-(void)moveCardIndex:(int)initialIndex toIndex:(int)finalIndex;

-(void)labelTouchedWithKey:(NSString*)key;
-(void)chipTouchedUpWithKey:(NSString*)key;
-(void)chipTouchedDownWithKey:(NSString*)key;
-(void)cardFrontTouched:(int)card;
-(void)cardBackTouched:(int)card;
-(void)emptySpaceTouched;

@end
