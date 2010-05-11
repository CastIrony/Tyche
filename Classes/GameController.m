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
#import "TextControllerCredits.h"
#import "GLLabel.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "GameControllerSP.h"
#import "GameControllerMP.h"
#import "CameraController.h"
#import "SoundController.h"

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
    //if(!gameController) { gameController = [GameControllerMP loadWithRenderer:renderer]; }
    
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

-(void)newHandAndThen:(simpleBlock)work
{
    //TODO: refactor this into updateRendererAnimated
    [self.renderer.cardGroup clearCards];
    
    [self.game.discard addObjectsFromArray:self.player.cards];
    
    [self.player.cards removeAllObjects];
    
    self.player.chipTotal -= 1;

    [self update]; 
    
    [self dealCards:[self.game getCards:5] andThen:work];
}

-(void)endGameAndThen:(simpleBlock)work
{
    self.game = nil;
    
    [self update];
}

-(void)endHandAndThen:(simpleBlock)work
{
    //TODO: refactor this into updateRendererAnimated
    [self.renderer unflipCardsAndThen:^{ [self discardCards:self.player.cards andThen:^{ [self update]; }]; }];
    
    self.player.status = PlayerStatusShouldReturnCards;
    
    //TODO: refactor this into updateRendererAnimated
    self.renderer.camera.status = CameraStatusNormal;
}

-(void)saveData
{    
    NSString* file = [NSString stringWithFormat:@"%@.json", NSStringFromClass([self class])];
    
    [[[self.game proxyForJson] JSONRepresentation] writeToDocument:file];
}


//TODO: make dealCards deal all cards at once, with delayed animation
-(void)dealCards:(NSMutableArray*)cards andThen:(simpleBlock)work
{
    [SoundController playSoundEffectForKey:@"carddeal"];
    
    if(cards.count > 0)
    {
        CardModel* card = [[[cards lastObject] retain] autorelease];
        
        [cards removeObject:card];
        
        card.isHeld = YES;
        
        [self.player.cards insertObject:card atIndex:0];
        
        [self.renderer.cardGroup dealCardWithSuit:card.suit numeral:card.numeral held:NO afterDelay:0.2 andThen:nil];
        
        runAfterDelay(TIMESCALE * 0.2, ^{ [self dealCards:cards andThen:work]; });
    }
    else 
    {
        [self saveData];
        
        if(work) { runLater(work); }
    }

}

//TODO: make discardCards discard all cards at once, with delayed animation
-(void)discardCards:(NSMutableArray*)cards andThen:(simpleBlock)work
{
    GLCard* lastCard = [cards lastObject];
    
    for(GLCard* card in cards)
    {
        if(card == lastCard)
        {
            
        }
        else 
        {
        
        }
    }
    
//    if(cards.count > 0)
//    {
//        CardModel* card = [[[cards objectAtIndex:0] retain] autorelease];
//        
//        [cards removeObjectAtIndex:0];
//        
//        [self.game.discard addObject:card];
//        [self.player.cards removeObject:card];
//        
//        [self.renderer.cardGroup discardCardWithSuit:card.suit numeral:card.numeral after];
//        
//        runAfterDelay(TIMESCALE * 0.2, ^{ [self discardCards:cards andThen:work]; });
//    }
//    else 
//    {
//        [self saveData];
//        
//        if(work) { runLater(work); }
//    }
}

-(void)drawCardsAndThen:(simpleBlock)work
{
    NSMutableArray* playerCards = self.player.cards;
    
    NSArray* filteredCards = [playerCards filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isHeld == NO"]];
    
    NSMutableArray* cardsToDiscard = [filteredCards mutableCopy]; 
    NSMutableArray* newCards = [self.game getCards:cardsToDiscard.count];
        
    [self discardCards:cardsToDiscard andThen:^{ [self dealCards:newCards andThen:work]; }];
}

-(void)moveCardIndex:(int)initialIndex toIndex:(int)finalIndex
{
    CardModel* card = [[[self.player.cards objectAtIndex:initialIndex] retain] autorelease];
    
    [self.player.cards removeObject:card];
    
    [self.player.cards insertObject:card atIndex:finalIndex];
    
    [self saveData];
}
//
//-(void)showHand
//{
//
//}

-(void)givePrize
{
    
}

-(void)update
{
    TextControllerCredits* textController = [self.renderer.textControllers objectForKey:@"credits"];
    
    textController.creditTotal = self.player.chipTotal;
    textController.betTotal    = self.player.betTotal;
    textController.showButton  = self.player.status == PlayerStatusDealtCards;

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

    if(self.renderer.animated)
    {        
        self.renderer.chipGroup.offset = [AnimatedFloat withStartValue:self.renderer.chipGroup.offset.value endValue:offset forTime:1];
        self.renderer.chipGroup.offset.curve = AnimationEaseInOut;

        //GLChip* lastToFinish = nil;
        
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"1"    ]; chip.maxCount = [[self.player.chips objectForKey:@"1"    ] chipCount]; chip.count = [AnimatedFloat withStartValue:chip.count.value endValue:[[self.player.chips objectForKey:@"1"    ] displayCount] speed:6]; /* if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } */ }
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"5"    ]; chip.maxCount = [[self.player.chips objectForKey:@"5"    ] chipCount]; chip.count = [AnimatedFloat withStartValue:chip.count.value endValue:[[self.player.chips objectForKey:@"5"    ] displayCount] speed:6]; /* if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } */ }
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"10"   ]; chip.maxCount = [[self.player.chips objectForKey:@"10"   ] chipCount]; chip.count = [AnimatedFloat withStartValue:chip.count.value endValue:[[self.player.chips objectForKey:@"10"   ] displayCount] speed:6]; /* if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } */ }
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"25"   ]; chip.maxCount = [[self.player.chips objectForKey:@"25"   ] chipCount]; chip.count = [AnimatedFloat withStartValue:chip.count.value endValue:[[self.player.chips objectForKey:@"25"   ] displayCount] speed:6]; /* if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } */ }
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"100"  ]; chip.maxCount = [[self.player.chips objectForKey:@"100"  ] chipCount]; chip.count = [AnimatedFloat withStartValue:chip.count.value endValue:[[self.player.chips objectForKey:@"100"  ] displayCount] speed:6]; /* if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } */ }    
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"500"  ]; chip.maxCount = [[self.player.chips objectForKey:@"500"  ] chipCount]; chip.count = [AnimatedFloat withStartValue:chip.count.value endValue:[[self.player.chips objectForKey:@"500"  ] displayCount] speed:6]; /* if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } */ }    
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"1000" ]; chip.maxCount = [[self.player.chips objectForKey:@"1000" ] chipCount]; chip.count = [AnimatedFloat withStartValue:chip.count.value endValue:[[self.player.chips objectForKey:@"1000" ] displayCount] speed:6]; /* if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } */ }    
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"2500" ]; chip.maxCount = [[self.player.chips objectForKey:@"2500" ] chipCount]; chip.count = [AnimatedFloat withStartValue:chip.count.value endValue:[[self.player.chips objectForKey:@"2500" ] displayCount] speed:6]; /* if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } */ }    
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"10000"]; chip.maxCount = [[self.player.chips objectForKey:@"10000"] chipCount]; chip.count = [AnimatedFloat withStartValue:chip.count.value endValue:[[self.player.chips objectForKey:@"10000"] displayCount] speed:6]; /* if(chip.count.endTime > lastToFinish.count.endTime) { lastToFinish = chip; } */ }
    }
    else 
    {
        self.renderer.chipGroup.offset = [AnimatedFloat withValue:offset];

        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"1"    ]; chip.maxCount = [[self.player.chips objectForKey:@"1"    ] chipCount]; chip.count.value = [[self.player.chips objectForKey:@"1"    ] displayCount]; }
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"5"    ]; chip.maxCount = [[self.player.chips objectForKey:@"5"    ] chipCount]; chip.count.value = [[self.player.chips objectForKey:@"5"    ] displayCount]; }
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"10"   ]; chip.maxCount = [[self.player.chips objectForKey:@"10"   ] chipCount]; chip.count.value = [[self.player.chips objectForKey:@"10"   ] displayCount]; }
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"25"   ]; chip.maxCount = [[self.player.chips objectForKey:@"25"   ] chipCount]; chip.count.value = [[self.player.chips objectForKey:@"25"   ] displayCount]; }
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"100"  ]; chip.maxCount = [[self.player.chips objectForKey:@"100"  ] chipCount]; chip.count.value = [[self.player.chips objectForKey:@"100"  ] displayCount]; }
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"500"  ]; chip.maxCount = [[self.player.chips objectForKey:@"500"  ] chipCount]; chip.count.value = [[self.player.chips objectForKey:@"500"  ] displayCount]; }
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"1000" ]; chip.maxCount = [[self.player.chips objectForKey:@"1000" ] chipCount]; chip.count.value = [[self.player.chips objectForKey:@"1000" ] displayCount]; }
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"2500" ]; chip.maxCount = [[self.player.chips objectForKey:@"2500" ] chipCount]; chip.count.value = [[self.player.chips objectForKey:@"2500" ] displayCount]; }
        { GLChip* chip = [self.renderer.chipGroup.chips objectForKey:@"10000"]; chip.maxCount = [[self.player.chips objectForKey:@"10000"] chipCount]; chip.count.value = [[self.player.chips objectForKey:@"10000"] displayCount]; }
    }
}

-(NSString*)scoreHand
{
    NSString* scoreHigh = [self scoreHandHigh];
    NSString* scoreLow  = [self scoreHandLow];
        
    return [scoreLow compare:scoreHigh] > 0 ? scoreLow : scoreHigh;
}

-(NSString*)scoreHandHigh
{
    if(self.player.cards.count != 5) { return @""; }
        
    NSArray* sortedHand = [self.player.cards sortedArrayUsingSelector:@selector(numeralCompareHigh:)];
    
    CardModel* card1 = [sortedHand objectAtIndex:0];
    CardModel* card2 = [sortedHand objectAtIndex:1];
    CardModel* card3 = [sortedHand objectAtIndex:2];
    CardModel* card4 = [sortedHand objectAtIndex:3];
    CardModel* card5 = [sortedHand objectAtIndex:4];
    
    NSMutableArray* quadCards   = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray* tripleCards = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray* pairCards   = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray* singleCards = [[[NSMutableArray alloc] init] autorelease];
    
    int pairs   = 0;
    int triples = 0;
    int quads   = 0;
    
    [singleCards addObject:[NSNumber numberWithInt:card1.numeralHigh]];
    [singleCards addObject:[NSNumber numberWithInt:card2.numeralHigh]];
    [singleCards addObject:[NSNumber numberWithInt:card3.numeralHigh]];
    [singleCards addObject:[NSNumber numberWithInt:card4.numeralHigh]];
    [singleCards addObject:[NSNumber numberWithInt:card5.numeralHigh]];
    
    if(card1.numeralHigh == card2.numeralHigh) { pairs++;   [pairCards   addObject:[NSNumber numberWithInt:card1.numeralHigh]]; }
    if(card2.numeralHigh == card3.numeralHigh) { pairs++;   [pairCards   addObject:[NSNumber numberWithInt:card2.numeralHigh]]; }
    if(card3.numeralHigh == card4.numeralHigh) { pairs++;   [pairCards   addObject:[NSNumber numberWithInt:card3.numeralHigh]]; }
    if(card4.numeralHigh == card5.numeralHigh) { pairs++;   [pairCards   addObject:[NSNumber numberWithInt:card4.numeralHigh]]; }
    if(card1.numeralHigh == card3.numeralHigh) { triples++; [tripleCards addObject:[NSNumber numberWithInt:card1.numeralHigh]]; }
    if(card2.numeralHigh == card4.numeralHigh) { triples++; [tripleCards addObject:[NSNumber numberWithInt:card2.numeralHigh]]; }
    if(card3.numeralHigh == card5.numeralHigh) { triples++; [tripleCards addObject:[NSNumber numberWithInt:card3.numeralHigh]]; }
    if(card1.numeralHigh == card4.numeralHigh) { quads++;   [quadCards   addObject:[NSNumber numberWithInt:card1.numeralHigh]]; }
    if(card2.numeralHigh == card5.numeralHigh) { quads++;   [quadCards   addObject:[NSNumber numberWithInt:card2.numeralHigh]]; }

    [tripleCards removeObjectsInArray:quadCards];
    [pairCards   removeObjectsInArray:quadCards];
    [singleCards removeObjectsInArray:quadCards];
    [pairCards   removeObjectsInArray:tripleCards];
    [singleCards removeObjectsInArray:tripleCards];
    [singleCards removeObjectsInArray:pairCards];
    
    BOOL isFlush = card1.suit == card2.suit && card2.suit == card3.suit && card3.suit == card4.suit && card4.suit == card5.suit;
    
    BOOL isStraight = pairs == 0 && card5.numeralHigh == card1.numeralHigh + 4;
    
    if(isFlush && isStraight && card5.numeralHigh == 14)
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

-(NSString*)scoreHandLow
{
    if(self.player.cards.count != 5) { return @""; }
        
    NSArray* sortedHand = [self.player.cards sortedArrayUsingSelector:@selector(numeralCompareLow:)];
    
    CardModel* card1 = [sortedHand objectAtIndex:0];
    CardModel* card2 = [sortedHand objectAtIndex:1];
    CardModel* card3 = [sortedHand objectAtIndex:2];
    CardModel* card4 = [sortedHand objectAtIndex:3];
    CardModel* card5 = [sortedHand objectAtIndex:4];
    
    NSMutableArray* quadCards   = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray* tripleCards = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray* pairCards   = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray* singleCards = [[[NSMutableArray alloc] init] autorelease];
    
    int pairs   = 0;
    int triples = 0;
    int quads   = 0;
    
    [singleCards addObject:[NSNumber numberWithInt:card1.numeralLow]];
    [singleCards addObject:[NSNumber numberWithInt:card2.numeralLow]];
    [singleCards addObject:[NSNumber numberWithInt:card3.numeralLow]];
    [singleCards addObject:[NSNumber numberWithInt:card4.numeralLow]];
    [singleCards addObject:[NSNumber numberWithInt:card5.numeralLow]];
    
    if(card1.numeralLow == card2.numeralLow) { pairs++;   [pairCards   addObject:[NSNumber numberWithInt:card1.numeralLow]]; }
    if(card2.numeralLow == card3.numeralLow) { pairs++;   [pairCards   addObject:[NSNumber numberWithInt:card2.numeralLow]]; }
    if(card3.numeralLow == card4.numeralLow) { pairs++;   [pairCards   addObject:[NSNumber numberWithInt:card3.numeralLow]]; }
    if(card4.numeralLow == card5.numeralLow) { pairs++;   [pairCards   addObject:[NSNumber numberWithInt:card4.numeralLow]]; }
    if(card1.numeralLow == card3.numeralLow) { triples++; [tripleCards addObject:[NSNumber numberWithInt:card1.numeralLow]]; }
    if(card2.numeralLow == card4.numeralLow) { triples++; [tripleCards addObject:[NSNumber numberWithInt:card2.numeralLow]]; }
    if(card3.numeralLow == card5.numeralLow) { triples++; [tripleCards addObject:[NSNumber numberWithInt:card3.numeralLow]]; }
    if(card1.numeralLow == card4.numeralLow) { quads++;   [quadCards   addObject:[NSNumber numberWithInt:card1.numeralLow]]; }
    if(card2.numeralLow == card5.numeralLow) { quads++;   [quadCards   addObject:[NSNumber numberWithInt:card2.numeralLow]]; }
    
    [tripleCards removeObjectsInArray:quadCards];
    [pairCards   removeObjectsInArray:quadCards];
    [singleCards removeObjectsInArray:quadCards];
    [pairCards   removeObjectsInArray:tripleCards];
    [singleCards removeObjectsInArray:tripleCards];
    [singleCards removeObjectsInArray:pairCards];
    
    BOOL isFlush = card1.suit == card2.suit && card2.suit == card3.suit && card3.suit == card4.suit && card4.suit == card5.suit;
    
    BOOL isStraight = pairs == 0 && card5.numeralLow == card1.numeralLow + 4;
    
    if(isFlush && isStraight)                     
    { 
        return [NSString stringWithFormat:@"08 %02d", [[singleCards objectAtIndex:4] intValue]]; 
    }
    if(pairs == 3 && triples == 2 && quads == 1)  
    { 
        return [NSString stringWithFormat:@"07 %02d", [[quadCards objectAtIndex:0] intValue]]; 
    }
    if(pairs == 3 && triples == 1 && quads == 0)  
    { 
        return [NSString stringWithFormat:@"06 %02d %02d", [[tripleCards objectAtIndex:0] intValue], [[pairCards objectAtIndex:0] intValue]]; 
    }
    if(isFlush)  
    { 
        return [NSString stringWithFormat:@"05 %02d %02d %02d %02d %02d", [[singleCards objectAtIndex:4] intValue], [[singleCards objectAtIndex:3] intValue], [[singleCards objectAtIndex:2] intValue], [[singleCards objectAtIndex:1] intValue], [[singleCards objectAtIndex:0] intValue]]; 
    }
    if(isStraight)  
    { 
        return [NSString stringWithFormat:@"04 %02d", [[singleCards objectAtIndex:4] intValue]];
    }
    if(pairs == 2 && triples == 1 && quads == 0)  
    { 
        return [NSString stringWithFormat:@"03 %02d", [[tripleCards objectAtIndex:0] intValue]]; 
    }
    if(pairs == 2 && triples == 0 && quads == 0)  
    {
        return [NSString stringWithFormat:@"02 %02d %02d %02d", [[pairCards objectAtIndex:1] intValue], [[pairCards objectAtIndex:0] intValue], [[singleCards objectAtIndex:0] intValue]]; 
    }
    if(pairs == 1 && triples == 0 && quads == 0)  
    { 
        return [NSString stringWithFormat:@"01 %02d %02d %02d %02d", [[pairCards objectAtIndex:0] intValue], [[singleCards objectAtIndex:2] intValue], [[singleCards objectAtIndex:1] intValue], [[singleCards objectAtIndex:0] intValue]]; 
    }
    
    return [NSString stringWithFormat:@"00 %02d %02d %02d %02d %02d", [[singleCards objectAtIndex:4] intValue], [[singleCards objectAtIndex:3] intValue], [[singleCards objectAtIndex:2] intValue], [[singleCards objectAtIndex:1] intValue], [[singleCards objectAtIndex:0] intValue]];
}

-(void)labelTouchedWithKey:(NSString*)key;
{
    
}

-(void)chipTouchedUpWithKey:(NSString*)key
{
    ChipModel* chipModel = [self.player.chips objectForKey:key];
    GLChip* chip = [self.renderer.chipGroup.chips objectForKey:key];
    
    chipModel.betCount += 1;
    
    [self saveData];
    
    [self update];
    
    //TODO: refactor this into updateRendererAnimated
    chip.count = [AnimatedFloat withStartValue:chip.count.value endValue:chipModel.displayCount speed:3];
}

-(void)chipTouchedDownWithKey:(NSString*)key
{
    ChipModel* chipModel = [self.player.chips objectForKey:key];
    GLChip* chip = [self.renderer.chipGroup.chips objectForKey:key];
    
    chipModel.betCount -= 1;
    
    [self saveData];
    
    [self update];
    
    //TODO: refactor this into updateRendererAnimated
    chip.count = [AnimatedFloat withStartValue:chip.count.value endValue:chipModel.displayCount speed:3];
}

-(void)cardFrontTouched:(int)card
{ 
    CardModel* cardModel = [self.player.cards             objectAtIndex:card];
    GLCard*    cardView  = [self.renderer.cardGroup.cards objectAtIndex:card];
    
    cardModel.isHeld = !cardModel.isHeld;
    
    //TODO: refactor this into updateRendererAnimated
    cardView.isHeld = [AnimatedFloat withStartValue:cardView.isHeld.value endValue:cardModel.isHeld speed:4.0];
    
    [self saveData];
}

-(void)cardBackTouched:(int)card 
{
    //TODO: refactor this into updateRendererAnimated
    if(self.renderer.camera.pitchAngle.value < 60 && !self.renderer.camera.isAutomatic)
    {
        self.renderer.camera.pitchAngle = [AnimatedFloat  withStartValue:self.renderer.camera.pitchAngle.value endValue:90 forTime:1.0];
        self.renderer.camera.pitchAngle.curve = AnimationEaseInOut;
    }    
}

-(void)emptySpaceTouched 
{
    //TODO: refactor this into updateRendererAnimated
    if(!self.renderer.camera.isAutomatic)
    {
        if(self.renderer.camera.pitchAngle.value > 60)
        {
            self.renderer.camera.pitchAngle = [AnimatedFloat withStartValue:self.renderer.camera.pitchAngle.value endValue:0 forTime:1.0];
            self.renderer.camera.pitchAngle.curve = AnimationEaseInOut;
        }
        else 
        {
            if(self.renderer.camera.menuVisible) 
            {
                [self.renderer hideMenus];
            }
            else 
            {
                [self.renderer showMenus];
            }
        }

    }
}

@end