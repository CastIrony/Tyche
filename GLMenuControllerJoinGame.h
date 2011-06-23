#import "GLMenuController.h"  

@interface GLMenuControllerJoinGame : GLMenuController 

-(void)addServerWithPeerId:(NSString*)peerId name:(NSString*)name;

-(void)removeServerWithPeerId:(NSString*)peerId;

@end
