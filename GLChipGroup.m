#import "GLChip.h"
#import "AnimatedFloat.h"
#import "DisplayContainer.h"
#import "GLChipGroup.h"

@implementation GLChipGroup

@synthesize chips = _chips;
@synthesize offset = _offset;
@synthesize opacity = _opacity;
@synthesize markerOpacity = _markerOpacity;
@synthesize renderer = _renderer;

+(GLChipGroup*)chipGroupWithRenderer:(GameRenderer*)renderer
{
    GLChipGroup* chipGroup = [[[GLChipGroup alloc] init] autorelease];
    
    chipGroup.renderer = renderer;

    { GLChip* chip = [GLChip chip]; chip.chipNumber = 0; chip.chipGroup = chipGroup; chip.location = Vector3DMake(  6, 0, -4.3); [chipGroup.chips insertObject:chip asLastWithKey:@"1"    ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 8; chip.chipGroup = chipGroup; chip.location = Vector3DMake(-18, 0, -4.3); [chipGroup.chips insertObject:chip asLastWithKey:@"10000"]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 1; chip.chipGroup = chipGroup; chip.location = Vector3DMake(  3, 0, -4.3); [chipGroup.chips insertObject:chip asLastWithKey:@"5"    ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 7; chip.chipGroup = chipGroup; chip.location = Vector3DMake(-15, 0, -4.3); [chipGroup.chips insertObject:chip asLastWithKey:@"2500 "]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 2; chip.chipGroup = chipGroup; chip.location = Vector3DMake(  0, 0, -4.3); [chipGroup.chips insertObject:chip asLastWithKey:@"10"   ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 6; chip.chipGroup = chipGroup; chip.location = Vector3DMake(-12, 0, -4.3); [chipGroup.chips insertObject:chip asLastWithKey:@"1000" ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 3; chip.chipGroup = chipGroup; chip.location = Vector3DMake( -3, 0, -4.3); [chipGroup.chips insertObject:chip asLastWithKey:@"25"   ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 5; chip.chipGroup = chipGroup; chip.location = Vector3DMake( -9, 0, -4.3); [chipGroup.chips insertObject:chip asLastWithKey:@"500"  ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 4; chip.chipGroup = chipGroup; chip.location = Vector3DMake( -6, 0, -4.3); [chipGroup.chips insertObject:chip asLastWithKey:@"100"  ]; }
    
    return chipGroup;
}

-(id)init
{
    self = [super init];
        
    if(self) 
    {
        self.chips = [DisplayContainer container];
        self.offset = [AnimatedFloat withValue:0];
    }
     
    return self;
}

-(void)drawShadows
{
    for(GLChip* chip in self.chips.liveObjects) 
    { 
        [chip drawShadow]; 
    }
}

-(void)drawMarkers
{
    for(GLChip* chip in self.chips.liveObjects) 
    {         
        [chip drawMarker]; 
    }    
}

-(void)drawChips
{ 
    for(GLChip* chip in self.chips.liveObjects) 
    {         
        [chip draw]; 
    }   
}    

@end
