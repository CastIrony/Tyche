#import "MenuController.h"  

@interface MenuControllerJoinGame : MenuController 
{

}

-(void)addServerWithPeerId:(NSString*)peerId name:(NSString*)name;

-(void)removeServerWithPeerId:(NSString*)peerId;

@end
