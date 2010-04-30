@interface ChipModel : NSObject 
{
    NSString* _key;
    
    int _chipCount;
    int _betCount;
}

@property (nonatomic, retain)   NSString* key;
@property (nonatomic, assign)   int       chipCount;
@property (nonatomic, assign)   int       betCount;
@property (nonatomic, readonly) int       displayCount;

-(id)initWithKey:(NSString*)key;
-(id)proxyForJson;
+(id)withDictionary:(NSDictionary*)dictionary;

@end
