#import "GameRenderer.h"
#import "NSArray+Circle.h"
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
#import "TextControllerCredits.h"
#import "GLLabel.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "GameControllerSP.h"
#import "GameControllerMP.h"
#import "CameraController.h"
#import "SoundController.h"
#import "DisplayContainer.h"
#import "MenuControllerMain.h"
#import "MenuLayerController.h"

@implementation GameController

@synthesize renderer = _renderer;
@synthesize game     = _game;

@dynamic myPeerId;
@dynamic player;

-(NSString*)myPeerId
{
    return @"";
}

-(PlayerModel*)player
{
    return [self.game.players objectForKey:self.myPeerId];
}

+(GameController*)loadWithRenderer:(GameRenderer*)renderer
{
    GameController* gameController = nil;
    
    if(!gameController) { gameController = [GameControllerSP loadWithRenderer:renderer]; }
    if(!gameController) { gameController = [GameControllerMP loadWithRenderer:renderer]; }
        
    return gameController;
}

-(id)init
{
    self = [super init];
    
	if(self)
	{
        _cardShortNames = [[NSDictionary dictionaryWithObjectsAndKeys:@"01", @"A",
                                                                      @"02", @"2",
                                                                      @"03", @"3",
                                                                      @"04", @"4",
                                                                      @"05", @"5",
                                                                      @"06", @"6",
                                                                      @"07", @"7",
                                                                      @"08", @"8",
                                                                      @"09", @"9",
                                                                      @"10", @"10",
                                                                      @"11", @"J",
                                                                      @"12", @"Q",
                                                                      @"13", @"K",
                                                                      @"14", @"A",
                                                                      nil] retain];
        
        _cardLongNames =  [[NSDictionary dictionaryWithObjectsAndKeys:@"01", @"Ace",
                                                                      @"02", @"2",
                                                                      @"03", @"3",
                                                                      @"04", @"4",
                                                                      @"05", @"5",
                                                                      @"06", @"6",
                                                                      @"07", @"7",
                                                                      @"08", @"8",
                                                                      @"09", @"9",
                                                                      @"10", @"10",
                                                                      @"11", @"Jack",
                                                                      @"12", @"Queen",
                                                                      @"13", @"King",
                                                                      @"14", @"Ace",
                                                                      nil] retain];
        
        _rankLevels = [[NSArray arrayWithObjects:@"00 00 00 00 00 00",
                                                 @"01 00 00 00 00",
                                                 @"01 11 00 00 00",
                                                 @"02 00 00 00",
                                                 @"03 00",
                                                 @"04 00",
                                                 @"05 00 00 00 00 00",
                                                 @"06 00 00",
                                                 @"07 00",
                                                 @"08 00",
                                                 @"09",
                                                 nil] retain];
        
        _rankNames = [[NSDictionary dictionaryWithObjectsAndKeys:@"High Card",       [_rankLevels objectAtIndex:0],
                                                                 @"Low Pair",        [_rankLevels objectAtIndex:1],
                                                                 @"Jacks or Better", [_rankLevels objectAtIndex:2],
                                                                 @"Two Pair",        [_rankLevels objectAtIndex:3],
                                                                 @"Three of a Kind", [_rankLevels objectAtIndex:4],
                                                                 @"Straight",        [_rankLevels objectAtIndex:5],
                                                                 @"Flush",           [_rankLevels objectAtIndex:6],
                                                                 @"Full House",      [_rankLevels objectAtIndex:7],
                                                                 @"Four of a Kind",  [_rankLevels objectAtIndex:8],
                                                                 @"Straight Flush",  [_rankLevels objectAtIndex:9],
                                                                 @"Royal Flush",     [_rankLevels objectAtIndex:10],
                                                                 nil] retain]; 
    }
	
	return self;
}

-(void)newDeckAndThen:(simpleBlock)work
{
    self.game.deck = [[NSMutableArray alloc] init];
    
    for(int suitCounter = 0; suitCounter <= 3; suitCounter++)
    {
        for(int numeralCounter = 1; numeralCounter <= 13; numeralCounter++)
        {
            CardModel* card = [[[CardModel alloc] init] autorelease]; 
            
            card.suit    = suitCounter; 
            card.numeral = numeralCounter;
            card.isHeld  = YES;
            
            [self.game.deck addObject:card];
        }   
    }
    
    [self.game.deck shuffle];
}

-(void)newGameAndThen:(simpleBlock)work
{

}

-(void)saveData
{    
    NSString* file = [NSString stringWithFormat:@"%@.json", NSStringFromClass([self class])];
    
    [[[self.game proxyForJson] JSONRepresentation] writeToDocument:file];
}

-(void)moveCardIndex:(int)initialIndex toIndex:(int)finalIndex
{
    CardModel* card = [[[self.player.cards objectAtIndex:initialIndex] retain] autorelease];
    
    [self.player.cards removeObject:card];
    
    [self.player.cards insertObject:card atIndex:finalIndex];
    
    //NSLog(@"%@", self.player.cards);
    
    [self saveData];
}

-(void)givePrize
{
    
}

-(void)updatePlayerAndThen:(simpleBlock)work
{
    [self updateChipsAndThen:work];
}

-(void)updateCardsAndThen:(simpleBlock)work
{
    if(self.player.cardsToRemove.count > 0)
    {
        CardModel* card = [self.player.cardsToRemove lastObject];

        [self.player.cards removeObject:card];
        [self.player.cardsToRemove removeObject:card];
        
        NSLog(@"Discarding Card '%@'", card);
        
        BOOL isLastCard = self.player.cardsToRemove.count == 0 && self.player.cardsToAdd.count == 0;
        
        [self.renderer.cardGroup updateCardsWithKeys:self.player.cardKeys held:self.player.heldKeys andThen:isLastCard ? work: nil];
        
        runAfterDelay(1, ^{ [self updateCardsAndThen:work]; });
    }
    else if(self.player.cardsToAdd.count > 0)
    {
        CardModel* card = [self.player.cardsToAdd objectAtIndex:0];
        
        [self.player.cards insertObject:card atIndex:0];
        [self.player.cardsToAdd removeObject:card];
        
        NSLog(@"Dealing Card '%@'", card);
        
        BOOL isLastCard = (self.player.cardsToRemove.count == 0) && (self.player.cardsToAdd.count == 0);
        
        [self.renderer.cardGroup updateCardsWithKeys:self.player.cardKeys held:self.player.heldKeys andThen:isLastCard ? work: nil];
        
        runAfterDelay(1, ^{ [self updateCardsAndThen:work]; });
    }
}

-(void)updateChipsAndThen:(simpleBlock)work;
{
    TextControllerCredits* textController = [self.renderer.textControllers objectForKey:@"credits"];
    
    textController.creditTotal = self.player.chipTotal;
    textController.betTotal    = self.player.betTotal;
    textController.showButton  = YES;

    [textController update];
    
    int offset;
    
    if(self.player.chipTotal <= 2000)
    { 
        offset = 0; 
    }
    else if(self.player.chipTotal <= 10000) 
    { 
        offset = 1; 
    }
    else if(self.player.chipTotal <= 20000) 
    { 
        offset = 2; 
    }
    else if(self.player.chipTotal <= 50000) 
    { 
        offset = 3; 
    }
    else  
    {
        offset = 4; 
    }

    [self.renderer.chipGroup.offset setValue:offset forTime:1 andThen:nil];

    GLChip* lastToFinish = nil;
    
    { GLChip* chip = [self.renderer.chipGroup.chips liveObjectForKey:@"1"    ]; chip.maxCount = [[self.player.chips objectForKey:@"1"    ] chipCount]; [chip.count setValue:[[self.player.chips objectForKey:@"1"    ] displayCount] withSpeed:6 andThen:nil]; if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } }
    { GLChip* chip = [self.renderer.chipGroup.chips liveObjectForKey:@"5"    ]; chip.maxCount = [[self.player.chips objectForKey:@"5"    ] chipCount]; [chip.count setValue:[[self.player.chips objectForKey:@"5"    ] displayCount] withSpeed:6 andThen:nil]; if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } }
    { GLChip* chip = [self.renderer.chipGroup.chips liveObjectForKey:@"10"   ]; chip.maxCount = [[self.player.chips objectForKey:@"10"   ] chipCount]; [chip.count setValue:[[self.player.chips objectForKey:@"10"   ] displayCount] withSpeed:6 andThen:nil]; if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } }
    { GLChip* chip = [self.renderer.chipGroup.chips liveObjectForKey:@"25"   ]; chip.maxCount = [[self.player.chips objectForKey:@"25"   ] chipCount]; [chip.count setValue:[[self.player.chips objectForKey:@"25"   ] displayCount] withSpeed:6 andThen:nil]; if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } }
    { GLChip* chip = [self.renderer.chipGroup.chips liveObjectForKey:@"100"  ]; chip.maxCount = [[self.player.chips objectForKey:@"100"  ] chipCount]; [chip.count setValue:[[self.player.chips objectForKey:@"100"  ] displayCount] withSpeed:6 andThen:nil]; if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } }    
    { GLChip* chip = [self.renderer.chipGroup.chips liveObjectForKey:@"500"  ]; chip.maxCount = [[self.player.chips objectForKey:@"500"  ] chipCount]; [chip.count setValue:[[self.player.chips objectForKey:@"500"  ] displayCount] withSpeed:6 andThen:nil]; if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } }    
    { GLChip* chip = [self.renderer.chipGroup.chips liveObjectForKey:@"1000" ]; chip.maxCount = [[self.player.chips objectForKey:@"1000" ] chipCount]; [chip.count setValue:[[self.player.chips objectForKey:@"1000" ] displayCount] withSpeed:6 andThen:nil]; if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } }    
    { GLChip* chip = [self.renderer.chipGroup.chips liveObjectForKey:@"2500" ]; chip.maxCount = [[self.player.chips objectForKey:@"2500" ] chipCount]; [chip.count setValue:[[self.player.chips objectForKey:@"2500" ] displayCount] withSpeed:6 andThen:nil]; if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } }    
    { GLChip* chip = [self.renderer.chipGroup.chips liveObjectForKey:@"10000"]; chip.maxCount = [[self.player.chips objectForKey:@"10000"] chipCount]; [chip.count setValue:[[self.player.chips objectForKey:@"10000"] displayCount] withSpeed:6 andThen:nil]; if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } }

    [lastToFinish.count register:work];
}

-(NSString*)scoreHand
{
    NSString* scoreHigh = [self scoreHand:self.player.cards high:YES];
    NSString* scoreLow  = [self scoreHand:self.player.cards high:NO];
        
    return [scoreLow compare:scoreHigh] > 0 ? scoreLow : scoreHigh;
}

-(NSString*)scoreHand:(NSArray*)hand high:(BOOL)high
{
    if(self.player.cards.count != 5) { return @""; }
                
    NSMutableArray* quadCards   = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray* tripleCards = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray* pairCards   = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray* singleCards = [[[NSMutableArray alloc] init] autorelease];
    
    int pairs   = 0;
    int triples = 0;
    int quads   = 0;
    
    NSArray* sortedHand = [hand sortedArrayUsingSelector:high ? @selector(numeralCompareHigh:) : @selector(numeralCompareLow:)];
    
    CardModel* card1 = [sortedHand objectAtIndex:0];
    CardModel* card2 = [sortedHand objectAtIndex:1];
    CardModel* card3 = [sortedHand objectAtIndex:2];
    CardModel* card4 = [sortedHand objectAtIndex:3];
    CardModel* card5 = [sortedHand objectAtIndex:4];
    
    [singleCards addObject:[NSNumber numberWithInt:high ? card1.numeralHigh : card1.numeralLow]];
    [singleCards addObject:[NSNumber numberWithInt:high ? card2.numeralHigh : card1.numeralLow]];
    [singleCards addObject:[NSNumber numberWithInt:high ? card3.numeralHigh : card1.numeralLow]];
    [singleCards addObject:[NSNumber numberWithInt:high ? card4.numeralHigh : card1.numeralLow]];
    [singleCards addObject:[NSNumber numberWithInt:high ? card5.numeralHigh : card1.numeralLow]];
    
    if(card1.numeralHigh == card2.numeralHigh) { pairs++;   [pairCards   addObject:[NSNumber numberWithInt:high ? card1.numeralHigh : card1.numeralLow]]; }
    if(card2.numeralHigh == card3.numeralHigh) { pairs++;   [pairCards   addObject:[NSNumber numberWithInt:high ? card2.numeralHigh : card1.numeralLow]]; }
    if(card3.numeralHigh == card4.numeralHigh) { pairs++;   [pairCards   addObject:[NSNumber numberWithInt:high ? card3.numeralHigh : card1.numeralLow]]; }
    if(card4.numeralHigh == card5.numeralHigh) { pairs++;   [pairCards   addObject:[NSNumber numberWithInt:high ? card4.numeralHigh : card1.numeralLow]]; }
    if(card1.numeralHigh == card3.numeralHigh) { triples++; [tripleCards addObject:[NSNumber numberWithInt:high ? card1.numeralHigh : card1.numeralLow]]; }
    if(card2.numeralHigh == card4.numeralHigh) { triples++; [tripleCards addObject:[NSNumber numberWithInt:high ? card2.numeralHigh : card1.numeralLow]]; }
    if(card3.numeralHigh == card5.numeralHigh) { triples++; [tripleCards addObject:[NSNumber numberWithInt:high ? card3.numeralHigh : card1.numeralLow]]; }
    if(card1.numeralHigh == card4.numeralHigh) { quads++;   [quadCards   addObject:[NSNumber numberWithInt:high ? card1.numeralHigh : card1.numeralLow]]; }
    if(card2.numeralHigh == card5.numeralHigh) { quads++;   [quadCards   addObject:[NSNumber numberWithInt:high ? card2.numeralHigh : card1.numeralLow]]; }

    [tripleCards removeObjectsInArray:quadCards];
    [pairCards   removeObjectsInArray:quadCards];
    [singleCards removeObjectsInArray:quadCards];
    [pairCards   removeObjectsInArray:tripleCards];
    [singleCards removeObjectsInArray:tripleCards];
    [singleCards removeObjectsInArray:pairCards];
    
    BOOL isFlush = card1.suit == card2.suit && card2.suit == card3.suit && card3.suit == card4.suit && card4.suit == card5.suit;
    
    BOOL isStraight = pairs == 0 && (high ? card5.numeralHigh : card5.numeralLow) == (high ? card1.numeralHigh : card1.numeralLow) + 4;
    
    if(isFlush && isStraight && (high ? card5.numeralHigh : card5.numeralLow) == 14)
    {   
        return @"09";
    }
    else if(isFlush && isStraight)                     
    { 
        return [NSString stringWithFormat:@"08 %02d", [[singleCards objectAtIndex:4] intValue]]; 
    }
    else if(pairs == 3 && triples == 2 && quads == 1)  
    { 
        return [NSString stringWithFormat:@"07 %02d", [[quadCards objectAtIndex:0] intValue]]; 
    }
    else if(pairs == 3 && triples == 1 && quads == 0)  
    { 
        return [NSString stringWithFormat:@"06 %02d %02d", [[tripleCards objectAtIndex:0] intValue], [[pairCards objectAtIndex:0] intValue]]; 
    }
    else if(isFlush)  
    { 
        return [NSString stringWithFormat:@"05 %02d %02d %02d %02d %02d", [[singleCards objectAtIndex:4] intValue], [[singleCards objectAtIndex:3] intValue], [[singleCards objectAtIndex:2] intValue], [[singleCards objectAtIndex:1] intValue], [[singleCards objectAtIndex:0] intValue]]; 
    }
    else if(isStraight)  
    { 
        return [NSString stringWithFormat:@"04 %02d", [[singleCards objectAtIndex:4] intValue]];
    }
    else if(pairs == 2 && triples == 1 && quads == 0)  
    { 
        return [NSString stringWithFormat:@"03 %02d", [[tripleCards objectAtIndex:0] intValue]]; 
    }
    else if(pairs == 2 && triples == 0 && quads == 0)  
    {
        return [NSString stringWithFormat:@"02 %02d %02d %02d", [[pairCards objectAtIndex:1] intValue], [[pairCards objectAtIndex:0] intValue], [[singleCards objectAtIndex:0] intValue]]; 
    }
    else if(pairs == 1 && triples == 0 && quads == 0)  
    { 
        return [NSString stringWithFormat:@"01 %02d %02d %02d %02d", [[pairCards objectAtIndex:0] intValue], [[singleCards objectAtIndex:2] intValue], [[singleCards objectAtIndex:1] intValue], [[singleCards objectAtIndex:0] intValue]]; 
    }

    return [NSString stringWithFormat:@"00 %02d %02d %02d %02d %02d", [[singleCards objectAtIndex:4] intValue], [[singleCards objectAtIndex:3] intValue], [[singleCards objectAtIndex:2] intValue], [[singleCards objectAtIndex:1] intValue], [[singleCards objectAtIndex:0] intValue]];
}

-(void)labelTouchedWithKey:(NSString*)key;
{
    // [label setObject:@"logo"             forKey:@"key"]; 
    // [label setObject:@"join_multiplayer" forKey:@"key"]; 
    // [label setObject:@"new_multiplayer"  forKey:@"key"]; 
    // [label setObject:@"new_game"         forKey:@"key"]; 

    if([key isEqualToString:@"logo"])
    {
        MenuControllerMain* menu = [MenuControllerMain withRenderer:self.renderer];
    
        [self.renderer.menuLayerController pushMenuLayer:menu forKey:[NSString stringWithFormat:@"%X", menu]];
    }
    else if([key isEqualToString:@"join_multiplayer"])
    {
        [self.renderer.menuLayerController cancelMenuLayer];
    }
    else if([key isEqualToString:@"new_multiplayer"])
    {
        [self.renderer.menuLayerController.currentLayer deleteMenuForKey:self.renderer.menuLayerController.currentLayer.currentKey]; 
    }
}

-(void)chipTouchedUpWithKey:(NSString*)key
{
    ChipModel* chipModel = [self.player.chips objectForKey:key];
    GLChip* chip = [self.renderer.chipGroup.chips liveObjectForKey:key];
    
    chipModel.betCount += 1;
    
    [self saveData];
    
    [self updatePlayerAndThen:nil];
    
    //TODO: refactor this into updateRendererAnimated
    [chip.count setValue:chipModel.displayCount withSpeed:3 andThen:nil];
}

-(void)chipTouchedDownWithKey:(NSString*)key
{
    ChipModel* chipModel = [self.player.chips objectForKey:key];
    GLChip* chip = [self.renderer.chipGroup.chips liveObjectForKey:key];
    
    chipModel.betCount -= 1;
    
    [self saveData];
    
    [self updatePlayerAndThen:nil];
    
    //TODO: refactor this into updateRendererAnimated
    [chip.count setValue:chipModel.displayCount withSpeed:3 andThen:nil];
}

-(void)cardFrontTouched:(int)card
{ 
//    CardModel* cardModel = [self.player.cards             objectAtIndex:card];
//    GLCard*    cardView  = [self.renderer.cardGroup.cards objectAtIndex:card];
//    
//    cardModel.isHeld = !cardModel.isHeld;
//    
//    //TODO: refactor this into updateRendererAnimated
//    cardView.isHeld = [AnimatedFloat withStartValue:cardView.isHeld.value endValue:cardModel.isHeld speed:4.0];
//    
//    [self saveData];
}

-(void)cardBackTouched:(int)card 
{
    //TODO: refactor this into updateRendererAnimated
    if(self.renderer.camera.pitchAngle.value < 60 && !self.renderer.camera.isAutomatic)
    {
        [self.renderer.camera.pitchAngle setValue:90 forTime:1.0 andThen:nil];
    }    
}

-(void)emptySpaceTouched 
{
    //TODO: refactor this into updateRendererAnimated
    if(!self.renderer.camera.isAutomatic)
    {
        if(self.renderer.camera.pitchAngle.value > 60)
        {
            [self.renderer.camera.pitchAngle setValue:0 forTime:1.0 andThen:nil];
        }
        else 
        {
            if(self.renderer.camera.menuVisible) 
            {
                [self.renderer.menuLayerController hideMenus];
            }
            else 
            {
                [self.renderer.menuLayerController showMenus];
            }
        }

    }
}

@end