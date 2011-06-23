@class DisplayContainer;
@class GLPlayer;
@class AnimatedFloat;

@interface GLChipGroup : NSObject 

@property (nonatomic, retain) DisplayContainer* chips;
@property (nonatomic, retain) AnimatedFloat* offset;
@property (nonatomic, assign) GLfloat opacity;
@property (nonatomic, assign) GLPlayer* player;
@property (nonatomic, assign) BOOL frozen;
@property (nonatomic, readonly) BOOL isAnimating;

+(GLChipGroup*)chipGroup;

-(void)drawShadows;
-(void)drawMarkers;
-(void)drawChips;

@end
