#import "MenuControllerHostGame.h"

@implementation MenuControllerHostGame

-(id)initWithRenderer:(GameRenderer*)renderer
{
    self = [super initWithRenderer:renderer];
    
    if(self) 
    {
        GLMenu* menu = [[[GLMenu alloc] init] autorelease]; 
        
        TextControllerClientList* textController = [[[TextControllerClientList alloc] init] autorelease];
        
        textController.owner = menu;
        textController.center = NO;
        textController.opacity = 1;
        textController.location = Vector3DMake(0, 0, -2.5);
        textController.renderer = self.renderer;
        
        [textController update];
        
        menu.textController = textController;
        
        menu.angleJitter = randomFloat(-10.0, 10.0);
        
        [self addMenu:menu forKey:@"clients"];
    }
    
    return self;
}

@end
