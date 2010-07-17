#import "ChipModel.h"

#import "PlayerModel.h"

@implementation PlayerModel

@synthesize status = _status;
@synthesize cards = _cards;
@synthesize cardsToAdd = _cardsToAdd;
@synthesize cardsToRemove = _cardsToRemove;
@synthesize chips = _chips;

@dynamic chipTotal;
@dynamic betTotal;
@dynamic cardsMarked;
@dynamic cardKeys;
@dynamic heldKeys;

-(int)chipTotal 
{  
    return [[self.chips objectForKey:@"1"    ] chipCount] *     1
         + [[self.chips objectForKey:@"5"    ] chipCount] *     5
         + [[self.chips objectForKey:@"10"   ] chipCount] *    10
         + [[self.chips objectForKey:@"25"   ] chipCount] *    25
         + [[self.chips objectForKey:@"100"  ] chipCount] *   100
         + [[self.chips objectForKey:@"500"  ] chipCount] *   500
         + [[self.chips objectForKey:@"1000" ] chipCount] *  1000
         + [[self.chips objectForKey:@"2500" ] chipCount] *  2500
         + [[self.chips objectForKey:@"10000"] chipCount] * 10000;
}

-(void)setChipTotal:(int)total
{
    [[self.chips objectForKey:@"1"    ] setBetCount:0];
    [[self.chips objectForKey:@"5"    ] setBetCount:0];
    [[self.chips objectForKey:@"10"   ] setBetCount:0];
    [[self.chips objectForKey:@"25"   ] setBetCount:0];
    [[self.chips objectForKey:@"100"  ] setBetCount:0];
    [[self.chips objectForKey:@"500"  ] setBetCount:0];
    [[self.chips objectForKey:@"1000" ] setBetCount:0];
    [[self.chips objectForKey:@"2500" ] setBetCount:0];
    [[self.chips objectForKey:@"10000"] setBetCount:0];
    
    float chipTotal = total;
    
    int chipCount10000;
    int chipCount2500; 
    int chipCount1000; 
    int chipCount500;  
    int chipCount100;  
    int chipCount25;   
    int chipCount10;   
    int chipCount5;    
    int chipCount1;    
    
    if(chipTotal <= 2000) 
    { 
        //1 5 10 25 100
        
        chipCount10000 = 0;
        chipCount2500  = 0;
        chipCount1000  = 0;
        chipCount500   = 0; 
        chipCount100   = fminf(rint(chipTotal / 141), floor(chipTotal / 100)); chipTotal -= chipCount100 * 100;
        chipCount25    = fminf(rint(chipTotal /  41), floor(chipTotal /  25)); chipTotal -= chipCount25  *  25;
        chipCount10    = fminf(rint(chipTotal /  16), floor(chipTotal /  10)); chipTotal -= chipCount10  *  10;
        chipCount5     = fminf(rint(chipTotal /   6), floor(chipTotal /   5)); chipTotal -= chipCount5   *   5;
        chipCount1     = fminf(rint(chipTotal /   1), floor(chipTotal /   1));
    }
    else if(chipTotal <= 10000) 
    { 
        //5 10 25 100 500
        
        chipCount10000 = 0;
        chipCount2500  = 0;
        chipCount1000  = 0;
        chipCount500   = fminf(rint(chipTotal / 640), floor(chipTotal / 500)); chipTotal -= chipCount500 * 500; 
        chipCount100   = fminf(rint(chipTotal / 140), floor(chipTotal / 100)); chipTotal -= chipCount100 * 100;
        chipCount25    = fminf(rint(chipTotal /  40), floor(chipTotal /  25)); chipTotal -= chipCount25  *  25;
        chipCount10    = fminf(rint(chipTotal /  15), floor(chipTotal /  10)); chipTotal -= chipCount10  *  10;
        chipCount5     = fminf(rint(chipTotal /   5), floor(chipTotal /   5));
        chipCount1     = 0;
    }
    else if(chipTotal <= 20000) 
    { 
        //10 25 100 500 1000
        
        chipCount10000 = 0;
        chipCount2500  = 0;
        chipCount1000  = fminf(rint(chipTotal / 1635), floor(chipTotal / 1000)); chipTotal -= chipCount1000 * 1000;
        chipCount500   = fminf(rint(chipTotal /  635), floor(chipTotal /  500)); chipTotal -= chipCount500  *  500;
        chipCount100   = fminf(rint(chipTotal /  135), floor(chipTotal /  100)); chipTotal -= chipCount100  *  100;
        chipCount25    = fminf(rint(chipTotal /   35), floor(chipTotal /   25)); chipTotal -= chipCount25   *   25;
        chipCount10    = fminf(rint(chipTotal /   10), floor(chipTotal /   10)); 
        chipCount5     = 0;
        chipCount1     = 0;
    }
    else if(chipTotal <= 50000) 
    { 
        //25 100 500 1000 2500
        
        chipCount10000 = 0;
        chipCount2500  = fminf(rint(chipTotal / 3125), floor(chipTotal / 2500)); chipTotal -= chipCount2500 * 2500;
        chipCount1000  = fminf(rint(chipTotal / 1625), floor(chipTotal / 1000)); chipTotal -= chipCount1000 * 1000;
        chipCount500   = fminf(rint(chipTotal /  625), floor(chipTotal /  500)); chipTotal -= chipCount500  *  500; 
        chipCount100   = fminf(rint(chipTotal /  125), floor(chipTotal /  100)); chipTotal -= chipCount100  *  100;
        chipCount25    = fminf(rint(chipTotal /   25), floor(chipTotal /   25)); 
        chipCount10    = 0;
        chipCount5     = 0;
        chipCount1     = 0;
    }
    else
    { 
        //1 5 10 25 100
        
        chipCount10000 = fminf(rint(chipTotal / 14100), floor(chipTotal / 10000)); chipTotal -= chipCount10000 * 10000;
        chipCount2500  = fminf(rint(chipTotal /  4100), floor(chipTotal /  2500)); chipTotal -= chipCount2500  *  2500;
        chipCount1000  = fminf(rint(chipTotal /  1600), floor(chipTotal /  1000)); chipTotal -= chipCount1000  *  1000;
        chipCount500   = fminf(rint(chipTotal /   600), floor(chipTotal /   500)); chipTotal -= chipCount500   *   500; 
        chipCount100   = fminf(rint(chipTotal /   100), floor(chipTotal /   100)); 
        chipCount25    = 0;
        chipCount10    = 0;
        chipCount5     = 0;
        chipCount1     = 0;
    }
    
    [[self.chips objectForKey:@"1"    ] setChipCount:chipCount1];
    [[self.chips objectForKey:@"5"    ] setChipCount:chipCount5];
    [[self.chips objectForKey:@"10"   ] setChipCount:chipCount10];
    [[self.chips objectForKey:@"25"   ] setChipCount:chipCount25];
    [[self.chips objectForKey:@"100"  ] setChipCount:chipCount100];
    [[self.chips objectForKey:@"500"  ] setChipCount:chipCount500];
    [[self.chips objectForKey:@"1000" ] setChipCount:chipCount1000];
    [[self.chips objectForKey:@"2500" ] setChipCount:chipCount2500];
    [[self.chips objectForKey:@"10000"] setChipCount:chipCount10000];
}

-(int)betTotal 
{ 
    return [[self.chips objectForKey:@"1"    ] betCount] *     1
         + [[self.chips objectForKey:@"5"    ] betCount] *     5
         + [[self.chips objectForKey:@"10"   ] betCount] *    10
         + [[self.chips objectForKey:@"25"   ] betCount] *    25
         + [[self.chips objectForKey:@"100"  ] betCount] *   100
         + [[self.chips objectForKey:@"500"  ] betCount] *   500
         + [[self.chips objectForKey:@"1000" ] betCount] *  1000
         + [[self.chips objectForKey:@"2500" ] betCount] *  2500
         + [[self.chips objectForKey:@"10000"] betCount] * 10000;
}

-(int)cardsMarked
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

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.cards = [[[NSMutableArray alloc] init] autorelease];
        self.chips = [[[NSMutableDictionary alloc] init] autorelease];
        
        { ChipModel* chipModel = [[[ChipModel alloc] initWithKey:@"1"    ] autorelease]; [self.chips setObject:chipModel forKey:@"1"    ]; }
        { ChipModel* chipModel = [[[ChipModel alloc] initWithKey:@"5"    ] autorelease]; [self.chips setObject:chipModel forKey:@"5"    ]; }
        { ChipModel* chipModel = [[[ChipModel alloc] initWithKey:@"10"   ] autorelease]; [self.chips setObject:chipModel forKey:@"10"   ]; }
        { ChipModel* chipModel = [[[ChipModel alloc] initWithKey:@"25"   ] autorelease]; [self.chips setObject:chipModel forKey:@"25"   ]; }
        { ChipModel* chipModel = [[[ChipModel alloc] initWithKey:@"100"  ] autorelease]; [self.chips setObject:chipModel forKey:@"100"  ]; }
        { ChipModel* chipModel = [[[ChipModel alloc] initWithKey:@"500"  ] autorelease]; [self.chips setObject:chipModel forKey:@"500"  ]; }
        { ChipModel* chipModel = [[[ChipModel alloc] initWithKey:@"1000" ] autorelease]; [self.chips setObject:chipModel forKey:@"1000" ]; }
        { ChipModel* chipModel = [[[ChipModel alloc] initWithKey:@"2500" ] autorelease]; [self.chips setObject:chipModel forKey:@"2500" ]; }
        { ChipModel* chipModel = [[[ChipModel alloc] initWithKey:@"10000"] autorelease]; [self.chips setObject:chipModel forKey:@"10000"]; }
    }
    
    return self;
}

-(id)proxyForJson
{
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
        
    [dictionary setObject:self.cards forKey:@"cards"];
    [dictionary setObject:self.chips forKey:@"chips"];
    [dictionary setObject:[NSNumber numberWithInt:(int)self.status] forKey:@"status"];
    
    return dictionary;
}

+(id)withDictionary:(NSDictionary*)dictionary
{
    PlayerModel* player = [[[PlayerModel alloc] init] autorelease]; 
             
    NSNumber*           status = [dictionary objectForKey:@"status"];
    NSMutableArray*      cards = [dictionary objectForKey:@"cards"];
    NSMutableDictionary* chips = [dictionary objectForKey:@"chips"];
    
    player.status = (PlayerStatus)[status intValue];
    
    for(NSDictionary* card in cards) 
    { 
        [player.cards addObject:[CardModel withDictionary:card]]; 
    }
    
    for(NSString* key in chips) 
    { 
        [player.chips setObject:[ChipModel withDictionary:[chips objectForKey:key]] forKey:key];
    }
    
    return player;
}

@end