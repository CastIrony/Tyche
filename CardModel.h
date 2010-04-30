@interface CardModel : NSObject 
{
    int  _suit;
    int  _numeral;
    BOOL _isHeld;
}

@property (nonatomic, assign) int  suit;
@property (nonatomic, assign) int  numeral;
@property (nonatomic, readonly) int  numeralHigh;
@property (nonatomic, readonly) int  numeralLow;
@property (nonatomic, assign) BOOL isHeld;

-(id)initWithSuit:(int)suit numeral:(int)numeral held:(BOOL)isHeld;

-(id)proxyForJson;
+(id)withDictionary:(NSDictionary*)dictionary;

-(NSComparisonResult)numeralCompareHigh:(CardModel*)otherCard;
-(NSComparisonResult)numeralCompareLow:(CardModel*)otherCard;

@end
