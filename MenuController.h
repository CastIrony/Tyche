#import "Touchable.h"
#import "Killable.h"

@class AnimatedFloat;
@class GLMenu;
@class DisplayContainer;

@interface MenuController : NSObject 

@property (nonatomic, assign) GameRenderer*        renderer;
@property (nonatomic, retain) DisplayContainer*    menus;
@property (nonatomic, retain) AnimatedFloat*       offset;
@property (nonatomic, assign) GLfloat              initialOffset;
@property (nonatomic, retain) NSString*            currentKey;
@property (nonatomic, retain) AnimatedFloat*       collapsed;
@property (nonatomic, retain) AnimatedFloat*       hidden;
@property (nonatomic, retain) AnimatedFloat*       death;
@property (nonatomic, assign) id                   owner;
@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) BOOL isAlive;

-(id)initWithRenderer:(GameRenderer*)renderer;
+(id)withRenderer:(GameRenderer*)renderer;

-(void)addMenu:(GLMenu*)menu forKey:(NSString*)key;
-(void)deleteMenuForKey:(NSString*)key;
-(void)layoutMenus;
-(void)draw;

@end

@interface MenuController (Touchable) <Touchable>

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;
-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end

@interface MenuController (Killable) <Killable>

@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) BOOL isAlive;

-(void)die;

@end