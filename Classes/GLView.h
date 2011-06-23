#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameRenderer.h"

@interface GameView : UIView
{    
    GameRenderer* renderer;
	
	BOOL displayLinkSupported;
	NSInteger animationFrameInterval;
	id displayLink;
}

@property (nonatomic, assign) AppController* appController;
@property (readonly, nonatomic/*, getter=isMeshAnimating*/) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (void) startAnimation;
- (void) stopAnimation;

@end
