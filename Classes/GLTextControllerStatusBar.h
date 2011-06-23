#import "TextController.h"

@interface TextControllerStatusBar : TextController 
{
    GameController* _gameController;
    NSString* _text;
}

@property (nonatomic, assign) GameController* gameController;
@property (nonatomic, retain) NSString* text;

@end
