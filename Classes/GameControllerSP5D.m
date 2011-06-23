#import "NSArray+Circle.h"
#import "GameRenderer.h"
#import "PlayerModel.h"
#import "CardModel.h"
#import "ChipModel.h"
#import "GameModel.h"
#import "GLChipGroup.h"
#import "GLChip.h"
#import "GLCardGroup.h"
#import "GLCard.h"
#import "GLSplash.h"
#import "TextController.h"
#import "TextControllerStatusBar.h"
#import "GLLabel.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "CameraController.h"
#import "MenuLayerController.h"
#import "TextControllerCredits.h"

#import "GameControllerSP.h"

typedef enum 
{    
    PlayerStatusNoCards,
    PlayerStatusDealtCards,
    PlayerStatusDrawnCards,
    PlayerStatusShownCards
} 
PlayerStatus;

@implementation GameControllerSP

+(GameController*)loadWithRenderer:(GameRenderer*)renderer
{
    NSString* file    = [NSString stringWithFormat:@"%@.json", NSStringFromClass(self)];
    NSString* archive = [NSString stringWithContentsOfDocument:file];

    //NSString* archive = @"{\"discard\":[{\"suit\":3,\"numeral\":1,\"isHeld\":true},{\"suit\":3,\"numeral\":2,\"isHeld\":true},{\"suit\":3,\"numeral\":8,\"isHeld\":true},{\"suit\":1,\"numeral\":4,\"isHeld\":true},{\"suit\":1,\"numeral\":2,\"isHeld\":true},{\"suit\":0,\"numeral\":6,\"isHeld\":true},{\"suit\":3,\"numeral\":9,\"isHeld\":true},{\"suit\":1,\"numeral\":1,\"isHeld\":true},{\"suit\":1,\"numeral\":7,\"isHeld\":true},{\"suit\":2,\"numeral\":1,\"isHeld\":true}],\"players\":{\"\":{\"status\":0,\"chips\":{\"2500\" :{\"key\":\"2500\", \"chipCount\":0,\"betCount\":0},\"10000\":{\"key\":\"10000\",\"chipCount\":0,\"betCount\":0},\"1000\" :{\"key\":\"1000\", \"chipCount\":0,\"betCount\":0},\"1K\"   :{\"key\":\"1K\",   \"chipCount\":0,\"betCount\":0},\"10K\"  :{\"key\":\"10K\",  \"chipCount\":0, \"betCount\":0},\"5\"    :{\"key\":\"5\",    \"chipCount\":10,\"betCount\":0},\"1\"    :{\"key\":\"1\",    \"chipCount\":10,\"betCount\":0},\"25\"   :{\"key\":\"25\",   \"chipCount\":10,\"betCount\":0},\"100\"  :{\"key\":\"100\",  \"chipCount\":10,\"betCount\":0},\"10\"   :{\"key\":\"10\",   \"chipCount\":10,\"betCount\":0},\"500\"  :{\"key\":\"500\",  \"chipCount\":0, \"betCount\":0}},\"cards\":[{\"suit\":1,\"numeral\":13,\"isHeld\":true},{\"suit\":0,\"numeral\":7,\"isHeld\":true},{\"suit\":2,\"numeral\":8,\"isHeld\":true},{\"suit\":1,\"numeral\":6,\"isHeld\":false},{\"suit\":0,\"numeral\":9,\"isHeld\":true}]}},\"status\":0,\"playerIds\":[\"\"],\"deck\":[{\"suit\":0,\"numeral\":3,\"isHeld\":true},{\"suit\":0,\"numeral\":1,\"isHeld\":true},{\"suit\":1,\"numeral\":12,\"isHeld\":true},{\"suit\":3,\"numeral\":11,\"isHeld\":true},{\"suit\":2,\"numeral\":2,\"isHeld\":true},{\"suit\":1,\"numeral\":3,\"isHeld\":true},{\"suit\":3,\"numeral\":6,\"isHeld\":true},{\"suit\":3,\"numeral\":5,\"isHeld\":false},{\"suit\":1,\"numeral\":9,\"isHeld\":true},{\"suit\":3,\"numeral\":13,\"isHeld\":true},{\"suit\":2,\"numeral\":12,\"isHeld\":true},{\"suit\":1,\"numeral\":10,\"isHeld\":true},{\"suit\":2,\"numeral\":13,\"isHeld\":true},{\"suit\":2,\"numeral\":4,\"isHeld\":true},{\"suit\":0,\"numeral\":2,\"isHeld\":true},{\"suit\":3,\"numeral\":3,\"isHeld\":true},{\"suit\":0,\"numeral\":13,\"isHeld\":true},{\"suit\":2,\"numeral\":9,\"isHeld\":true},{\"suit\":0,\"numeral\":12,\"isHeld\":true},{\"suit\":0,\"numeral\":4,\"isHeld\":true},{\"suit\":1,\"numeral\":5,\"isHeld\":true},{\"suit\":2,\"numeral\":10,\"isHeld\":true},{\"suit\":0,\"numeral\":11,\"isHeld\":true},{\"suit\":2,\"numeral\":6,\"isHeld\":true},{\"suit\":0,\"numeral\":10,\"isHeld\":true},{\"suit\":0,\"numeral\":8,\"isHeld\":true},{\"suit\":2,\"numeral\":7,\"isHeld\":true},{\"suit\":1,\"numeral\":11,\"isHeld\":true},{\"suit\":2,\"numeral\":5,\"isHeld\":true},{\"suit\":3,\"numeral\":4,\"isHeld\":true},{\"suit\":3,\"numeral\":10,\"isHeld\":true},{\"suit\":3,\"numeral\":7,\"isHeld\":true},{\"suit\":2,\"numeral\":3,\"isHeld\":true},{\"suit\":1,\"numeral\":8,\"isHeld\":true},{\"suit\":2,\"numeral\":11,\"isHeld\":true},{\"suit\":3,\"numeral\":12,\"isHeld\":true},{\"suit\":0,\"numeral\":5,\"isHeld\":true}]}";
        
    if(archive)
    {
        GameControllerSP* gameController = [[[self alloc] init] autorelease];
        
        gameController.renderer = renderer;
        gameController.game = [GameModel withDictionary:[archive JSONValue]];
        
        [gameController newGame];
        [gameController updatePlayer];
        
        return gameController;
    }
    else 
    {
        return nil;
    }
}

-(id)init
{
    self = [super init];
    
	if(self)
	{
        _rankPrizes = [[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:  0], [_rankLevels objectAtIndex:0],
                                                                  [NSNumber numberWithInt:  0], [_rankLevels objectAtIndex:1],
                                                                  [NSNumber numberWithInt:  1], [_rankLevels objectAtIndex:2],
                                                                  [NSNumber numberWithInt:  2], [_rankLevels objectAtIndex:3],
                                                                  [NSNumber numberWithInt:  3], [_rankLevels objectAtIndex:4],
                                                                  [NSNumber numberWithInt:  4], [_rankLevels objectAtIndex:5],
                                                                  [NSNumber numberWithInt:  6], [_rankLevels objectAtIndex:6],
                                                                  [NSNumber numberWithInt:  9], [_rankLevels objectAtIndex:7],
                                                                  [NSNumber numberWithInt: 25], [_rankLevels objectAtIndex:8],
                                                                  [NSNumber numberWithInt: 50], [_rankLevels objectAtIndex:9],
                                                                  [NSNumber numberWithInt:800], [_rankLevels objectAtIndex:10], nil] retain];
    }
	
	return self;
}

-(void)newGame
{    
    [super newGame];

    self.player.chipTotal = 1000;
    self.player.status = PlayerStatusNoCards;
    
    [self updatePlayer];
}

-(void)labelTouchedWithKey:(NSString*)key
{
    [super labelTouchedWithKey:key];
    
    if([key isEqual:@"call"]) 
    { 
        [self givePrize];
    
        self.player.status = PlayerStatusShownCards;
        
        [self updatePlayer];
    }
    else if([key isEqual:@"deal"]) 
    { 
        [self.game.discard addObjectsFromArray:self.player.cards];
        [self.player.cards removeAllObjects]; 
        [self.player.cards addObjectsFromArray:[self.game getCards:5]];
        
        self.player.status = PlayerStatusDealtCards;

        [self updatePlayer];
    }
    else if([key isEqual:@"draw"]) 
    { 
        int cardsToDraw = self.player.drawnCards.count;
    
        [self.game.discard addObjectsFromArray:self.player.drawnCards];
        [self.player.cards removeObjectsInArray:self.player.drawnCards]; 
        [self.player.cards addObjectsFromArray:[self.game getCards:cardsToDraw]];
        
        self.player.status = PlayerStatusDrawnCards;
        
        [self updatePlayer];
    }
    else if([key isEqual:@"cancel_bet"]) 
    {         
        if(self.player.betTotal > 0)
        {
            [self.player cancelBets];
        }
        else 
        {
            [self.player allIn];
        }

        [self updatePlayer];
    }   
}

-(void)cardFrontTapped:(int)card
{ 
    CardModel* cardModel = [self.player.cards objectAtIndex:card];

    cardModel.isHeld = !cardModel.isHeld;
    
    [self updatePlayer];
}

-(void)cardBackTapped:(int)card 
{
    if(self.renderer.camera.status == CameraStatusCardsFlipped)
    {
        self.player.status = PlayerStatusNoCards;
        
        [self.game.discard addObjectsFromArray:self.player.cards];
        [self.player.cards removeAllObjects];

        [self updatePlayer];
    }
    else 
    {
        [super cardBackTapped:card];
    }
}

-(void)updatePlayer
{
    [self saveData];

    [self updateChips];
    
    NSMutableArray* actionLabels = [NSMutableArray array];
    NSMutableArray* gameOverLabels = [NSMutableArray array];
        
    if(self.player.status == PlayerStatusNoCards)
    {   
        self.renderer.chipGroup.frozen = NO;
        
        LOG_NS(@"Unflipping");
        
        [self.renderer.cardGroup unflipCardsAndThen:^
        { 
            LOG_NS(@"Updating Cards");

            [self updateCardsAndThen:^
            {
                LOG_NS(@"Updating Everything Else");
                
                if(self.player.chipTotal > 0)
                {
                    if(self.player.betTotal > 0)
                    {
                        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
                        
                        [label setObject:@"deal" forKey:@"key"]; 
                        [label setObject:@"DEAL" forKey:@"textString"]; 
                        
                        [actionLabels addObject:label];
                        
                        self.messageDown = @"Tap 'Deal' When Ready";
                        self.messageUp = @" ";
                    }
                    else
                    {
                        self.messageDown = @"Place Your Bet";
                        self.messageUp = @" ";
                    }
                }
                else
                {
                    {
                        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
                        
                        [label setObject:@"gameOverNewGame" forKey:@"key"]; 
                        [label setObject:@"NEW GAME" forKey:@"textString"]; 
                        [label setObject:[NSValue  valueWithCGSize:CGSizeMake(4.5, 0.9)] forKey:@"labelSize"];
                        
                        [gameOverLabels addObject:label];
                    }
                    
                    {
                        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
                        
                        [label setObject:@"gameOverQuit" forKey:@"key"]; 
                        [label setObject:@"QUIT" forKey:@"textString"]; 
                        [label setObject:[NSValue  valueWithCGSize:CGSizeMake(4.5, 0.9)] forKey:@"labelSize"];
                        
                        [gameOverLabels addObject:label];
                    }
                    
                    self.messageDown = @"Game Over";
                    self.messageUp = @"Game Over";
                }
                
                [[self.renderer.textControllers objectForKey:@"actions"] fillWithDictionaries:actionLabels];
                [[self.renderer.textControllers objectForKey:@"gameOver"] fillWithDictionaries:gameOverLabels];
                
                { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"messageDown"]; textController.text = self.messageDown; [textController update]; }
                { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"messageUp"]; textController.text = self.messageUp;   [textController update]; }
            }]; 
        }];
    }
    else if(self.player.status == PlayerStatusDealtCards)
    {        
        self.renderer.chipGroup.frozen = YES;

        [[self.renderer.textControllers objectForKey:@"actions"] fillWithDictionaries:nil];
        [[self.renderer.textControllers objectForKey:@"gameOver"] fillWithDictionaries:nil];
        
        [self updateCardsAndThen:^
        {
            NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
            
            if(self.player.numberOfCardsMarked)
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
            
            self.messageDown = self.renderer.camera.isAutomatic ? [NSString stringWithFormat:@"Tilt %@ to peek at your cards", [[UIDevice currentDevice] name]] : @"Tap deck to peek at cards";
            self.messageUp = @"Tap cards to mark";
            
            [[self.renderer.textControllers objectForKey:@"actions"] fillWithDictionaries:actionLabels];
            [[self.renderer.textControllers objectForKey:@"gameOver"] fillWithDictionaries:nil];
            
            { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"messageDown"]; textController.text = self.messageDown; [textController update]; }
            { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"messageUp"]; textController.text = self.messageUp;   [textController update]; }
        }];
    }
    else if(self.player.status == PlayerStatusDrawnCards)
    {   
        self.renderer.chipGroup.frozen = YES;     
        
        [[self.renderer.textControllers objectForKey:@"actions"] fillWithDictionaries:nil];
        [[self.renderer.textControllers objectForKey:@"gameOver"] fillWithDictionaries:nil];
        
        [self updateCardsAndThen:^
        {
            NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
            
            [label setObject:@"call" forKey:@"key"]; 
            [label setObject:@"CALL" forKey:@"textString"]; 
            
            [actionLabels addObject:label];
            
            self.messageDown = self.renderer.camera.isAutomatic ? @"Tilt iPhone to peek at your cards" : @"Tap deck to peek at cards";
            self.messageUp = @" ";
            
            [[self.renderer.textControllers objectForKey:@"actions"] fillWithDictionaries:actionLabels];
            [[self.renderer.textControllers objectForKey:@"gameOver"] fillWithDictionaries:nil];
            
            { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"messageDown"]; textController.text = self.messageDown; [textController update]; }
            { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"messageUp"]; textController.text = self.messageUp;   [textController update]; }
        }];
    }
    else if(self.player.status == PlayerStatusShownCards)
    {
        self.renderer.chipGroup.frozen = YES;
        
        [[self.renderer.textControllers objectForKey:@"actions"] fillWithDictionaries:nil];
                
        [self.renderer.cardGroup flipCardsAndThen:nil];

        [[self.renderer.textControllers objectForKey:@"actions"] fillWithDictionaries:nil];
        [[self.renderer.textControllers objectForKey:@"gameOver"] fillWithDictionaries:nil];
        
        { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"messageDown"]; textController.text = self.messageDown; [textController update]; }
        { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"messageUp"]; textController.text = self.messageUp;   [textController update]; }
    }
}

-(void)updateCardsAndThen:(SimpleBlock)work
{
    [self.renderer.cardGroup updateCardsWithKeys:self.player.cardKeys held:(self.player.status == PlayerStatusDealtCards) ? self.player.heldKeys : self.player.cardKeys andThen:work];

    self.renderer.cardGroup.showLabels = (self.player.status == PlayerStatusDealtCards);
}

-(void)updateCards
{
    [self updateCardsAndThen:nil];
}

-(void)givePrize
{
    NSString* score = [self scoreHand];
    
    NSString* scoreName = @"Unknown";
    
    int prize = 0;
    
    for(NSString* level in _rankLevels.reverseObjectEnumerator) 
    {
        int comparison = [score compare:level];
        
        if(comparison >= 0)
        {
            scoreName = [_rankNames objectForKey:level];
            prize = [[_rankPrizes objectForKey:level] intValue] * (self.player.betTotal);
            
            break;
        }
    }
    
    self.messageDown = (prize == 0) ? @"No Prize" : [NSString stringWithFormat:@"%@   +%d credits", scoreName, prize - self.player.betTotal];
    self.messageUp   = (prize == 0) ? @"No Prize" : [NSString stringWithFormat:@"%@   +%d credits", scoreName, prize - self.player.betTotal];

    LOG_EXPR(self.messageDown);
    LOG_EXPR(self.messageUp);

    self.player.chipTotal = self.player.chipTotal - self.player.betTotal + prize;
    [self.player cancelBets];
    
    //[self updatePlayer];
}

-(void)updateChips;
{
    TextControllerCredits* textController = [self.renderer.textControllers objectForKey:@"credits"];
    
    textController.showButton = (self.player.status == PlayerStatusNoCards);

    [textController.opacity setValue:(self.player.status != PlayerStatusShownCards) forTime:0.5 andThen:nil];
    
    [textController update];

    [super updateChips];
}

@end