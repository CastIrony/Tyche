#import "Touchable.h"

@class MenuController;
@class DisplayContainer;
@class AnimatedFloat;

@interface MenuLayerController : NSObject 

@property (nonatomic, assign) GameRenderer* renderer;
@property (nonatomic, retain) DisplayContainer* menuLayers;
@property (nonatomic, retain) AnimatedFloat* hidden;
@property (nonatomic, readonly) MenuController* currentLayer;

-(void)pushMenuLayer:(MenuController*)menu forKey:(NSString*)key;
-(void)popUntilKey:(NSString*)key;
-(void)cancelMenuLayer;

-(void)draw;

@end

@interface MenuLayerController (Touchable) <Touchable>

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;
-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end