#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import "NSString+Documents.h"
#import "NSMutableArray+Deck.h"
#import "GameController.h"

@interface GameControllerSP : GameController
{
    NSDictionary* _rankPrizes;
}

-(void)givePrize;
-(void)updateCardsAndThen:(SimpleBlock)work;

@end