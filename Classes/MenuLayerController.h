#import "Touchable.h"

@class MenuController;

@interface MenuLayerController : NSObject 
{
    GameRenderer* _renderer;
    
    NSString* _currentKey;
    NSMutableArray* _menuLayerKeys;
    NSMutableDictionary* _menuLayers;
    AnimatedFloat* _hidden;
}

@property (nonatomic, assign) GameRenderer* renderer;
@property (nonatomic, retain) NSMutableArray* menuLayerKeys;
@property (nonatomic, retain) NSMutableDictionary* menuLayers;
@property (nonatomic, retain) AnimatedFloat* hidden;
@property (nonatomic, readonly) MenuController* currentLayer;

-(void)pushMenu:(MenuController*)menu forKey:(NSString*)key;
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