#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameRenderer.h"

@interface GameView : UIView
{    
//	AppController* appController;
    GameRenderer* renderer;
	
//	BOOL animating;
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
