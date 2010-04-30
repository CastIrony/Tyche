#import "TextController.h"

@class AppController;
@class Texture2D;

@interface TextControllerMainMenu : TextController 
{
    AppController* _appController;
    Texture2D*     _textureLogo;
}

@property (nonatomic, assign) AppController* appController;
@property (nonatomic, retain) Texture2D*     textureLogo;

@end