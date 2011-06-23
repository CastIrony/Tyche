#import "MC3DVector.h"
#import "GameController.h"

@class AnimatedFloat;
@class AnimatedVec3;
@class GLTable;
@class GLTexture;
@class GLSplash;
@class GLPlayer;
@class GLMenuLayerController;
@class AppController;
@class SoundController;
@class GLView;
@class DisplayContainer;
@class GLCamera;

@interface GLRenderer : UIViewController <UIAccelerometerDelegate>

@property (nonatomic, retain)   AppController*         appController;
@property (nonatomic, readonly) GameController*        gameController;
@property (nonatomic, readonly) SoundController*       soundController;

@property (nonatomic, retain)   NSMutableDictionary*   touchedObjects;
@property (nonatomic, retain)   NSMutableDictionary*   touchedLocations;

@property (nonatomic, retain)   GLMenuLayerController* menuLayerController;
@property (nonatomic, retain)   GLCamera*              camera;
@property (nonatomic, retain)   GLTable*               table;
@property (nonatomic, retain)   GLSplash*              splash;
@property (nonatomic, retain)   AnimatedFloat*         lightness;

@property (nonatomic, retain)   DisplayContainer*      players;

@property (nonatomic, retain)   AnimatedFloat*         currentOffset;
@property (nonatomic, assign)   GLfloat                initialOffset;

@property (nonatomic, retain)   GLPlayer*              currentPlayer;
@property (nonatomic, readonly) GLPlayer*              mainPlayer;

@property (nonatomic, readonly) GLView*                glView;

-(void)load;
-(void)draw;

-(void)labelTouchedWithKey:(NSString*)key;

-(void)handleEmptyTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleEmptyTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleEmptyTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)vpointTo;

-(void)updatePlayersWithKeys:(NSArray*)keys andThen:(SimpleBlock)work;

-(void)emptySpaceTouched;

@end