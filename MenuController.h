#import "Touchable.h"

@class AnimatedFloat;
@class GLMenu;

@interface MenuController : NSObject 
{
    GameRenderer*        _renderer;
    NSMutableArray*      _liveMenuKeys;
    NSMutableArray*      _allMenuKeys;
    NSMutableDictionary* _menus;
    AnimatedFloat*       _offset;
    GLfloat              _initialOffset;
    int                  _currentIndex;
    NSString*            _currentKey;
    AnimatedFloat*       _collapsed;
    AnimatedFloat*       _hidden;
    
    id _owner;
}

@property (nonatomic, assign) GameRenderer*        renderer;
@property (nonatomic, retain) NSMutableArray*      liveMenuKeys;
@property (nonatomic, retain) NSMutableArray*      allMenuKeys;
@property (nonatomic, retain) NSMutableDictionary* menus;
@property (nonatomic, retain) AnimatedFloat*       offset;
@property (nonatomic, assign) GLfloat              initialOffset;
@property (nonatomic, assign) int                  currentIndex;
@property (nonatomic, retain) NSString*            currentKey;
@property (nonatomic, retain) AnimatedFloat*       collapsed;
@property (nonatomic, retain) AnimatedFloat*       hidden;
@property (nonatomic, assign) id                   owner;

-(id)initWithRenderer:(GameRenderer*)renderer;

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