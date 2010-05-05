#import "TextController.h"

@class AppController;
@class GLTexture;

@interface TextControllerMainMenu : TextController 
{
    AppController* _appController;
    GLTexture*     _textureLogo;
}

@property (nonatomic, assign) AppController* appController;
@property (nonatomic, retain) GLTexture*     textureLogo;

@end