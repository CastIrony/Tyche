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
@property (nonatomic, retain) NSString*     messageDown;
@property (nonatomic, retain) NSString*     messageUp;

+(GameController*)loadWithRenderer:(GameRenderer*)renderer;

-(void)saveData;

-(void)updatePlayer;
-(void)updateCards;
-(void)updateChips;

-(void)newGame;
-(void)newDeck;

-(NSString*)scoreHand;
-(NSString*)scoreHand:(NSArray*)hand high:(BOOL)high;

-(void)moveCardIndex:(int)initialIndex toIndex:(int)finalIndex;
-(void)labelTouchedWithKey:(NSString*)key;
-(void)chipSwipedUpWithKey:(NSString*)key;
-(void)chipSwipedDownWithKey:(NSString*)key;
-(void)cardFrontTapped:(int)card;
-(void)cardBackTapped:(int)card;

@end
