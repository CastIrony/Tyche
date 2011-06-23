//
//  AppController.h
//  Studly
//
//  Created by Joel Bernstein on 9/24/09.
//  Copyright Joel Bernstein 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLView;
@class GLRenderer;
@class GameController;
@class AppModel;

@interface AppController : NSObject <UIApplicationDelegate> 

@property (nonatomic, retain) UIWindow*       window;
@property (nonatomic, retain) GLRenderer*     renderer;
@property (nonatomic, retain) CADisplayLink*  displayLink;
@property (nonatomic, retain) GameController* gameController;
@property (nonatomic, retain) NSMutableSet*   gameTypes;
@property (nonatomic, retain) AppModel*       appModel;
@property (nonatomic, copy)   NSString*       mainPlayerKey;

-(void)startAnimation;
-(void)stopAnimation;

-(void)labelTouchedWithKey:(NSString*)key;

@end

