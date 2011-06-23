#import "Common.h"

@class AppController;
@class GLRenderer;
@class PlayerModel;
@class GameModel;

@interface GameController : NSObject

+(NSString*)name;
+(BOOL)isMultiplayer;

+(GameController*)gameController;

@property (nonatomic, assign)   AppController* appController;
@property (nonatomic, readonly) GLRenderer*    renderer;
@property (nonatomic, readonly) GameModel*     gameModel;
@property (nonatomic, readonly) PlayerModel*     mainPlayer;

-(void)newGame;
-(void)moveCardIndex:(int)initialIndex toIndex:(int)finalIndex;
-(void)labelTouchedWithKey:(NSString*)key;
-(void)chipSwipedUpWithKey:(NSString*)key;
-(void)chipSwipedDownWithKey:(NSString*)key;
-(void)cardFrontTapped:(int)card;
-(void)cardBackTapped:(int)card;

@end
