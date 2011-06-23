#import "GLRenderer.h"
#import "NSArray+JBCommon.h"
#import "PlayerModel.h"
#import "CardModel.h"
#import "ScoreController.h"
#import "ChipModel.h"
#import "GameModel.h"
#import "GLChipGroup.h"
#import "GLChip.h"
#import "GLPlayer.h"
#import "GLCardGroup.h"
#import "GLCard.h"
#import "GLSplash.h"
#import "GLTextController.h"
#import "GLTextControllerCredits.h"
#import "GLText.h"
#import "AnimatedFloat.h"
#import "AnimatedVec3.h"
#import "GameController.h"
#import "GLCamera.h"
#import "SoundController.h"
#import "AppController.h"
#import "AppModel.h"
#import "DisplayContainer.h"
#import "GLMenuControllerMain.h"
#import "GLMenuLayerController.h"
#import "GLTextControllerStatusBar.h"

@implementation GameController

+(GameController*)gameController
{
    return [[[GameController alloc] init] autorelease];
}

+(NSString*)name
{
    return nil;
}

+(BOOL)isMultiplayer
{
    return NO;
}

@synthesize appController = _appController;

@dynamic renderer;
@dynamic gameModel;
@dynamic mainPlayer;

-(PlayerModel*)mainPlayer
{
    return [self.gameModel.players objectForKey:self.appController.mainPlayerKey];
}

-(GLRenderer*)renderer { return self.appController.renderer; }
-(GameModel*)gameModel { return self.appController.appModel.gameModel; }

-(void)newGame
{
    
}

-(void)moveCardIndex:(int)initialIndex toIndex:(int)finalIndex
{

}

-(void)labelTouchedWithKey:(NSString*)key
{

}

-(void)chipSwipedUpWithKey:(NSString*)key
{

}

-(void)chipSwipedDownWithKey:(NSString*)key
{

}

-(void)cardFrontTapped:(int)card
{ 

}

-(void)cardBackTapped:(int)card 
{

}

@end