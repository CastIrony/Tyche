#import "AnimationGroup.h"
#import "GameModel.h"
#import "PlayerModel.h"
#import "RoundModel.h"
#import "GLRenderer.h"
#import "GLCardGroup.h"
#import "GLPlayer.h"

#import "GameControllerMP7S.h"

typedef enum 
{    
    RoundStatusAnte,
    RoundStatusThirdStreet,
    RoundStatusFourthStreet,
    RoundStatusFifthStreet,
    RoundStatusSixthStreet,
    RoundStatusShowdown,
    RoundStatusCall
} 
RoundStatus;




@interface GameControllerMP7S ()

-(void)newDeck;

//-(void)givePrize;
-(NSString*)scoreName;

-(void)updatePlayersAndThen:(SimpleBlock)work;
-(void)updateCardsAndThen:(SimpleBlock)work;
-(void)updateChipsAndThen:(SimpleBlock)work;
-(void)updateTextAndThen:(SimpleBlock)work;

@end





@implementation GameControllerMP7S

@synthesize isDealer = _isDealer;
@synthesize isMyTurn = _isMyTurn;

+(GameController*)gameController
{
    return [[[GameControllerMP7S alloc] init] autorelease];
}

+(NSString*)name
{
    return @"Seven Card Stud";
}

+(BOOL)isMultiplayer
{
    return YES;
}

-(void)newDeck
{
    
}

-(void)newGame
{
    if(self.isDealer)
    {
        //give everyone a certain number of credits
        //begin round
    }
}

-(void)beginRound
{
    if(self.isDealer)
    {
        //set roundstatus to ante
        //begin street
    }
}

-(void)beginStreet
{
    if(self.isDealer)
    {
        //if the previous street was a showdown, or all but one folded, start a new round
        //this logic might go at the end of the street rather than the start of the next
        
        //deal card(s)
        //figure out turn order
        //begin first turn
    }
}

-(void)beginTurn
{
    if(self.isDealer)
    {
        //figure out whose turn it is, if any
        //if it's nobody's turn, begin the next street
    }
    
    // make buttons for 'Match', 'Raise', and 'Fold'
}

-(NSString*)scoreName
{
    return nil;
}

-(void)updatePlayersAndThen:(SimpleBlock)work
{

}

-(void)updateCardsAndThen:(SimpleBlock)work
{
    AnimationGroup* animationGroup = [AnimationGroup animationGroup];
    
    for(NSString* playerKey in self.gameModel.playerKeys)
    {
//        NSString* token = [animationGroup acquireToken];
        
        [self.renderer.mainPlayer.cardGroup setFlipped:self.gameModel.roundModel.status == RoundStatusShowdown andThen:^
        {
//             self.renderer.mainPlayer.cardGroup.showLabels = self.gameModel.roundModel.status == RoundStatusDealtCards;
//             
//             [self.renderer.mainPlayer.cardGroup     updateCardsWithKeys:self.mainPlayer.cardKeys  held:(isMe && self.gameModel.mainPlayer.status == PlayerStatusDealtCards) ? self.gameModel.mainPlayer.heldKeys : self.gameModel.mainPlayer.cardKeys andThen:nil];
//             [self.renderer.mainPlayer.flatCardGroup updateCardsWithKeys:self.mainPlayer.drawnKeys                                                                                                                                                     andThen:nil];
//             
//             [animationGroup redeemToken:token afterAnimation:self.renderer.mainPlayer.cardGroup.cards];
         }];
    }
    
    [animationGroup finishAndThen:work];
}

-(void)updateChipsAndThen:(SimpleBlock)work
{
    // make the chips draggable
}

-(void)updateTextAndThen:(SimpleBlock)work
{
    // update the labels / buttons
}

-(void)moveCardIndex:(int)initialIndex toIndex:(int)finalIndex
{
    
}

-(void)labelTouchedWithKey:(NSString*)key
{
    
}

-(void)chipSwipedUpWithKey:(NSString*)key
{
    
}

-(void)chipSwipedDownWithKey:(NSString*)key
{
    
}

-(void)cardFrontTapped:(int)card
{
    
}

-(void)cardBackTapped:(int)card
{
    
}

@end