#import "GLMenu.h"
#import "TextControllerClientList.h"
#import "TextControllerMainMenu.h"
#import "TextControllerSettings.h"
#import "AnimatedVector3D.h"
#import "GLCardGroup.h"

#import "MenuControllerMain.h"

@implementation MenuControllerMain

-(id)initWithRenderer:(GameRenderer*)renderer
{
    self = [super initWithRenderer:renderer];
    
    if(self) 
    {
        {
            GLMenu* menu = [[[GLMenu alloc] init] autorelease]; 
            
            TextControllerMainMenu* textController = [[[TextControllerMainMenu alloc] init] autorelease];
            
            textController.owner = menu;
            textController.center = NO;
            textController.opacity = 1;
            textController.location = Vector3DMake(0, 0, -2.5);
            textController.renderer = self.renderer;
            
            [textController update];
            
            menu.textController = textController;
            
            menu.angleJitter = randomFloat(-10.0, 10.0);
            
            [self addMenu:menu forKey:@"main"];
        }
        
        {
            GLMenu* menu = [[[GLMenu alloc] init] autorelease]; 
            
            TextControllerSettings* textController = [[[TextControllerSettings alloc] init] autorelease];
            
            textController.owner = menu;
            textController.center = NO;
            textController.opacity = 1;
            textController.location = Vector3DMake(0, 0, -2.5);
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
