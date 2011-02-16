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

//@property (nonatomic, copy) SimpleBlock work;
@property (nonatomic, retain) AnimatedFloat* offset;

-(BOOL)resizeFromLayer:(CAEAGLLayer*)layer;
-(void)load;
-(void)draw;

-(void)labelTouchedWithKey:(NSString*)key;

-(void)handleEmptyTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleEmptyTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleEmptyTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

-(void)emptySpaceTouched;

@end