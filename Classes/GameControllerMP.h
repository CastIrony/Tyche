#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import "NSString+Documents.h"
#import "NSMutableArray+Deck.h"
#import "GameController.h"

@class GameModel;
@class SessionController;

@interface GameControllerMP : GameController

@property (nonatomic, retain) SessionController* sessionController;

-(void)joinGameAndThen:(simpleBlock)work;

@end