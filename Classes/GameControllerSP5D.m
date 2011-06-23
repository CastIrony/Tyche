#import "NSArray+JBCommon.h"
#import "GLRenderer.h"
#import "PlayerModel.h"
#import "ScoreController.h"
#import "CardModel.h"
#import "ChipModel.h"
#import "GameModel.h"
#import "GLChipGroup.h"
#import "GLPlayer.h"
#import "GLChip.h"
#import "GLFlatCardGroup.h"
#import "GLCardGroup.h"
#import "GLCard.h"
#import "GLSplash.h"
#import "GLText.h"
#import "NSMutableArray+Deck.h"
#import "AnimatedFloat.h"
#import "AnimatedVec3.h"
#import "AppController.h"
#import "AnimationGroup.h"
#import "GLCamera.h"
#import "GLMenuLayerController.h"
#import "GLTextController.h"
#import "GLTextControllerStatusBar.h"
#import "GLTextControllerCredits.h"
#import "GLTextControllerActions.h"

#import "GameControllerSP5D.h"

typedef enum 
{    
    PlayerStatusNoCards,
    PlayerStatusDealtCards,
    PlayerStatusDrawnCards,
    PlayerStatusShownCards
} 
PlayerStatus;

@interface GameControllerSP5D ()

-(void)newDeck;

-(void)givePrize;
-(NSString*)scoreName;

-(void)updatePlayersAndThen:(SimpleBlock)work;
-(void)updateCardsAndThen:(SimpleBlock)work;
-(void)updateChipsAndThen:(SimpleBlock)work;
-(void)updateTextAndThen:(SimpleBlock)work;

@end

@implementation GameControllerSP5D

+(GameController*)gameController
{
    return [[[GameControllerSP5D alloc] init] autorelease];
}

@synthesize cardLongNames  = _cardLongNames;
@synthesize cardShortNames = _cardShortNames;
@synthesize rankLevels     = _rankLevels;
@synthesize rankNames      = _rankNames;
@synthesize rankPrizes     = _rankPrizes;

+(NSString*)name
{
    return @"Five Card Draw";
}

+(BOOL)isMultiplayer
{
    return NO;
}

-(id)init
{
    self = [super init];
    
	if(self)
	{
        self.rankLevels = [NSMutableArray array];
        self.rankNames  = [NSMutableDictionary dictionary];
        self.rankPrizes = [NSMutableDictionary dictionary];
    
        CardModel* jack = [CardModel cardModel];
        
        jack.numeral = 11;
        
        [self.rankLevels addObject:[ScoreController handWithRank:HandRankHighCard      scoredCards:nil otherCards:nil]];
        [self.rankLevels addObject:[ScoreController handWithRank:HandRankPair          scoredCards:[NSArray arrayWithObject:jack] otherCards:nil]];
        [self.rankLevels addObject:[ScoreController handWithRank:HandRankPair          scoredCards:nil otherCards:nil]];
        [self.rankLevels addObject:[ScoreController handWithRank:HandRankTwoPair       scoredCards:nil otherCards:nil]];
        [self.rankLevels addObject:[ScoreController handWithRank:HandRankThreeOfAKind  scoredCards:nil otherCards:nil]];
        [self.rankLevels addObject:[ScoreController handWithRank:HandRankStraight      scoredCards:nil otherCards:nil]];
        [self.rankLevels addObject:[ScoreController handWithRank:HandRankFlush         scoredCards:nil otherCards:nil]];
        [self.rankLevels addObject:[ScoreController handWithRank:HandRankFullHouse     scoredCards:nil otherCards:nil]];
        [self.rankLevels addObject:[ScoreController handWithRank:HandRankFourOfAKind   scoredCards:nil otherCards:nil]];
        [self.rankLevels addObject:[ScoreController handWithRank:HandRankStraightFlush scoredCards:nil otherCards:nil]];
        [self.rankLevels addObject:[ScoreController handWithRank:HandRankRoyalFlush    scoredCards:nil otherCards:nil]];
        
        [self.rankNames setObject:@"High Card"       forKey:[self.rankLevels objectAtIndex:0]];
        [self.rankNames setObject:@"Low Pair"        forKey:[self.rankLevels objectAtIndex:1]];
        [self.rankNames setObject:@"Jacks or Better" forKey:[self.rankLevels objectAtIndex:2]];
        [self.rankNames setObject:@"Two Pair"        forKey:[self.rankLevels objectAtIndex:3]];
        [self.rankNames setObject:@"Three of a Kind" forKey:[self.rankLevels objectAtIndex:4]];
        [self.rankNames setObject:@"Straight"        forKey:[self.rankLevels objectAtIndex:5]];
        [self.rankNames setObject:@"Flush"           forKey:[self.rankLevels objectAtIndex:6]];
        [self.rankNames setObject:@"Full House"      forKey:[self.rankLevels objectAtIndex:7]];
        [self.rankNames setObject:@"Four of a Kind"  forKey:[self.rankLevels objectAtIndex:8]];
        [self.rankNames setObject:@"Straight Flush"  forKey:[self.rankLevels objectAtIndex:9]];
        [self.rankNames setObject:@"Royal Flush"     forKey:[self.rankLevels objectAtIndex:10]];
        
        [self.rankPrizes setObject:[NSNumber numberWithInt:  0] forKey:[self.rankLevels objectAtIndex:0]];
        [self.rankPrizes setObject:[NSNumber numberWithInt:  0] forKey:[self.rankLevels objectAtIndex:1]];
        [self.rankPrizes setObject:[NSNumber numberWithInt:  1] forKey:[self.rankLevels objectAtIndex:2]];
        [self.rankPrizes setObject:[NSNumber numberWithInt:  2] forKey:[self.rankLevels objectAtIndex:3]];
        [self.rankPrizes setObject:[NSNumber numberWithInt:  3] forKey:[self.rankLevels objectAtIndex:4]];
        [self.rankPrizes setObject:[NSNumber numberWithInt:  4] forKey:[self.rankLevels objectAtIndex:5]];
        [self.rankPrizes setObject:[NSNumber numberWithInt:  6] forKey:[self.rankLevels objectAtIndex:6]];
        [self.rankPrizes setObject:[NSNumber numberWithInt:  9] forKey:[self.rankLevels objectAtIndex:7]];
        [self.rankPrizes setObject:[NSNumber numberWithInt: 25] forKey:[self.rankLevels objectAtIndex:8]];
        [self.rankPrizes setObject:[NSNumber numberWithInt: 50] forKey:[self.rankLevels objectAtIndex:9]];
        [self.rankPrizes setObject:[NSNumber numberWithInt:800] forKey:[self.rankLevels objectAtIndex:10]];
    }
	
	return self;
}

-(void)newDeck
{
    self.gameModel.deck = [[NSMutableArray alloc] init];
    
    for(int suitCounter = 0; suitCounter <= 3; suitCounter++)
    {
        for(int numeralCounter = 1; numeralCounter <= 13; numeralCounter++)
        {
            CardModel* card = [[[CardModel alloc] init] autorelease]; 
            
            card.suit    = suitCounter; 
            card.numeral = numeralCounter;
            card.isHeld  = YES;
            
            [self.gameModel.deck addObject:card];
        }   
    }
    
    [self.gameModel.deck shuffle];
}

-(void)newGame
{    
    [self.renderer.menuLayerController hideMenus];
        
    [self.gameModel.players setObject:[PlayerModel playerModel] forKey:self.appController.mainPlayerKey];
    [self.gameModel.playerKeys addObject:self.appController.mainPlayerKey];
    
    [self newDeck];

    PlayerModel* player = [self.gameModel.players objectForKey:self.appController.mainPlayerKey];
    
    player.chipTotal = 1000;
    player.status = PlayerStatusNoCards;
    
    [self updatePlayersAndThen:nil];
}

-(void)labelTouchedWithKey:(NSString*)key
{
    [super labelTouchedWithKey:key];
    
    PlayerModel* player = [self.gameModel.players objectForKey:self.appController.mainPlayerKey];
    
    if([key isEqual:@"call"]) 
    { 
        [self givePrize];
    
        player.status = PlayerStatusShownCards;
        
        [self updatePlayersAndThen:nil];
    }
    else if([key isEqual:@"deal"]) 
    { 
        [self.gameModel.discard addObjectsFromArray:player.cards];
        
        NSArray* newCards = [self.gameModel getCards:5];

        [player.cards removeAllObjects];
        [player.orderedCards removeAllObjects];
        
        [player.cards addObjectsFromArray:newCards];
        [player.orderedCards addObjectsFromArray:newCards];
        
        player.status = PlayerStatusDealtCards;

        [self updatePlayersAndThen:nil];
    }
    else if([key isEqual:@"draw"]) 
    { 
        int cardsToDraw = player.drawnCards.count;
    
        [self.gameModel.discard addObjectsFromArray:player.drawnCards];
        
        NSArray* newCards = [self.gameModel getCards:cardsToDraw];
        
        [player.cards removeObjectsInArray:player.drawnCards]; 
        [player.orderedCards removeObjectsInArray:player.drawnCards]; 
        
        [player.cards addObjectsFromArray:newCards];
        [player.orderedCards addObjectsFromArray:newCards];
        
        player.status = PlayerStatusDrawnCards;
        
        [self updatePlayersAndThen:nil];
    }
    else if([key isEqual:@"cancel_bet"]) 
    {         
        if(player.betTotal > 0)
        {
            [player cancelBets];
        }
        else 
        {
            [player allIn];
        }

        [self updatePlayersAndThen:nil];
    }   
}

-(void)cardFrontTapped:(int)card
{ 
    PlayerModel* playerModel = [self.gameModel.players objectForKey:self.appController.mainPlayerKey];

    CardModel* cardModel = [playerModel.cards objectAtIndex:card];

    cardModel.isHeld = !cardModel.isHeld;

    [self updatePlayersAndThen:nil];
}

-(void)cardBackTapped:(int)card 
{    
    PlayerModel* playerModel = [self.gameModel.players objectForKey:self.appController.mainPlayerKey];
    GLPlayer* glPlayer = (GLPlayer*)[self.renderer.players liveObjectForKey:self.appController.mainPlayerKey];
    
    GLCard* glCard = [glPlayer.cardGroup.cards.liveObjects objectAtIndex:card];
    
    if(glCard.isFlipped.value > 0.5)
    {
        playerModel.status = PlayerStatusNoCards;
        
        [self.gameModel.discard addObjectsFromArray:playerModel.cards];
        [playerModel.cards removeAllObjects];
        
        [self updatePlayersAndThen:nil];
    }
    else 
    {
        [self.renderer.camera.pitchAngle setValue:90 forTime:1];
    }
}

-(void)moveCardIndex:(int)initialIndex toIndex:(int)finalIndex
{
    PlayerModel* playerModel = [self.gameModel.players objectForKey:self.appController.mainPlayerKey];
    
    CardModel* card = [[[playerModel.cards objectAtIndex:initialIndex] retain] autorelease];
    
    [playerModel.cards removeObject:card];
    
    [playerModel.cards insertObject:card atIndex:finalIndex];
}

-(void)chipSwipedUpWithKey:(NSString*)key
{
    PlayerModel* playerModel = [self.gameModel.players objectForKey:self.appController.mainPlayerKey];
    
    ChipModel* chipModel = [playerModel.chips objectForKey:key];
    
    chipModel.betCount += 1;
    
    [self updatePlayersAndThen:nil];
}

-(void)chipSwipedDownWithKey:(NSString*)key
{
    PlayerModel* playerModel = [self.gameModel.players objectForKey:self.appController.mainPlayerKey];
    
    ChipModel* chipModel = [playerModel.chips objectForKey:key];
    
    chipModel.betCount -= 1;
    
    [self updatePlayersAndThen:nil];
}

-(void)updatePlayersAndThen:(SimpleBlock)work
{
    [self.renderer updatePlayersWithKeys:self.gameModel.playerKeys andThen:^
    {
        [self updateCardsAndThen:^
        {
            AnimationGroup* animationGroup = [AnimationGroup animationGroup];
            
            NSString* chipToken = [animationGroup acquireToken];
            NSString* textToken = [animationGroup acquireToken];
            
            [self updateChipsAndThen:^{ [animationGroup redeemToken:chipToken]; }];
            [self updateTextAndThen:^{ [animationGroup redeemToken:textToken]; }];
            
            [animationGroup finishAndThen:work];
        }];
    }];
}


-(void)updateCardsAndThen:(SimpleBlock)work
{
    AnimationGroup* animationGroup = [AnimationGroup animationGroup];
    
    for(NSString* playerKey in self.gameModel.playerKeys)
    {
        GLPlayer* glPlayer = (GLPlayer*)[self.renderer.players liveObjectForKey:playerKey];
        PlayerModel* playerModel = [self.gameModel.players objectForKey:playerKey];
        BOOL isMe = [self.appController.mainPlayerKey isEqualToString:playerKey];
        
        NSString* token = [animationGroup acquireToken];
        
        [glPlayer.cardGroup setFlipped:playerModel.status == PlayerStatusShownCards andThen:^
        {
            glPlayer.cardGroup.showLabels = isMe && playerModel.status == PlayerStatusDealtCards;
                        
            [glPlayer.cardGroup updateCardsWithKeys:playerModel.cardKeys held:(isMe && playerModel.status == PlayerStatusDealtCards) ? playerModel.heldKeys : playerModel.cardKeys andThen:nil];
            [glPlayer.flatCardGroup updateCardsWithKeys:playerModel.drawnKeys andThen:nil];
            
            [animationGroup redeemToken:token afterAnimation:glPlayer.cardGroup.cards];
        }];
    }
    
    [animationGroup finishAndThen:work];
}

-(void)updateChipsAndThen:(SimpleBlock)work
{
    AnimationGroup* animationGroup = [AnimationGroup animationGroup];
    
    for(NSString* playerKey in self.gameModel.playerKeys)
    {
        GLPlayer* glPlayer = (GLPlayer*)[self.renderer.players liveObjectForKey:playerKey];
        PlayerModel* playerModel = [self.gameModel.players objectForKey:playerKey];
        
        int offset = 4;
        
        if(playerModel.chipTotal <= 50000) { offset = 3; }
        if(playerModel.chipTotal <= 20000) { offset = 2; }
        if(playerModel.chipTotal <= 10000) { offset = 1; }
        if(playerModel.chipTotal <=  2000) { offset = 0; }
        
        [glPlayer.chipGroup.offset setValue:offset forTime:1 andThen:nil];
        
        { GLChip* chip = (GLChip*)[glPlayer.chipGroup.chips liveObjectForKey:@"1"    ]; chip.maxCount = [[playerModel.chips objectForKey:@"1"    ] chipCount]; [chip.count setValue:[[playerModel.chips objectForKey:@"1"    ] displayCount] withSpeed:6 andThen:nil]; [animationGroup addAnimation:chip.count]; }
        { GLChip* chip = (GLChip*)[glPlayer.chipGroup.chips liveObjectForKey:@"5"    ]; chip.maxCount = [[playerModel.chips objectForKey:@"5"    ] chipCount]; [chip.count setValue:[[playerModel.chips objectForKey:@"5"    ] displayCount] withSpeed:6 andThen:nil]; [animationGroup addAnimation:chip.count]; }
        { GLChip* chip = (GLChip*)[glPlayer.chipGroup.chips liveObjectForKey:@"10"   ]; chip.maxCount = [[playerModel.chips objectForKey:@"10"   ] chipCount]; [chip.count setValue:[[playerModel.chips objectForKey:@"10"   ] displayCount] withSpeed:6 andThen:nil]; [animationGroup addAnimation:chip.count]; }
        { GLChip* chip = (GLChip*)[glPlayer.chipGroup.chips liveObjectForKey:@"50"   ]; chip.maxCount = [[playerModel.chips objectForKey:@"50"   ] chipCount]; [chip.count setValue:[[playerModel.chips objectForKey:@"50"   ] displayCount] withSpeed:6 andThen:nil]; [animationGroup addAnimation:chip.count]; }
        { GLChip* chip = (GLChip*)[glPlayer.chipGroup.chips liveObjectForKey:@"100"  ]; chip.maxCount = [[playerModel.chips objectForKey:@"100"  ] chipCount]; [chip.count setValue:[[playerModel.chips objectForKey:@"100"  ] displayCount] withSpeed:6 andThen:nil]; [animationGroup addAnimation:chip.count]; }    
        { GLChip* chip = (GLChip*)[glPlayer.chipGroup.chips liveObjectForKey:@"500"  ]; chip.maxCount = [[playerModel.chips objectForKey:@"500"  ] chipCount]; [chip.count setValue:[[playerModel.chips objectForKey:@"500"  ] displayCount] withSpeed:6 andThen:nil]; [animationGroup addAnimation:chip.count]; }    
        { GLChip* chip = (GLChip*)[glPlayer.chipGroup.chips liveObjectForKey:@"1000" ]; chip.maxCount = [[playerModel.chips objectForKey:@"1000" ] chipCount]; [chip.count setValue:[[playerModel.chips objectForKey:@"1000" ] displayCount] withSpeed:6 andThen:nil]; [animationGroup addAnimation:chip.count]; }    
        { GLChip* chip = (GLChip*)[glPlayer.chipGroup.chips liveObjectForKey:@"5000" ]; chip.maxCount = [[playerModel.chips objectForKey:@"5000" ] chipCount]; [chip.count setValue:[[playerModel.chips objectForKey:@"5000" ] displayCount] withSpeed:6 andThen:nil]; [animationGroup addAnimation:chip.count]; }    
        { GLChip* chip = (GLChip*)[glPlayer.chipGroup.chips liveObjectForKey:@"10000"]; chip.maxCount = [[playerModel.chips objectForKey:@"10000"] chipCount]; [chip.count setValue:[[playerModel.chips objectForKey:@"10000"] displayCount] withSpeed:6 andThen:nil]; [animationGroup addAnimation:chip.count]; }
    }
    
    [animationGroup finishAndThen:work];
}

-(void)updateTextAndThen:(SimpleBlock)work
{
    AnimationGroup* animationGroup = [AnimationGroup animationGroup];
    
    for(NSString* playerKey in self.renderer.players.liveKeys)
    {
        PlayerModel* playerModel = [self.gameModel.players objectForKey:self.appController.mainPlayerKey];
        GLPlayer* glPlayer = (GLPlayer*)[self.renderer.players liveObjectForKey:self.appController.mainPlayerKey];
        
        NSString* messageDown = @" ";
        NSString* messageUp   = @" ";
        
        NSMutableArray* actionLabels   = [NSMutableArray array];
        NSMutableArray* gameOverLabels = [NSMutableArray array];
        
        if([playerKey isEqual:self.appController.mainPlayerKey])
        {
            if(playerModel.status == PlayerStatusDealtCards)
            {        
                NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
                
                if(playerModel.numberOfCardsMarked)
                {
                    [label setObject: @"draw" forKey:@"key"]; 
                    [label setObject: @"DRAW" forKey:@"textString"]; 
                }
                else 
                {
                    [label setObject: @"call" forKey:@"key"]; 
                    [label setObject: @"CALL" forKey:@"textString"]; 
                }
                
                [actionLabels addObject:label];
                
                messageDown = self.renderer.camera.isAutomatic ? [NSString stringWithFormat:@"Tilt %@ to peek at your cards", [[UIDevice currentDevice] name]] : @"Tap deck to peek at cards";
                messageUp = @"Tap cards to mark";
            }
            else if(playerModel.status == PlayerStatusDrawnCards)
            {   
                NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
                
                [label setObject:@"call" forKey:@"key"]; 
                [label setObject:@"CALL" forKey:@"textString"]; 
                
                [actionLabels addObject:label];
                
                messageDown = self.renderer.camera.isAutomatic ? @"Tilt iPhone to peek at your cards" : @"Tap deck to peek at cards";
                messageUp = @" ";
            }
            else if(playerModel.status == PlayerStatusShownCards)
            {
                NSString* scoreName = [self scoreName];
                
                messageDown = scoreName;
                messageUp   = scoreName;
            }
            else if(playerModel.status == PlayerStatusNoCards)
            {   
                if(playerModel.chipTotal > 0)
                {
                    if(playerModel.betTotal > 0)
                    {
                        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
                        
                        [label setObject:@"deal" forKey:@"key"]; 
                        [label setObject:@"DEAL" forKey:@"textString"]; 
                        
                        [actionLabels addObject:label];
                        
                        messageDown = @"Tap 'Deal' When Ready";
                        messageUp = @" ";
                    }
                    else
                    {
                        messageDown = @"Place Your Bet";
                        messageUp = @" ";
                    }
                }
                else
                {
                    {
                        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
                        
                        [label setObject:@"gameOverNewGame"                            forKey:@"key"]; 
                        [label setObject:@"NEW GAME"                                   forKey:@"textString"]; 
                        [label setObject:[NSValue  valueWithCGSize:CGSizeMake(4.5, 0.9)] forKey:@"labelSize"];

                        [gameOverLabels addObject:label];
                    }
                    
                    {
                        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
                        
                        [label setObject:@"gameOverQuit" forKey:@"key"]; 
                        [label setObject:@"QUIT" forKey:@"textString"]; 
                        [label setObject:[NSValue  valueWithCGSize:CGSizeMake(4.5, 0.9)] forKey:@"labelSize"];

                        [gameOverLabels addObject:label];
                    }
                    
                    messageDown = @"Game Over";
                    messageUp = @" ";
                }
            }
        
            {
                GLTextControllerCredits* textController = [glPlayer.textControllers objectForKey:@"credits"];
                textController.creditTotal = playerModel.chipTotal;
                textController.betTotal = playerModel.betTotal;
                textController.showButton = playerModel.status == PlayerStatusNoCards;
                [textController update];
                [animationGroup addAnimation:textController.items]; 
            }
            
            { 
                GLTextControllerActions* textController = [glPlayer.textControllers objectForKey:@"actions"];     
                [textController fillWithDictionaries:actionLabels];   
                [textController update]; 
                [animationGroup addAnimation:textController.items]; 
            }
            
            { 
                GLTextControllerActions* textController = [glPlayer.textControllers objectForKey:@"gameOver"];    
                [textController fillWithDictionaries:gameOverLabels]; 
                [textController update]; 
                [animationGroup addAnimation:textController.items]; 
            }
            
            {
                GLTextControllerStatusBar* textController = [glPlayer.textControllers objectForKey:@"messageDown"]; 
                [textController setText:messageDown];                 
                [textController update]; 
                [animationGroup addAnimation:textController.items]; 
            }
            
            { 
                GLTextControllerStatusBar* textController = [glPlayer.textControllers objectForKey:@"messageUp"];   
                [textController setText:messageUp];                   
                [textController update]; 
                [animationGroup addAnimation:textController.items]; 
            }
        }
        else
        {
            
        }
    }
    
    [animationGroup finishAndThen:work];
}


-(void)givePrize
{
    PlayerModel* player = [self.gameModel.players objectForKey:self.appController.mainPlayerKey];
    
    ScoreController* score = [ScoreController scoreCards:player.cards];
    
    int prize = 0;
    
    for(ScoreController* level in self.rankLevels.reverseObjectEnumerator) 
    {
        if([score compare:level] != NSOrderedAscending)
        {
            prize = [[self.rankPrizes objectForKey:level] intValue];
            
            break;
        }
    }
    
    player.chipTotal = player.chipTotal - player.betTotal + prize * player.betTotal;
    [player cancelBets];
}

-(NSString*)scoreName
{
    PlayerModel* player = [self.gameModel.players objectForKey:self.appController.mainPlayerKey];

    ScoreController* score = [ScoreController scoreCards:player.cards];
    
    int prize = 0;
    
    NSString* scoreName = @" ";
    
    for(ScoreController* level in self.rankLevels.reverseObjectEnumerator) 
    {
        int comparison = [score compare:level];
        
        if(comparison >= 0)
        {
            scoreName = [self.rankNames objectForKey:level];
            prize = [[self.rankPrizes objectForKey:level] intValue];
            
            break;
        }
    }
    
    return (prize == 0) ? @"No Prize" : scoreName;
}

@end