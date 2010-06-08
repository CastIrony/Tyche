//
//  EAGLView.h
//  OpenGLTest
//
//  Created by Joel Bernstein on 9/24/09.
//  Copyright Joel Bernstein 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameRenderer.h"

// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
// The view content is basically an EAGL surface you render your OpenGL scene into.
// Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.

@interface GameView : UIView
{    
@private
	AppController* appController;
    GameRenderer* renderer;
	
	BOOL animating;
	BOOL displayLinkSupported;
	NSInteger animationFrameInterval;
	id displayLink;
}

@property (nonatomic, assign) AppController* appController;
@property (readonly, nonatomic, getter=isMeshAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (void) startAnimation;
- (void) stopAnimation;

@end
