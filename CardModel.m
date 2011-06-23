#import "CardModel.h"

@implementation CardModel

+(CardModel*)cardModel
{
    return [[[CardModel alloc] init] autorelease];
}

@synthesize suit       = _suit;
@synthesize numeral = _numeral;
@synthesize isHeld     = _isHeld;

@dynamic numeralHigh;
@dynamic numeralLow;
@dynamic key;

-(int)numeralHigh
{
    return _numeral == 1 ? 14 : _numeral;
}

-(int)numeralLow
{
    return _numeral;
}

-(NSString*)key
{    
    return [NSString stringWithFormat:@"%d-%d", self.suit, self.numeral];
}

-(NSDictionary*)saveToDictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:[NSNumber numberWithInt:self.suit]    forKey:@"suit"];
    [dictionary setObject:[NSNumber numberWithInt:self.numeral] forKey:@"numeral"];
    [dictionary setObject:[NSNumber numberWithBool:self.isHeld] forKey:@"isHeld"];
    
    return dictionary;
}

-(void)loadFromDictionary:(NSDictionary*)dictionary
{
    self.suit    = [[dictionary objectForKey:@"suit"]    intValue];
    self.numeral = [[dictionary objectForKey:@"numeral"] intValue];
    self.isHeld  = [[dictionary objectForKey:@"isHeld"]  boolValue];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"Card with suit:%d numeral:%d", self.suit, self.numeral];
}

-(NSComparisonResult)numeralCompareHigh:(CardModel*)otherCard
{
    NSComparisonResult numeralResult = [[NSNumber numberWithInt:self.numeralHigh] compare:[NSNumber numberWithInt:otherCard.numeralHigh]];
    
    return numeralResult;
}

-(NSComparisonResult)numeralCompareLow:(CardModel*)otherCard
{
    NSComparisonResult numeralResult = [[NSNumber numberWithInt:self.numeralLow] compare:[NSNumber numberWithInt:otherCard.numeralLow]];
    
    return numeralResult;
}

-(NSComparisonResult)compareHigh:(CardModel*)otherCard
{
    NSComparisonResult numeralResult = [[NSNumber numberWithInt:self.numeralHigh] compare:[NSNumber numberWithInt:otherCard.numeralHigh]];
    
    if(numeralResult == NSOrderedSame)
    {
        return [[NSNumber numberWithInt:self.suit] compare:[NSNumber numberWithInt:otherCard.suit]];
    }
       
    return numeralResult;
}

-(NSComparisonResult)compareLow:(CardModel*)otherCard
{
    NSComparisonResult numeralResult = [[NSNumber numberWithInt:self.numeralLow] compare:[NSNumber numberWithInt:otherCard.numeralLow]];
    
    if(numeralResult == NSOrderedSame)
    {
        return [[NSNumber numberWithInt:self.suit] compare:[NSNumber numberWithInt:otherCard.suit]];
    }
    
    return numeralResult;
}

@end