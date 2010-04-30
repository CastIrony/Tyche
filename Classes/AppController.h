//
//  OpenGLTestAppDelegate.h
//  OpenGLTest
//
//  Created by Joel Bernstein on 9/24/09.
//  Copyright Joel Bernstein 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameView;
@class GameRenderer;

@interface AppController : NSObject <UIApplicationDelegate> 
{   
    GameRenderer* _renderer;

    UIWindow* window;
    GameView* glView;
}

@property (nonatomic, assign) GameRenderer* renderer;

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet GameView* glView;

-(void)labelTouchedWithKey:(NSString*)key;

@end

