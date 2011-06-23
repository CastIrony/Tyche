#import "Touchable.h"
#import "MC3DVector.h"
#import "GameController.h"

@class AnimatedFloat;
@class AnimatedVec3;
@class GLText;
@class DisplayContainer;

@interface GLTextController : NSObject

@property (nonatomic, assign) GLRenderer*        renderer;
@property (nonatomic, retain) NSMutableDictionary* styles;

@property (nonatomic, retain) DisplayContainer* items;

@property (nonatomic, assign) vec3 location;
@property (nonatomic, assign) GLfloat  lightness;
@property (nonatomic, retain) AnimatedFloat* opacity;
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

@interface GLTextController (Touchable) <Touchable>

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;
-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end