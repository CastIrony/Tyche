#import "TextController.h"

@interface TextControllerCredits : TextController 
{
    GameController* _gameController;
    
    int  _creditTotal;
    int  _betTotal;
    BOOL _showButton;
}

@property (nonatomic, assign) GameController* gameController;
@property (nonatomic, assign) int creditTotal;
@property (nonatomic, assign) int betTotal;
@property (nonatomic, assign) BOOL showButton;

@end
