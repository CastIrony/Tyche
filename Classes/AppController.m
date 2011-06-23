
//  AppController.m
//  Studly
//
//  Created by Joel Bernstein on 9/24/09.
//  Copyright Joel Bernstein 2009. All rights reserved.

#import "GameControllerSP5D.h"
#import "GameControllerMP7S.h"

#import "GLView.h"
#import "AppModel.h"
#import "GameModel.h"
#import "AppController.h"

@implementation AppController

@synthesize window         = _window;
@synthesize displayLink    = _displayLink;
@synthesize renderer       = _renderer;
@synthesize gameController = _gameController;
@synthesize gameTypes      = _gameTypes;
@synthesize appModel       = _appModel;
@synthesize mainPlayerKey  = _mainPlayerKey;
-(id)init
{
    self = [super init];
    
	if(self)
	{
        self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
        self.renderer = [[[GLRenderer alloc] init] autorelease];
        
        self.appModel = [AppModel appModel];
        
        [self.appModel load];
        
        self.renderer.appController = self;
                
        if([self.gameTypes containsObject:self.appModel.gameModel.type])
        {
            self.gameController = [[[NSClassFromString(self.appModel.gameModel.type) alloc] init] autorelease];
            
            self.gameController.appController = self;
        }
        
        self.window.backgroundColor = [UIColor blueColor];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self.renderer selector:@selector(draw)];
        
        self.displayLink.frameInterval = 2;
        
        [self startAnimation];
        
        self.window.rootViewController = self.renderer;

        [self.window makeKeyAndVisible];
    }
	
	return self;
}


-(void)applicationDidFinishLaunching:(UIApplication*)application
{
}

-(void)applicationDidBecomeActive:(UIApplication*)application 
{ 
}

-(void)applicationWillTerminate:(UIApplication*)application
{
}

-(void)applicationWillResignActive:(UIApplication*)application 
{
}

-(void)startAnimation
{
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)stopAnimation
{
    [self.displayLink invalidate];
}

-(void)labelTouchedWithKey:(NSString*)key
{
    if([key isEqualToString:@"new_game"] || [key isEqualToString:@"gameOverNewGame"])
    {
        self.gameController = [GameControllerSP5D gameController];
     
        self.gameController.appController = self;

        self.appModel.gameModel = [GameModel gameModel];
        
        self.mainPlayerKey = @"foobar";
        
        [self.gameController newGame];
    }

    if([key isEqualToString:@"new_multiplayer"])
    {
//        self.renderer.gameController = [[[GameControllerMP7S alloc] init] autorelease];
//        
//        self.renderer.gameController.renderer = self.renderer;
//        
//        [self.renderer.gameController newGame];
    }
}

-(void)dealloc
{
	self.window   = nil;
	self.renderer = nil;
    self.appModel = nil;
        
	[super dealloc];
}

@end