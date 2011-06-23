#import "Touchable.h"
#import "DisplayContainer.h"

@class AnimatedFloat;
@class GLMenu;
@class DisplayContainer;

@interface GLMenuController : NSObject 

@property (nonatomic, assign) GLRenderer*          renderer;
@property (nonatomic, retain) DisplayContainer*    menus;
@property (nonatomic, retain) AnimatedFloat*       offset;
@property (nonatomic, assign) GLfloat              initialOffset;
@property (nonatomic, copy)   NSString*            currentKey;
@property (nonatomic, retain) AnimatedFloat*       collapsed;
@property (nonatomic, retain) AnimatedFloat*       hidden;
@property (nonatomic, retain) AnimatedFloat*       death;
@property (nonatomic, assign) id                   owner;
@property (nonatomic, assign) BOOL                 first;
@property (nonatomic, copy)   NSString*            key;

-(id)initWithRenderer:(GLRenderer*)renderer;
+(id)withRenderer:(GLRenderer*)renderer;

-(void)addMenu:(GLMenu*)menu forKey:(NSString*)key;
-(void)deleteMenuForKey:(NSString*)key;
-(void)layoutMenus;
-(void)draw;

@end

@interface GLMenuController (Touchable) <Touchable>

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;
-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end

@interface GLMenuController (Displayable) <Displayable>

@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) BOOL isAlive;

-(void)killWithDisplayContainer:(DisplayContainer*)container key:(id)key andThen:(SimpleBlock)work;

@end