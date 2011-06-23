#import "DisplayContainer.h"
#import "GameController.h"

@class GLFlatCardGroup;
@class DisplayContainer;
@class AnimatedFloat;
@class AnimatedVec3;

@interface GLFlatCard : NSObject <Displayable>
{
    vec2 textureOffsetCard[15];
    vec2 textureSizeCard;

    vec3* arrayVertex;
    
    vec2* arrayTexture0;
    vec2* arrayTexture1;
    
    GLushort* arrayMesh;
}

@property (nonatomic, assign)   GLFlatCardGroup*    cardGroup;
@property (nonatomic, assign)   int                 suit;
@property (nonatomic, assign)   int                 numeral;
@property (nonatomic, assign)   int                 position;
@property (nonatomic, assign)   GLfloat             angleJitter;
@property (nonatomic, retain)   AnimatedFloat*      dealt;
@property (nonatomic, retain)   AnimatedFloat*      death;
@property (nonatomic, retain)   AnimatedFloat*      angleFan;
@property (nonatomic, retain)   AnimatedFloat*      isFlipped;
@property (nonatomic, retain)   AnimatedFloat*      bendFactor;
@property (nonatomic, copy)     NSString*           key;

+(GLFlatCard*)cardWithKey:(NSString*)key;

-(id)initWithSuit:(int)suit numeral:(int)numeral;

-(void)draw;

@end