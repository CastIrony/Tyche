#import "MC3DVector.h"
#import "Touchable.h"
#import "DisplayContainer.h"
#import "GameController.h"

@class AnimatedFloat;
@class AnimatedVec3;
@class GLChipGroup;

@interface GLChip : NSObject <Displayable, Touchable>
{
    vec2 chipOffsets[9];
    vec2 markerOffsets[9];
    vec2 shadingOffset;
    vec2 shadowOffset;
    vec2 chipSize;
    
    vec3* stackVectors;
    vec2* stackTexture;
    GLushort* stackMesh;   
    color*  stackColors;

    vec3* shadowVectors;
    vec2* shadowTexture;
    GLushort* shadowMesh;   
    color*  shadowColors;

    int _meshSize;
}

@property (nonatomic, assign) vec3          location;
@property (nonatomic, retain) AnimatedFloat*    count;
@property (nonatomic, assign) int               chipNumber;
@property (nonatomic, assign) int               maxCount;
@property (nonatomic, assign) GLfloat           initialCount;
@property (nonatomic, assign) GLfloat           markerOpacity;
@property (nonatomic, assign) GLChipGroup*      chipGroup;

@property (nonatomic, assign) DisplayContainer* displayContainer;
@property (nonatomic, copy)   id<NSCopying>     key;

+(GLChip*)chip;

-(void)generateMesh;
-(void)draw;
-(void)drawShadow;
-(void)drawMarker;

@end