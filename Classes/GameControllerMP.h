#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import "NSString+Documents.h"
#import "NSMutableArray+Deck.h"
#import "GameController.h"

@class GameModel;
@class SessionController;

@interface GameControllerMP : GameController
{
    SessionController* _sessionController;
}

@property (nonatomic, retain) SessionController* sessionController;

@end