#import "Geometry.h"
#import "Touchable.h"
#import "GameController.h"

@class AnimatedFloat;
@class AnimatedVector3D;

@interface GLChip : NSObject
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

@property (nonatomic, assign) GameRenderer*   renderer;
@property (nonatomic, assign) Vector3D        location;
@property (nonatomic, retain) AnimatedFloat*  count;
@property (nonatomic, assign) int             chipNumber;
@property (nonatomic, assign) int             maxCount;
@property (nonatomic, assign) GLfloat         initialCount;

@property (nonatomic, assign) GLChipGroup*    chipGroup;

+(GLChip*)chip;

-(void)generateMesh;
-(void)draw;
-(void)drawShadow;
-(void)drawMarker;

@end

@interface GLChip (Touchable) <Touchable>

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;
-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end