@interface GLChipGroup : NSObject 
{
    NSMutableDictionary* _chips;
    
    AnimatedFloat* _offset;
    
    GLfloat _opacity;
    GLfloat _markerOpacity;
}

@property (nonatomic, retain) NSMutableDictionary* chips;
@property (nonatomic, retain) AnimatedFloat* offset;
@property (nonatomic, assign) GLfloat opacity;
@property (nonatomic, assign) GLfloat markerOpacity;

-(void)drawShadows;
-(void)drawMarkers;
-(void)drawChips;

@end
