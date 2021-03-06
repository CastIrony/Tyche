#import "GLMenu.h"
#import "GLTextControllerServerInfo.h"

#import "GLMenuControllerJoinGame.h"

@implementation GLMenuControllerJoinGame

-(void)addServerWithPeerId:(NSString*)peerId name:(NSString*)name
{
    GLMenu* menu  = [[[GLMenu alloc] init] autorelease]; 
    
    GLTextControllerServerInfo* textController = [[[GLTextControllerServerInfo alloc] init] autorelease];
    
    textController.owner = menu;
    textController.center = NO;
    textController.location = vec3Make(0, 0, -2.5);
    textController.serverName = [name substringFromIndex:1];
    textController.serverIcon = [name substringToIndex:1];
    
    textController.renderer = self.renderer;
    
    [textController update];
    
    menu.textController = textController;
            
    menu.angleJitter = randomFloat(-10.0, 10.0);
        
    [self addMenu:menu forKey:peerId];    
}

-(void)removeServerWithPeerId:(NSString*)peerId
{
    [self deleteMenuForKey:peerId];
}

@end
