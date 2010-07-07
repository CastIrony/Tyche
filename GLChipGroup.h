@class DisplayContainer;

@interface GLChipGroup : NSObject 

@property (nonatomic, retain) DisplayContainer* chips;
@property (nonatomic, retain) AnimatedFloat* offset;
@property (nonatomic, assign) GLfloat opacity;
@property (nonatomic, assign) GLfloat markerOpacity;
@property (nonatomic, assign) GameRenderer* renderer;

-(void)drawShadows;
-(void)drawMarkers;
-(void)drawChips;

@end
