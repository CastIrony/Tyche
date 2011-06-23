#import "Touchable.h"
#import "DisplayContainer.h"
#import "GameController.h"

@class GLCardGroup;
@class AnimatedFloat;
@class DisplayContainer;
@class AnimatedVec3;

@interface GLCard : NSObject <Touchable, Displayable>
{
    vec3 controlPointsBase[16];
    vec3 controlPointsFront[16];
    vec3 controlPointsBack[16];
    vec3 controlPointsLabel[16];
    vec3 controlPointsShadow[16];
    
    vec2 textureOffsetCard[15];
    vec2 textureSizeCard;
    vec2 textureSizeLabel;
    
    int meshWidthFront;
    int meshWidthBack;
    int meshWidthShadow;

    int meshHeightFront;
    int meshHeightBack;
    int meshHeightShadow;
    
    vec3* arrayVertexFront;
    vec3* arrayVertexBack;
    vec3* arrayVertexBackSimple;
    vec3* arrayVertexShadow;
    
    vec3* arrayNormalFront;
    vec3* arrayNormalBack;
    vec3* arrayNormalBackSimple;
    vec3* arrayNormalShadow;
    
    vec2* arrayTexture0Front;
    vec2* arrayTexture0Back;
    vec2* arrayTexture0BackSimple;
    vec2* arrayTexture0Shadow;
    
    vec2* arrayTexture1Front;
    vec2* arrayTexture1Back;
    vec2* arrayTexture1BackSimple;
    
    GLushort* arrayMeshFront;
    GLushort* arrayMeshBack;
    GLushort* arrayMeshBackSimple;
    GLushort* arrayMeshShadow;
}

@property (nonatomic, assign)   GLCardGroup*        cardGroup;
@property (nonatomic, assign)   int                 suit;
@property (nonatomic, assign)   int                 numeral;
@property (nonatomic, assign)   int                 position;
@property (nonatomic, assign)   GLfloat             angleJitter;
@property (nonatomic, retain)   AnimatedFloat*      dealt;
@property (nonatomic, retain)   AnimatedFloat*      death;
@property (nonatomic, retain)   AnimatedFloat*      isHeld;
@property (nonatomic, retain)   AnimatedFloat*      angleFan;
@property (nonatomic, retain)   AnimatedFloat*      isFlipped;
@property (nonatomic, retain)   AnimatedFloat*      bendFactor;
@property (nonatomic, copy)     NSString*           key;
@property (nonatomic, assign)   BOOL                cancelTap;
@property (nonatomic, readonly) BOOL                isMeshAnimating;

+(GLCard*)cardWithKey:(NSString*)key;
+(GLCard*)cardWithKey:(NSString*)key held:(BOOL)held;

-(id)initWithSuit:(int)suit numeral:(int)numeral held:(BOOL)held;

-(void)drawFront;
-(void)drawBack;
-(void)drawShadow;
-(void)drawLabel;

-(void)makeControlPoints;
-(void)rotateWithAngle:(GLfloat)angle aroundPoint:(vec3)point andAxis:(vec3)axis;
-(void)bendWithAngle:(GLfloat)angle aroundPoint:(vec3)point andAxis:(vec3)axis;
-(void)scaleWithFactor:(vec3)factor fromPoint:(vec3)point;
-(void)scaleShadowWithFactor:(vec3)factor fromPoint:(vec3)point;
-(void)translateWithVector:(vec3)vector;
-(void)flattenShadow;

@end