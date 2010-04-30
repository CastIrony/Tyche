#import "Common.h"

#import "ChipModel.h"

@implementation ChipModel

@synthesize key = _key;

@dynamic chipCount;
@dynamic betCount;
@dynamic displayCount;

-(int)chipCount    { return _chipCount; }
-(int)betCount     { return _betCount; }
-(int)displayCount { return _chipCount - _betCount; }

-(void)setChipCount:(int)value { _chipCount = clipInt(value, 0, value); }
-(void)setBetCount: (int)value { _betCount  = clipInt(value, 0, _chipCount); }

-(id)initWithKey:(NSString*)key
{
    self = [super init];
    
    if(self)
    {
        self.key       = key;
        self.chipCount = 0;
        self.betCount  = 0;
    }
    
    return self;
}

-(id)proxyForJson
{
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dictionary setObject:self.key forKey:@"key"];
    
    [dictionary setObject:[NSNumber numberWithInt:self.chipCount] forKey:@"chipCount"];
    [dictionary setObject:[NSNumber numberWithInt:self.betCount]  forKey:@"betCount"];
    
    return dictionary;
}

+(id)withDictionary:(NSDictionary*)dictionary
{
    NSString* key = [dictionary objectForKey:@"key"];
    
    ChipModel* chip = [[[ChipModel alloc] initWithKey:key] autorelease];

    chip.chipCount = [[dictionary objectForKey:@"chipCount"] intValue];
    chip.betCount  = [[dictionary objectForKey:@"betCount"]  intValue];
    
    return chip;
}

@end
