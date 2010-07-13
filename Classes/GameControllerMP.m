#import "CardModel.h"
#import "GameModel.h"
#import "PlayerModel.h"
#import "GameRenderer.h"
#import "GLCardGroup.h"
#import "GLChipGroup.h"
#import "GLChip.h"
#import "ChipModel.h"
#import "AnimatedFloat.h"
#import "SessionController.h"
#import "MenuLayerController.h"

#import "GameControllerMP.h"

@implementation GameControllerMP

@synthesize sessionController = _sessionController;

-(NSString*)myPeerId
{
    return self.sessionController.session.peerID;
}

+(GameController*)loadWithRenderer:(GameRenderer*)renderer
{
    NSString* file = [NSString stringWithFormat:@"%@.json", NSStringFromClass(self)];
    
    NSString* archive = [NSString stringWithContentsOfDocument:file];
    
    if(archive)
    {
        GameController* gameController = [[[self alloc] init] autorelease];
        
        gameController.renderer = renderer;
        
        gameController.game = [GameModel withDictionary:[archive JSONValue]];
        
        GLfloat delay = 0;
        
        for(CardModel* card in gameController.player.cards.reverseObjectEnumerator) 
        {
            [gameController.renderer.cardGroup dealCardWithSuit:card.suit numeral:card.numeral held:card.isHeld afterDelay:delay += 0.2 andThen:nil];
        }
        
        [gameController update];
        
        [gameController.renderer.menuLayerController hideMenus];
                
        return gameController;
    }
    else 
    {
        return nil;
    }
}

-(void)joinGameAndThen:(simpleBlock)work
{
}

@end