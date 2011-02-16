#import "Geometry.h"
#import "Touchable.h"
#import "DisplayContainer.h"
#import "GameController.h"

@class AnimatedFloat;
@class AnimatedVector3D;
@class GLChipGroup;

@interface GLChip : NSObject <Perishable, Touchable>
{
    Vector2D chipOffsets[9];
    Vector2D markerOffsets[9];
    Vector2D shadingOffset;
    Vector2D shadowOffset;
    Vector2D chipSize;
    
    Vector3D* stackVectors;
    Vector2D* stackTexture;
    GLushort* stackMesh;   
    Color3D*  stackColors;

    Vector3D* shadowVectors;
    Vector2D* shadowTexture;
    GLushort* shadowMesh;   
    Color3D*  shadowColors;

    int _meshSize;
}

@property (nonatomic, assign) Vector3D          location;
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