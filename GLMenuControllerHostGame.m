#import "GLMenuControllerHostGame.h"

@implementation GLMenuControllerHostGame

-(id)initWithRenderer:(GLRenderer*)renderer
{
    self = [super initWithRenderer:renderer];
    
    if(self) 
    {
        GLMenu* menu = [[[GLMenu alloc] init] autorelease]; 
        
        GLTextControllerClientList* textController = [[[GLTextControllerClientList alloc] init] autorelease];
        
        textController.owner = menu;
        textController.center = NO;
        textController.location = vec3Make(0, 0, -2.5);
        textController.renderer = self.renderer;
        
        [textController update];
        
        menu.textController = textController;
        
        menu.angleJitter = randomFloat(-10.0, 10.0);
        
        [self addMenu:menu forKey:@"clients"];
    }
    
    return self;
}

@end
