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

#import "GameControllerSP.h"

@implementation GameControllerSP

+(GameController*)loadWithRenderer:(GameRenderer*)renderer
{
    //NSString* file = [NSString stringWithFormat:@"%@.json", NSStringFromClass(self)];
    
    NSString* archive = @"{\"discard\":[{\"suit\":3,\"numeral\":1,\"isHeld\":true},{\"suit\":3,\"numeral\":2,\"isHeld\":true},{\"suit\":3,\"numeral\":8,\"isHeld\":true},{\"suit\":1,\"numeral\":4,\"isHeld\":true},{\"suit\":1,\"numeral\":2,\"isHeld\":true},{\"suit\":0,\"numeral\":6,\"isHeld\":true},{\"suit\":3,\"numeral\":9,\"isHeld\":true},{\"suit\":1,\"numeral\":1,\"isHeld\":true},{\"suit\":1,\"numeral\":7,\"isHeld\":true},{\"suit\":2,\"numeral\":1,\"isHeld\":true}],\"players\":{\"\":{\"status\":0,\"chips\":{\"2500\" :{\"key\":\"2500\", \"chipCount\":0,\"betCount\":0},\"10000\":{\"key\":\"10000\",\"chipCount\":0,\"betCount\":0},\"1000\" :{\"key\":\"1000\", \"chipCount\":0,\"betCount\":0},\"1K\"   :{\"key\":\"1K\",   \"chipCount\":0,\"betCount\":0},\"10K\"  :{\"key\":\"10K\",  \"chipCount\":0, \"betCount\":0},\"5\"    :{\"key\":\"5\",    \"chipCount\":10,\"betCount\":0},\"1\"    :{\"key\":\"1\",    \"chipCount\":10,\"betCount\":0},\"25\"   :{\"key\":\"25\",   \"chipCount\":10,\"betCount\":0},\"100\"  :{\"key\":\"100\",  \"chipCount\":10,\"betCount\":0},\"10\"   :{\"key\":\"10\",   \"chipCount\":10,\"betCount\":0},\"500\"  :{\"key\":\"500\",  \"chipCount\":0, \"betCount\":0}},\"cards\":[{\"suit\":1,\"numeral\":13,\"isHeld\":true},{\"suit\":0,\"numeral\":7,\"isHeld\":true},{\"suit\":2,\"numeral\":8,\"isHeld\":true},{\"suit\":1,\"numeral\":6,\"isHeld\":false},{\"suit\":0,\"numeral\":9,\"isHeld\":true}]}},\"status\":0,\"playerIds\":[\"\"],\"deck\":[{\"suit\":0,\"numeral\":3,\"isHeld\":true},{\"suit\":0,\"numeral\":1,\"isHeld\":true},{\"suit\":1,\"numeral\":12,\"isHeld\":true},{\"suit\":3,\"numeral\":11,\"isHeld\":true},{\"suit\":2,\"numeral\":2,\"isHeld\":true},{\"suit\":1,\"numeral\":3,\"isHeld\":true},{\"suit\":3,\"numeral\":6,\"isHeld\":true},{\"suit\":3,\"numeral\":5,\"isHeld\":false},{\"suit\":1,\"numeral\":9,\"isHeld\":true},{\"suit\":3,\"numeral\":13,\"isHeld\":true},{\"suit\":2,\"numeral\":12,\"isHeld\":true},{\"suit\":1,\"numeral\":10,\"isHeld\":true},{\"suit\":2,\"numeral\":13,\"isHeld\":true},{\"suit\":2,\"numeral\":4,\"isHeld\":true},{\"suit\":0,\"numeral\":2,\"isHeld\":true},{\"suit\":3,\"numeral\":3,\"isHeld\":true},{\"suit\":0,\"numeral\":13,\"isHeld\":true},{\"suit\":2,\"numeral\":9,\"isHeld\":true},{\"suit\":0,\"numeral\":12,\"isHeld\":true},{\"suit\":0,\"numeral\":4,\"isHeld\":true},{\"suit\":1,\"numeral\":5,\"isHeld\":true},{\"suit\":2,\"numeral\":10,\"isHeld\":true},{\"suit\":0,\"numeral\":11,\"isHeld\":true},{\"suit\":2,\"numeral\":6,\"isHeld\":true},{\"suit\":0,\"numeral\":10,\"isHeld\":true},{\"suit\":0,\"numeral\":8,\"isHeld\":true},{\"suit\":2,\"numeral\":7,\"isHeld\":true},{\"suit\":1,\"numeral\":11,\"isHeld\":true},{\"suit\":2,\"numeral\":5,\"isHeld\":true},{\"suit\":3,\"numeral\":4,\"isHeld\":true},{\"suit\":3,\"numeral\":10,\"isHeld\":true},{\"suit\":3,\"numeral\":7,\"isHeld\":true},{\"suit\":2,\"numeral\":3,\"isHeld\":true},{\"suit\":1,\"numeral\":8,\"isHeld\":true},{\"suit\":2,\"numeral\":11,\"isHeld\":true},{\"suit\":3,\"numeral\":12,\"isHeld\":true},{\"suit\":0,\"numeral\":5,\"isHeld\":true}]}";//[NSString stringWithContentsOfDocument:file];
    
    if(archive)
    {
        GameControllerSP* gameController = [[[self alloc] init] autorelease];
        
        gameController.renderer = renderer;
        
        gameController.game = [GameModel withDictionary:[archive JSONValue]];
        
        //TODO: refactor this into updateRendererAnimated
        for(CardModel* card in gameController.player.cards.reverseObjectEnumerator) 
        {
            [gameController.renderer.cardGroup addCardWithSuit:card.suit numeral:card.numeral held:card.isHeld];
        }
        
        [gameController updateRenderer];
        
        //TODO: refactor this into updateRendererAnimated
        [gameController.renderer hideMenus];
                    
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

-(void)newGameAndThen:(simpleBlock)work
{
    [super newGameAndThen:nil];
    
    //TODO: refactor this into updateRendererAnimated
    [self.renderer hideMenus];
    
    self.game = [[[GameModel alloc] init] autorelease];
    
    [self newDeckAndThen:nil];
    
    [self.game.players setObject:[[[PlayerModel alloc] init] autorelease] forKey:self.myPeerId];
    [self.game.playerIds addObject:self.myPeerId];
    
    self.player.chipTotal = 1000;
    
    self.player.status = PlayerStatusNoCards;
    
    [self updateRenderer];
}

//TODO:REPLACE THIS WHOLE DAMN FUNCTION
//-(void)showHandAndThen:(block)work
//{
//    [super showHandAndThen:nil];
//    
//    [self.renderer flipCardsAndThen:nil];
//    
//    [[self.renderer.textControllers objectForKey:@"actions"] empty];
//    
//    self.player.status = PlayerStatusCardsShown;
//    
//    [self givePrize];
//}

-(void)chipTouchedUpWithKey:(NSString*)key
{
    if(self.player.status == PlayerStatusDealtCards)
    {
        [super chipTouchedUpWithKey:key];
    }
}

-(void)chipTouchedDownWithKey:(NSString*)key;
{
    if(self.player.status == PlayerStatusDealtCards)
    {
        [super chipTouchedDownWithKey:key];
    }
}

-(void)labelTouchedWithKey:(NSString*)key
{
    [super labelTouchedWithKey:key];
    
    if([key isEqual:@"call"]) 
    { 
        self.player.status = PlayerStatusShouldShowCards;
        
        [self updateRenderer];
    }
    
    if([key isEqual:@"draw"]) 
    { 
        if(self.player.cards.count)
        {
            self.player.status = PlayerStatusShouldDrawCards;
            
            [self updateRenderer];
        }
        else
        {
            self.player.status = PlayerStatusShouldDealCards;

            [self updateRenderer];
        }
    }
    
    if([key isEqual:@"cancel_bet"]) 
    {         
        if(self.player.betTotal)
        {
            { ChipModel* chipModel = [self.player.chips objectForKey:@"1"    ]; chipModel.betCount = 0; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"5"    ]; chipModel.betCount = 0; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"10"   ]; chipModel.betCount = 0; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"25"   ]; chipModel.betCount = 0; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"100"  ]; chipModel.betCount = 0; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"500"  ]; chipModel.betCount = 0; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"1000" ]; chipModel.betCount = 0; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"2500" ]; chipModel.betCount = 0; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"10000"]; chipModel.betCount = 0; }
        }
        else 
        {
            { ChipModel* chipModel = [self.player.chips objectForKey:@"1"    ]; chipModel.betCount = chipModel.chipCount; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"5"    ]; chipModel.betCount = chipModel.chipCount; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"10"   ]; chipModel.betCount = chipModel.chipCount; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"25"   ]; chipModel.betCount = chipModel.chipCount; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"100"  ]; chipModel.betCount = chipModel.chipCount; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"500"  ]; chipModel.betCount = chipModel.chipCount; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"1000" ]; chipModel.betCount = chipModel.chipCount; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"2500" ]; chipModel.betCount = chipModel.chipCount; }
            { ChipModel* chipModel = [self.player.chips objectForKey:@"10000"]; chipModel.betCount = chipModel.chipCount; }
        }

        [self saveData];

        [self updateRenderer];
    }   
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
            prize = [[_rankPrizes objectForKey:level] intValue] * (self.player.betTotal + 1);
            
            break;
        }
    }
    
    //TODO: refactor this into updateRendererAnimated
    if(prize == 0) 
    { 
        { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"status1"]; textController.text = @"No Prize"; [textController update]; }
        { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"status2"]; textController.text = @"No Prize"; [textController update]; }
    }
    else 
    {
        { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"status1"]; textController.text = [NSString stringWithFormat:@"%@   +%d credits", scoreName, prize - self.player.betTotal - 1]; [textController update]; }
        { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"status2"]; textController.text = [NSString stringWithFormat:@"%@   +%d credits", scoreName, prize - self.player.betTotal - 1]; [textController update]; }
    }
    
    self.player.chipTotal = self.player.chipTotal - self.player.betTotal + prize;
    
    [self updateRenderer];
}

-(void)updateRenderer
{
    TextController* textBox = [self.renderer.textControllers objectForKey:@"actions"];
    
    NSMutableArray* labels = [[[NSMutableArray alloc] init] autorelease];
    
    if(self.player.status == PlayerStatusNoCards)
    {
        NSLog(@"PlayerStatusNoCards");
        
        if(self.player.cards.count)
        {
            foreach(GLCard in self.player.cards)
            {    
                [self.renderer discardCardWithSuit:card.suit numeral:card.numeral];
            }
            
            [self.player.cards removeAllObjects];
        }
        
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"draw" forKey:@"key"]; 
        [label setObject:@"DEAL" forKey:@"textString"]; 
        
        { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"status1"]; textController.text = @" "; [textController update]; }
        { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"status2"]; textController.text = @" "; [textController update]; }
        
        [labels addObject:label];
    }
    else if(self.player.status == PlayerStatusShouldDealCards)
    {
        NSLog(@"PlayerStatusShouldDealCards");

        //TODO: deal 5 cards
        
        self.player.status = PlayerStatusDealingCards;
        
        simpleBlock work = 
        ^{
            self.player.status = PlayerStatusDealtCards;
                    
            [self updateRenderer];
        };
        
        runAfterDelay(1, work);
    }
    else if(self.player.status == PlayerStatusDealingCards)
    {
        NSLog(@"PlayerStatusDealingCards");
        
        //don't do anything
    }
    else if(self.player.status == PlayerStatusDealtCards)
    {
        NSLog(@"PlayerStatusDealtCards");

        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        if(self.player.cardsMarked)
        {
            [label setObject: @"draw" forKey:@"key"]; 
            [label setObject: @"DRAW" forKey:@"textString"]; 
        }
        else 
        {
            [label setObject: @"call" forKey:@"key"]; 
            [label setObject: @"CALL" forKey:@"textString"]; 
        }
    
        [labels addObject:label];
    
        
        if(self.renderer.camera.isAutomatic)
        {
            { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"status1"]; textController.text = @"Tilt to peek at cards"; [textController update]; }
            { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"status2"]; textController.text = @"Tap cards to mark";     [textController update]; }
        }
        else 
        {
            { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"status1"]; textController.text = @"Tap deck to peek at cards"; [textController update]; }
            { TextControllerStatusBar* textController = [self.renderer.textControllers objectForKey:@"status2"]; textController.text = @"Tap cards to mark";         [textController update]; }
        }
    }
    else if(self.player.status == PlayerStatusShouldDrawCards)
    {
        NSLog(@"PlayerStatusShouldDrawCards");
                
        //TODO: draw cards
        
        self.player.status = PlayerStatusDrawingCards;
        
        simpleBlock work = 
        ^{
            self.player.status = PlayerStatusDrawnCards;
            
            [self updateRenderer];
        };
        
        runAfterDelay(1, work);
    }
    else if(self.player.status == PlayerStatusDrawingCards)
    {
        NSLog(@"PlayerStatusDrawingCards");
    }
    else if(self.player.status == PlayerStatusDrawnCards)
    {
        NSLog(@"PlayerStatusDrawnCards");

        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"call" forKey:@"key"]; 
        [label setObject:@"CALL" forKey:@"textString"]; 
        
        [labels addObject:label]; 
    }
    else if(self.player.status == PlayerStatusShouldShowCards)
    {
        NSLog(@"PlayerStatusShouldShowCards");
        
        self.player.status = PlayerStatusShowingCards;
        
        [self.renderer flipCardsAndThen:^{ self.player.status = PlayerStatusShownCards; [self updateRenderer]; }];
    }
    else if(self.player.status == PlayerStatusShowingCards)
    {
        NSLog(@"PlayerStatusShowingCards");
    }
    else if(self.player.status == PlayerStatusShownCards)
    {
        NSLog(@"PlayerStatusShownCards");
    }
    else if(self.player.status == PlayerStatusShouldReturnCards)
    {
        NSLog(@"PlayerStatusShouldReturnCards");
    }
    else if(self.player.status == PlayerStatusReturningCards)
    {
        NSLog(@"PlayerStatusReturningCards");
    }
    else 
    {
        NSLog(@"%d", self.player.status);
    }

    [textBox fillWithDictionaries:labels];
    
    [super updateRenderer];
}

-(void)cardFrontTouched:(int)card
{ 
    [super cardFrontTouched:card];
    
    [self updateRenderer];
}

-(void)cardBackTouched:(int)card 
{
    if(self.renderer.camera.status == CameraStatusCardsFlipped)
    {
        [self endHandAndThen:^{ [self updateRenderer]; }];
    }
    else 
    {
        [super cardBackTouched:card];
    }
}

@end