#import "Touchable.h"

@class GLMenuController;
@class DisplayContainer;
@class AnimatedFloat;

@interface GLMenuLayerController : NSObject 

@property (nonatomic, assign) GLRenderer* renderer;
@property (nonatomic, retain) DisplayContainer* menuLayers;
@property (nonatomic, retain) AnimatedFloat* hidden;
@property (nonatomic, readonly) GLMenuController* currentLayer;

-(void)showMenus;
-(void)hideMenus;

-(void)pushMenuLayer:(GLMenuController*)menu forKey:(NSString*)key;
-(void)popUntilKey:(NSString*)key;
-(void)cancelMenuLayer;

-(void)draw;

@end

@interface GLMenuLayerController (Touchable) <Touchable>

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;
-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end