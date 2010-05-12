#import "Touchable.h"
#import "Geometry.h"
#import "GameController.h"

@class AnimatedFloat;
@class AnimatedVector3D;
@class GLLabel;

@interface TextController : NSObject
{
    GameRenderer* _renderer;
    
    NSMutableDictionary* _styles;
    
    NSMutableArray*      _liveKeys;
    NSMutableDictionary* _liveItems;
    NSMutableDictionary* _deadItems;
    
    Vector3D _location;
    GLfloat  _padding;
    GLfloat  _lightness;
    GLfloat  _opacity;
    GLfloat  _anglePitch;
    GLfloat  _angleJitter;
    GLfloat  _angleSin;
    BOOL     _center;
    
    id _owner;
}

@property (nonatomic, assign) GameRenderer*        renderer;
@property (nonatomic, retain) NSMutableDictionary* styles;

@property (nonatomic, retain) NSMutableArray*      liveKeys;
@property (nonatomic, retain) NSMutableDictionary* liveItems;
@property (nonatomic, retain) NSMutableDictionary* deadItems;

@property (nonatomic, assign) Vector3D location;
@property (nonatomic, assign) GLfloat  padding;
@property (nonatomic, assign) GLfloat  lightness;
@property (nonatomic, assign) GLfloat  opacity;
@property (nonatomic, assign) GLfloat  anglePitch;
@property (nonatomic, assign) GLfloat  angleJitter;
@property (nonatomic, assign) GLfloat  angleSin;
@property (nonatomic, assign) BOOL     center;

@property (nonatomic, assign) id owner;

-(void)update;

-(void)fillWithDictionaries:(NSArray*)dictionaries;
-(void)empty;
-(void)layoutItems;

-(void)draw;


@end

@interface TextController (Touchable) <Touchable>

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;
-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end