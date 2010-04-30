#import "GLMenu.h"
#import "TextControllerServerInfo.h"

#import "MenuControllerJoinGame.h"

@implementation MenuControllerJoinGame

-(void)addServerWithPeerId:(NSString*)peerId name:(NSString*)name
{
    GLMenu* menu  = [[[GLMenu alloc] init] autorelease]; 
    
    TextControllerServerInfo* textController = [[[TextControllerServerInfo alloc] init] autorelease];
    
    textController.owner = menu;
    textController.center = NO;
    textController.opacity = 1;
    textController.location = Vector3DMake(0, 0, -2.5);
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
