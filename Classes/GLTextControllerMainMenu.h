#import "TextController.h"

@class AppController;
@class GLTexture;

@interface TextControllerMainMenu : TextController 
{
    AppController* _appController;
}

@property (nonatomic, assign) AppController* appController;

@end