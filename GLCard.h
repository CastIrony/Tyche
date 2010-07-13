#import "Touchable.h"
#import "GameController.h"

@class GLCardGroup;
@class AnimatedFloat;
@class DisplayContainer;
@class AnimatedVector3D;

@interface GLCard : NSObject
{
    Vector3D controlPointsBase[16];
    Vector3D controlPointsFront[16];
    Vector3D controlPointsBack[16];
    Vector3D controlPointsLabel[16];
    Vector3D controlPointsShadow[16];
    
    Vector2D textureOffsetCard[15];
    Vector2D textureSizeCard;
    Vector2D textureSizeLabel;
    
    int meshWidthFront;
    int meshWidthBack;
    int meshWidthShadow;

    int meshHeightFront;
    int meshHeightBack;
    int meshHeightShadow;
    
    Vector3D* arrayVertexFront;
    Vector3D* arrayVertexBack;
    Vector3D* arrayVertexBackSimple;
    Vector3D* arrayVertexShadow;
    
    Vector3D* arrayNormalFront;
    Vector3D* arrayNormalBack;
    Vector3D* arrayNormalBackSimple;
    Vector3D* arrayNormalShadow;
    
    Vector2D* arrayTexture0Front;
    Vector2D* arrayTexture0Back;
    Vector2D* arrayTexture0BackSimple;
    Vector2D* arrayTexture0Shadow;
    
    Vector2D* arrayTexture1Front;
    Vector2D* arrayTexture1Back;
    Vector2D* arrayTexture1BackSimple;
    
    GLushort* arrayMeshFront;
    GLushort* arrayMeshBack;
    GLushort* arrayMeshBackSimple;
    GLushort* arrayMeshShadow;
}

@property (nonatomic, assign)   GameRenderer*       renderer;
@property (nonatomic, assign)   GLCardGroup*        cardGroup;
@property (nonatomic, assign)   int                 suit;
@property (nonatomic, assign)   int                 numeral;
@property (nonatomic, assign)   int                 position;
@property (nonatomic, assign)   GLfloat             angleJitter;
@property (nonatomic, retain)   AnimatedFloat*      location;
@property (nonatomic, retain)   AnimatedFloat*      dealt;
@property (nonatomic, retain)   AnimatedFloat*      death;
@property (nonatomic, retain)   AnimatedFloat*      isHeld;
@property (nonatomic, retain)   AnimatedFloat*      isSelected;
@property (nonatomic, retain)   AnimatedFloat*      angleFlip;
@property (nonatomic, retain)   AnimatedFloat*      angleFan;
@property (nonatomic, retain)   AnimatedFloat*      bendFactor;
@property (nonatomic, readonly) BOOL                isMeshAnimating;
@property (nonatomic, readonly) NSString*           key;

+(GLCard*)cardWithKey:(NSString*)keys;

-(id)initWithSuit:(int)suit numeral:(int)numeral;

-(void)drawFront;
-(void)drawBack;
-(void)drawShadow;
-(void)drawLabel;

-(void)makeControlPoints;
-(void)rotateWithAngle:(GLfloat)angle aroundPoint:(Vector3D)point andAxis:(Vector3D)axis;
-(void)bendWithAngle:(GLfloat)angle aroundPoint:(Vector3D)point andAxis:(Vector3D)axis;
-(void)scaleWithFactor:(Vector3D)factor fromPoint:(Vector3D)point;
-(void)scaleShadowWithFactor:(Vector3D)factor fromPoint:(Vector3D)point;
-(void)translateWithVector:(Vector3D)vector;
-(void)flattenShadow;

@end

@interface GLCard (Touchable) <Touchable>

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;
-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end

@interface GLCard (Killable) <Killable>

@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) BOOL isAlive;

-(void)killWithDisplayContainer:(DisplayContainer*)container andKey:(id)key;

@end