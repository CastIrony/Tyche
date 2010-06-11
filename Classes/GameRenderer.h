//
//  GameRenderer.h
//  OpenGLTest
//
//  Created by Joel Bernstein on 9/24/09.
//  Copyright Joel Bernstein 2009. All rights reserved.
//

#import "Geometry.h"
#import "GameController.h"

@class AnimatedFloat;
@class AnimatedVector3D;
@class GLTable;
@class GLTexture;
@class AppController;
@class SoundController;
@class GameView;
@class GLCardGroup;
@class GLChipGroup;
@class MenuController;
@class MenuLayerController;
@class GLLabel;
@class GLSplash;
@class CameraController;

@interface GameRenderer : UIViewController <UIAccelerometerDelegate>
{
    EAGLContext* _context;
	
	GLint _backingWidth;
	GLint _backingHeight;
	
	GLuint _defaultFramebuffer;
    GLuint _colorRenderbuffer;
}

@property (nonatomic, assign) BOOL animated;

@property (nonatomic, retain) GameController*      gameController;
@property (nonatomic, retain) AppController*       appController;
@property (nonatomic, retain) SoundController*     soundController;

@property (nonatomic, retain) NSMutableDictionary* touchedObjects;
@property (nonatomic, retain) NSMutableDictionary* touchedLocations;
@property (nonatomic, retain) NSMutableDictionary* textControllers;

@property (nonatomic, retain) MenuLayerController* menuLayerController;
@property (nonatomic, retain) GLChipGroup*         chipGroup;
@property (nonatomic, retain) GLCardGroup*         cardGroup;
@property (nonatomic, retain) GLTable*             table;
@property (nonatomic, retain) GLSplash*            splash;

@property (nonatomic, retain) CameraController*    camera;

@property (nonatomic, retain) GLLabel*             creditLabel;
@property (nonatomic, retain) GLLabel*             betLabel;
@property (nonatomic, retain) NSMutableDictionary* betItems;
@property (nonatomic, retain) AnimatedFloat*       lightness;

-(BOOL)resizeFromLayer:(CAEAGLLayer*)layer;
-(void)load;
-(void)draw;

-(void)showMenus;
-(void)hideMenus;

-(void)flipCardsAndThen:(simpleBlock)work;
-(void)unflipCardsAndThen:(simpleBlock)work;

-(void)labelTouchedWithKey:(NSString*)key;

@end