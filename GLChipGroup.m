#import "GLChip.h"
#import "GLPlayer.h"
#import "AnimatedFloat.h"
#import "DisplayContainer.h"
#import "GLChipGroup.h"

@implementation GLChipGroup

@synthesize chips = _chips;
@synthesize offset = _offset;
@synthesize opacity = _opacity;
@synthesize player = _player;
@synthesize frozen = _frozen;

+(GLChipGroup*)chipGroup
{
    GLChipGroup* chipGroup = [[[GLChipGroup alloc] init] autorelease];
    
    NSMutableDictionary* newLiveDictionary = [NSMutableDictionary dictionary];
    NSArray* newKeys = [NSArray arrayWithObjects:@"1", @"10000", @"5", @"5000", @"10", @"1000", @"50", @"500", @"100", nil];

    { GLChip* chip = [GLChip chip]; chip.chipNumber = 0; chip.chipGroup = chipGroup; [newLiveDictionary setObject:chip forKey:@"1"    ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 1; chip.chipGroup = chipGroup; [newLiveDictionary setObject:chip forKey:@"5"    ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 2; chip.chipGroup = chipGroup; [newLiveDictionary setObject:chip forKey:@"10"   ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 3; chip.chipGroup = chipGroup; [newLiveDictionary setObject:chip forKey:@"50"   ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 4; chip.chipGroup = chipGroup; [newLiveDictionary setObject:chip forKey:@"100"  ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 5; chip.chipGroup = chipGroup; [newLiveDictionary setObject:chip forKey:@"500"  ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 6; chip.chipGroup = chipGroup; [newLiveDictionary setObject:chip forKey:@"1000" ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 7; chip.chipGroup = chipGroup; [newLiveDictionary setObject:chip forKey:@"5000" ]; }
    { GLChip* chip = [GLChip chip]; chip.chipNumber = 8; chip.chipGroup = chipGroup; [newLiveDictionary setObject:chip forKey:@"10000"]; }
        
    [chipGroup.chips setLiveKeys:newKeys liveDictionary:newLiveDictionary andThen:nil];

    return chipGroup;
}

-(id)init
{
    self = [super init];
        
    if(self) 
    {
        self.chips = [DisplayContainer container];
        self.offset = [AnimatedFloat floatWithValue:0];
    }
     
    return self;
}

-(BOOL)isAnimating
{
    if(!self.offset.hasEnded) return YES;
    
    for(GLChip* chip in self.chips.objects)
    {
        if(!chip.count.hasEnded) return YES;
    }
    
    return NO;
}

-(void)drawShadows
{
    for(GLChip* chip in self.chips.objects) 
    { 
        [chip drawShadow]; 
    }
}

-(void)drawMarkers
{
    GLfloat window = 4.0;
    
    for(GLChip* chip in self.chips.objects) 
    {
        chip.markerOpacity = clipFloat((1.0 + window / 2.0) - distance((GLfloat)chip.chipNumber, self.offset.value + window / 2.0), 0, 1);
                
        [chip drawMarker];
    }
}

-(void)drawChips
{     
    for(GLChip* chip in self.chips.objects) 
    {   
        chip.location = vec3Make(6 - 3 * (chip.chipNumber - self.offset.value), 0, -4.3);
                
        [chip draw];
    }   
}    

@end
