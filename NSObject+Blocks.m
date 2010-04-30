#import "NSObject+Blocks.h"

@implementation NSObject (BlocksAdditions)

-(void)my_callBlock
{
    void (^block)(void) = (id)self;
    
    block();
}

@end
