#import "Common.h"

#import "ChipModel.h"

@implementation ChipModel

+(ChipModel*)chipModel
{
    return [[[ChipModel alloc] init] autorelease];
}

@synthesize key       = _key;
@synthesize chipCount = _chipCount;
@synthesize betCount  = _betCount;
@dynamic displayCount;

-(void)setChipCount:(int)value { _chipCount = clipInt(value, 0, value); }
-(void)setBetCount: (int)value { _betCount  = clipInt(value, 0, _chipCount); }

-(int)displayCount { return _chipCount - _betCount; }

-(NSDictionary*)saveToDictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:self.key                                forKey:@"key"];
    [dictionary setObject:[NSNumber numberWithInt:self.chipCount] forKey:@"chipCount"];
    [dictionary setObject:[NSNumber numberWithInt:self.betCount]  forKey:@"betCount"];
    
    return dictionary;
}

-(void)loadFromDictionary:(NSDictionary*)dictionary
{
    self.key       =  [dictionary objectForKey:@"key"];
    self.chipCount = [[dictionary objectForKey:@"chipCount"] intValue];
    self.betCount  = [[dictionary objectForKey:@"betCount"]  intValue];
}

@end
