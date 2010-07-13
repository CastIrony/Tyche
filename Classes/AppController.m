//
//  OpenGLTestAppDelegate.m
//  OpenGLTest
//
//  Created by Joel Bernstein on 9/24/09.
//  Copyright Joel Bernstein 2009. All rights reserved.
//

#import "AppController.h"
#import "GameControllerSP.h"
#import "GameControllerMP.h"

#import "GameView.h"

@implementation AppController

@synthesize renderer = _renderer;

@synthesize window;
@synthesize glView;

-(void)applicationDidFinishLaunching:(UIApplication*)application
{
    //[@"GameControllerSP.json" deleteDocument];
    //[@"GameControllerMP.json" deleteDocument];
    
    glView.appController = self;
    
    [glView startAnimation];
}

-(void)applicationWillTerminate:(UIApplication*)application
{
	[glView stopAnimation];
}

-(void)applicationWillResignActive:(UIApplication*)application 
{

}

-(void)applicationDidBecomeActive:(UIApplication*)application 
{ 

}

-(void)labelTouchedWithKey:(NSString*)key
{
    if([key isEqualToString:@"new_game"])
    {
        self.renderer.gameController = [[[GameControllerSP alloc] init] autorelease];
        
        self.renderer.gameController.renderer = self.renderer;

        [self.renderer.gameController newGameAndThen:nil];
    }

    if([key isEqualToString:@"new_multiplayer"])
    {
        self.renderer.gameController = [[[GameControllerMP alloc] init] autorelease];
        
        self.renderer.gameController.renderer = self.renderer;
        
        [self.renderer.gameController newGameAndThen:nil];
    }
    
    if([key isEqualToString:@"join_multiplayer"])
    {
        self.renderer.gameController = [[[GameControllerMP alloc] init] autorelease];
        
        self.renderer.gameController.renderer = self.renderer;
        
        [self.renderer.gameController joinGameAndThen:nil];
    }
}

-(void)dealloc
{
	[window release];
	[glView release];
	
	[super dealloc];
}

@end