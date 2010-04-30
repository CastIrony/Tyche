#import "CardModel.h"

@implementation CardModel

@synthesize suit       = _suit;
@synthesize numeral = _numeral;
@synthesize isHeld     = _isHeld;

@dynamic numeralHigh;
@dynamic numeralLow;

-(int)numeralHigh
{
    return _numeral == 1 ? 14 : _numeral;
}

-(int)numeralLow
{
    return _numeral;
}

-(id)initWithSuit:(int)suit numeral:(int)numeral held:(BOOL)isHeld
{
    self = [super init];
    
    if(self)
    {
        self.suit    = suit;
        self.numeral = numeral;
        self.isHeld  = isHeld;
    }
    
    return self;
}

-(id)proxyForJson
{
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dictionary setObject:[NSNumber numberWithInt:self.suit]    forKey:@"suit"];
    [dictionary setObject:[NSNumber numberWithInt:self.numeral] forKey:@"numeral"];
    [dictionary setObject:[NSNumber numberWithBool:self.isHeld] forKey:@"isHeld"];
    
    return dictionary;
}

+(id)withDictionary:(NSDictionary*)dictionary
{
    int suit    = [[dictionary objectForKey:@"suit"]    intValue];
    int numeral = [[dictionary objectForKey:@"numeral"] intValue];
    int isHeld  = [[dictionary objectForKey:@"isHeld"]  boolValue];
    
    CardModel* card = [[[CardModel alloc] initWithSuit:suit numeral:numeral held:isHeld] autorelease];
    
    return card;
}

-(NSComparisonResult)numeralCompareHigh:(CardModel*)otherCard
{
    return [[NSNumber numberWithInt:self.numeralHigh] compare:[NSNumber numberWithInt:otherCard.numeralHigh]];
}

-(NSComparisonResult)numeralCompareLow:(CardModel*)otherCard
{
    return [[NSNumber numberWithInt:self.numeralLow] compare:[NSNumber numberWithInt:otherCard.numeralLow]];
}

@end