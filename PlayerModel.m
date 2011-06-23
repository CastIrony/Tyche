#import "ChipModel.h"
#import "CardModel.h"

#import "PlayerModel.h"

@implementation PlayerModel

+(PlayerModel*)playerModel
{
    return [[[PlayerModel alloc] init] autorelease];
}

@synthesize status = _status;
@synthesize cards = _cards;
@synthesize orderedCards = _orderedCards;
@synthesize chips = _chips;

@dynamic chipTotal;
@dynamic betTotal;
@dynamic numberOfCardsMarked;
@dynamic cardKeys;
@dynamic heldKeys;
@dynamic heldCards;

-(int)chipTotal 
{  
    return [[self.chips objectForKey:@"1"]     chipCount] *     1
         + [[self.chips objectForKey:@"5"]     chipCount] *     5
         + [[self.chips objectForKey:@"10"]    chipCount] *    10
         + [[self.chips objectForKey:@"50"]    chipCount] *    50
         + [[self.chips objectForKey:@"100"]   chipCount] *   100
         + [[self.chips objectForKey:@"500"]   chipCount] *   500
         + [[self.chips objectForKey:@"1000"]  chipCount] *  1000
         + [[self.chips objectForKey:@"5000"]  chipCount] *  5000
         + [[self.chips objectForKey:@"10000"] chipCount] * 10000;
}

-(void)setChipTotal:(int)total
{
    [[self.chips objectForKey:@"1"]     setBetCount:0];
    [[self.chips objectForKey:@"5"]     setBetCount:0];
    [[self.chips objectForKey:@"10"]    setBetCount:0];
    [[self.chips objectForKey:@"50"]    setBetCount:0];
    [[self.chips objectForKey:@"100"]   setBetCount:0];
    [[self.chips objectForKey:@"500"]   setBetCount:0];
    [[self.chips objectForKey:@"1000"]  setBetCount:0];
    [[self.chips objectForKey:@"5000"]  setBetCount:0];
    [[self.chips objectForKey:@"10000"] setBetCount:0];
    
    float chipTotal = total;
    
    int chipCount10000;
    int chipCount5000; 
    int chipCount1000; 
    int chipCount500;  
    int chipCount100;  
    int chipCount50;   
    int chipCount10;   
    int chipCount5;    
    int chipCount1;    
    
    if(chipTotal <= 2000) 
    { 
        //1 5 10 50 100
        
        chipCount10000 = 0;
        chipCount5000  = 0;
        chipCount1000  = 0;
        chipCount500   = 0; 
        chipCount100   = fminf(rint(chipTotal / 166), floor(chipTotal / 100)); chipTotal -= chipCount100 * 100;
        chipCount50    = fminf(rint(chipTotal /  66), floor(chipTotal /  50)); chipTotal -= chipCount50  *  50;
        chipCount10    = fminf(rint(chipTotal /  16), floor(chipTotal /  10)); chipTotal -= chipCount10  *  10;
        chipCount5     = fminf(rint(chipTotal /   6), floor(chipTotal /   5)); chipTotal -= chipCount5   *   5;
        chipCount1     = fminf(rint(chipTotal /   1), floor(chipTotal /   1));
    }
    else if(chipTotal <= 10000) 
    { 
        //5 10 50 100 500
        
        chipCount10000 = 0;
        chipCount5000  = 0;
        chipCount1000  = 0;
        chipCount500   = fminf(rint(chipTotal / 665), floor(chipTotal / 500)); chipTotal -= chipCount500 * 500; 
        chipCount100   = fminf(rint(chipTotal / 165), floor(chipTotal / 100)); chipTotal -= chipCount100 * 100;
        chipCount50    = fminf(rint(chipTotal /  65), floor(chipTotal /  50)); chipTotal -= chipCount50  *  50;
        chipCount10    = fminf(rint(chipTotal /  15), floor(chipTotal /  10)); chipTotal -= chipCount10  *  10;
        chipCount5     = fminf(rint(chipTotal /   5), floor(chipTotal /   5));
        chipCount1     = 0;
    }
    else if(chipTotal <= 20000) 
    { 
        //10 50 100 500 1000
        
        chipCount10000 = 0;
        chipCount5000  = 0;
        chipCount1000  = fminf(rint(chipTotal / 1660), floor(chipTotal / 1000)); chipTotal -= chipCount1000 * 1000;
        chipCount500   = fminf(rint(chipTotal /  660), floor(chipTotal /  500)); chipTotal -= chipCount500  *  500;
        chipCount100   = fminf(rint(chipTotal /  160), floor(chipTotal /  100)); chipTotal -= chipCount100  *  100;
        chipCount50    = fminf(rint(chipTotal /   60), floor(chipTotal /   50)); chipTotal -= chipCount50   *   50;
        chipCount10    = fminf(rint(chipTotal /   10), floor(chipTotal /   10)); 
        chipCount5     = 0;
        chipCount1     = 0;
    }
    else if(chipTotal <= 100000) 
    { 
        //50 100 500 1000 5000
        
        chipCount10000 = 0;
        chipCount5000  = fminf(rint(chipTotal / 6650), floor(chipTotal / 5000)); chipTotal -= chipCount5000 * 5000;
        chipCount1000  = fminf(rint(chipTotal / 1650), floor(chipTotal / 1000)); chipTotal -= chipCount1000 * 1000;
        chipCount500   = fminf(rint(chipTotal /  650), floor(chipTotal /  500)); chipTotal -= chipCount500  *  500; 
        chipCount100   = fminf(rint(chipTotal /  150), floor(chipTotal /  100)); chipTotal -= chipCount100  *  100;
        chipCount50    = fminf(rint(chipTotal /   50), floor(chipTotal /   50)); 
        chipCount10    = 0;
        chipCount5     = 0;
        chipCount1     = 0;
    }
    else
    { 
        //100 500 1000 5000 10000
        
        chipCount10000 = fminf(rint(chipTotal / 16600), floor(chipTotal / 10000)); chipTotal -= chipCount10000 * 10000;
        chipCount5000  = fminf(rint(chipTotal /  6600), floor(chipTotal /  5000)); chipTotal -= chipCount5000  *  5000;
        chipCount1000  = fminf(rint(chipTotal /  1600), floor(chipTotal /  1000)); chipTotal -= chipCount1000  *  1000;
        chipCount500   = fminf(rint(chipTotal /   600), floor(chipTotal /   500)); chipTotal -= chipCount500   *   500; 
        chipCount100   = fminf(rint(chipTotal /   100), floor(chipTotal /   100)); 
        chipCount50    = 0;
        chipCount10    = 0;
        chipCount5     = 0;
        chipCount1     = 0;
    }
    
    [[self.chips objectForKey:@"1"]     setChipCount:chipCount1];
    [[self.chips objectForKey:@"5"]     setChipCount:chipCount5];
    [[self.chips objectForKey:@"10"]    setChipCount:chipCount10];
    [[self.chips objectForKey:@"50"]    setChipCount:chipCount50];
    [[self.chips objectForKey:@"100"]   setChipCount:chipCount100];
    [[self.chips objectForKey:@"500"]   setChipCount:chipCount500];
    [[self.chips objectForKey:@"1000"]  setChipCount:chipCount1000];
    [[self.chips objectForKey:@"5000"]  setChipCount:chipCount5000];
    [[self.chips objectForKey:@"10000"] setChipCount:chipCount10000];
}

-(int)betTotal 
{ 
    return [[self.chips objectForKey:@"1"]     betCount] *     1
         + [[self.chips objectForKey:@"5"]     betCount] *     5
         + [[self.chips objectForKey:@"10"]    betCount] *    10
         + [[self.chips objectForKey:@"50"]    betCount] *    50
         + [[self.chips objectForKey:@"100"]   betCount] *   100
         + [[self.chips objectForKey:@"500"]   betCount] *   500
         + [[self.chips objectForKey:@"1000"]  betCount] *  1000
         + [[self.chips objectForKey:@"5000"]  betCount] *  5000
         + [[self.chips objectForKey:@"10000"] betCount] * 10000;
}

-(void)cancelBets
{
    [[self.chips objectForKey:@"1"]     setBetCount:0];
    [[self.chips objectForKey:@"5"]     setBetCount:0];
    [[self.chips objectForKey:@"10"]    setBetCount:0];
    [[self.chips objectForKey:@"50"]    setBetCount:0];
    [[self.chips objectForKey:@"100"]   setBetCount:0];
    [[self.chips objectForKey:@"500"]   setBetCount:0];
    [[self.chips objectForKey:@"1000"]  setBetCount:0];
    [[self.chips objectForKey:@"5000"]  setBetCount:0];
    [[self.chips objectForKey:@"10000"] setBetCount:0];
}

-(void)allIn
{
    [[self.chips objectForKey:@"1"]     setBetCount:[[self.chips objectForKey:@"1"]     chipCount]];
    [[self.chips objectForKey:@"5"]     setBetCount:[[self.chips objectForKey:@"5"]     chipCount]];
    [[self.chips objectForKey:@"10"]    setBetCount:[[self.chips objectForKey:@"10"]    chipCount]];
    [[self.chips objectForKey:@"50"]    setBetCount:[[self.chips objectForKey:@"50"]    chipCount]];
    [[self.chips objectForKey:@"100"]   setBetCount:[[self.chips objectForKey:@"100"]   chipCount]];
    [[self.chips objectForKey:@"500"]   setBetCount:[[self.chips objectForKey:@"500"]   chipCount]];
    [[self.chips objectForKey:@"1000"]  setBetCount:[[self.chips objectForKey:@"1000"]  chipCount]];
    [[self.chips objectForKey:@"5000"]  setBetCount:[[self.chips objectForKey:@"5000"]  chipCount]];
    [[self.chips objectForKey:@"10000"] setBetCount:[[self.chips objectForKey:@"10000"] chipCount]];
}

-(int)numberOfCardsMarked
{
    int marked = 0;
    
    for(CardModel* card in self.cards) 
    {
        if(!card.isHeld) { marked++; }
    }
    
    return marked;
}

-(NSArray*)cardKeys
{
    NSMutableArray* keys = [NSMutableArray array];
    
    for(CardModel* card in self.cards) 
    {
        [keys addObject:card.key];
    }
    
    return keys;
}

-(NSArray*)heldKeys
{
    NSMutableArray* keys = [NSMutableArray array];
    
    for(CardModel* card in self.cards) 
    {
        if(card.isHeld) { [keys addObject:card.key]; }
    }
    
    return keys;
}

-(NSArray*)heldCards
{
    NSMutableArray* cards = [NSMutableArray array];
    
    for(CardModel* card in self.cards) 
    {
        if(card.isHeld) { [cards addObject:card]; }
    }
    
    return cards;
}

-(NSArray*)drawnKeys
{
    NSMutableArray* keys = [NSMutableArray array];
    
    for(CardModel* card in self.cards) 
    {
        if(!card.isHeld) { [keys addObject:card.key]; }
    }
    
    return keys;
}

-(NSArray*)drawnCards
{
    NSMutableArray* cards = [NSMutableArray array];
    
    for(CardModel* card in self.cards) 
    {
        if(!card.isHeld) { [cards addObject:card]; }
    }
    
    return cards;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.cards = [NSMutableArray array];
        self.chips = [NSMutableDictionary dictionary];
        
        { ChipModel* chipModel = [ChipModel chipModel]; chipModel.key = @"1";     [self.chips setObject:chipModel forKey:@"1"];     }
        { ChipModel* chipModel = [ChipModel chipModel]; chipModel.key = @"5";     [self.chips setObject:chipModel forKey:@"5"];     }
        { ChipModel* chipModel = [ChipModel chipModel]; chipModel.key = @"10";    [self.chips setObject:chipModel forKey:@"10"];    }
        { ChipModel* chipModel = [ChipModel chipModel]; chipModel.key = @"50";    [self.chips setObject:chipModel forKey:@"50"];    }
        { ChipModel* chipModel = [ChipModel chipModel]; chipModel.key = @"100";   [self.chips setObject:chipModel forKey:@"100"];   }
        { ChipModel* chipModel = [ChipModel chipModel]; chipModel.key = @"500";   [self.chips setObject:chipModel forKey:@"500"];   }
        { ChipModel* chipModel = [ChipModel chipModel]; chipModel.key = @"1000";  [self.chips setObject:chipModel forKey:@"1000"];  }
        { ChipModel* chipModel = [ChipModel chipModel]; chipModel.key = @"5000";  [self.chips setObject:chipModel forKey:@"5000"];  }
        { ChipModel* chipModel = [ChipModel chipModel]; chipModel.key = @"10000"; [self.chips setObject:chipModel forKey:@"10000"]; }
    }
    
    return self;
}

-(NSDictionary*)saveToDictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

    [dictionary setObject:[NSNumber numberWithInt:(int)self.status] forKey:@"status"];
    [dictionary setObject:self.cards                                forKey:@"cards"];
    [dictionary setObject:self.orderedCards                         forKey:@"orderedCards"];
    [dictionary setObject:self.chips                                forKey:@"chips"];
                                
    return dictionary;
}

-(void)loadFromDictionary:(NSDictionary*)dictionary
{
    NSNumber*            status        = [dictionary objectForKey:@"status"];
    NSMutableArray*      cards         = [dictionary objectForKey:@"cards"];
    NSMutableArray*      orderedCards  = [dictionary objectForKey:@"orderedCards"];
    NSMutableDictionary* chips         = [dictionary objectForKey:@"chips"];
    
    self.status = [status intValue];
        
    for(NSDictionary* card in cards) 
    { 
        CardModel* cardModel = [CardModel cardModel];
        
        [cardModel loadFromDictionary:card];
        
        [self.cards addObject:cardModel]; 
    }

    for(NSDictionary* card in orderedCards) 
    { 
        CardModel* cardModel = [CardModel cardModel];

        [cardModel loadFromDictionary:card];

        [self.orderedCards addObject:cardModel]; 
    }
    
    for(NSString* key in chips) 
    { 
        ChipModel* chipModel = [ChipModel chipModel];
        
        [chipModel loadFromDictionary:[chips objectForKey:key]];

        [self.chips setObject:chipModel forKey:key];
    }
}

@end