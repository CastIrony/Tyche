#import "PotatoModel.h"

@implementation PotatoModel

-(id)proxyForJson
{
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    return dictionary;
}

+(id)withDictionary:(NSDictionary*)dictionary
{
    PotatoModel* potato = [[[PotatoModel alloc] init] autorelease];
    
    return potato;
}

@end
