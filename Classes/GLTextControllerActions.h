#import "TextController.h"

@class GameControllerSP;

@interface TextControllerActions : TextController 
{
    GameControllerSP* _gameController;
}

@property (nonatomic, assign) GameControllerSP* gameController;

@end
