//
//  EAGLView.m
//  OpenGLTest
//
//  Created by Joel Bernstein on 9/24/09.
//  Copyright Joel Bernstein 2009. All rights reserved.
//

#import "GameView.h"
#import "GameControllerSP.h"
#import "AppController.h"
#import "GameRenderer.h"
#import "GLSplash.h"
#import "AnimatedFloat.h"

@implementation GameView

@synthesize appController;
@synthesize animating;
@dynamic animationFrameInterval;

// You must implement this method
+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id) initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
	{
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, 
                                                                                  /*kEAGLColorFormatRGBA8*/kEAGLColorFormatRGB565,           kEAGLDrawablePropertyColorFormat, 
                                                                                  nil];
		
        renderer = [[GameRenderer alloc] init];
        
        renderer.view = self;
                
		animating = FALSE;
		displayLinkSupported = FALSE;
		animationFrameInterval = 2;
		displayLink = nil;
		
		// A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
		// class is used as fallback when it isn't available.
		NSString *reqSysVer = @"3.1";
		NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
		if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
			displayLinkSupported = TRUE;
        
        UIScreen* mainscr = [UIScreen mainScreen];
        
        if ([UIScreen mainScreen].currentMode.size.width == 640) { self.contentScaleFactor = 2.0; }
    }
	
    return self;
}

-(void)layoutSubviews
{
    renderer.appController = self.appController;
    renderer.appController.renderer = renderer;
    
    [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
        
    [renderer draw];
}

-(NSInteger)animationFrameInterval
{
	return animationFrameInterval;
}

-(void)setAnimationFrameInterval:(NSInteger)frameInterval
{
	if(frameInterval >= 1)
	{
		animationFrameInterval = frameInterval;
		
		if(animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

-(void)startAnimation
{
	if(!animating)
	{
		displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:renderer selector:@selector(draw)];
		
        [displayLink setFrameInterval:animationFrameInterval];
		
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		
		animating = TRUE;
	}
}

-(void)stopAnimation
{
	if(animating)
	{
        [displayLink invalidate];
        displayLink = nil;
		
		animating = FALSE;
	}
}

-(void)dealloc
{
    [renderer release];
	
    [super dealloc];
}

@end
