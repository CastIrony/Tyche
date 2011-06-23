#import "GLMenu.h"
#import "GLTextControllerClientList.h"
#import "GLTextControllerMainMenu.h"
#import "GLTextControllerSettings.h"
#import "AnimatedVec3.h"
#import "GLCardGroup.h"

#import "GLMenuControllerMain.h"

@implementation GLMenuControllerMain

-(id)initWithRenderer:(GLRenderer*)renderer
{
    self = [super initWithRenderer:renderer];
    
    if(self) 
    {
        {
            GLMenu* menu = [[[GLMenu alloc] init] autorelease]; 
            
            GLTextControllerMainMenu* textController = [[[GLTextControllerMainMenu alloc] init] autorelease];
            
            textController.owner = menu;
            textController.center = NO;
            textController.location = vec3Make(0, 0, -2.5);
            textController.renderer = self.renderer;
            
            [textController update];
            
            menu.textController = textController;
            
            menu.angleJitter = randomFloat(-10.0, 10.0);
            
            [self addMenu:menu forKey:@"main"];
        }
        
        {
            GLMenu* menu = [[[GLMenu alloc] init] autorelease]; 
            
            GLTextControllerSettings* textController = [[[GLTextControllerSettings alloc] init] autorelease];
            
            textController.owner = menu;
            textController.center = NO;
            textController.location = vec3Make(0, 0, -2.5);
            textController.renderer = self.renderer;
            
            [textController update];
            
            menu.textController = textController;
            
            menu.angleJitter = randomFloat(-10.0, 10.0);
            
            [self addMenu:menu forKey:@"settings"];
        }
    }
    
    return self;
}

@end
