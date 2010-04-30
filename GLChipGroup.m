#import "GLChip.h"
#import "AnimatedFloat.h"
#import "GLChipGroup.h"

@implementation GLChipGroup

@synthesize chips = _chips;
@synthesize offset = _offset;
@synthesize opacity = _opacity;
@synthesize markerOpacity = _markerOpacity;

-(id)init
{
    self = [super init];
        
    if(self) 
    {
        self.chips = [[[NSMutableDictionary alloc] init] autorelease];
        
        self.offset = [AnimatedFloat withValue:0];
    }
     
    return self;
}

-(void)drawShadows
{
    for(GLChip* chip in self.chips.objectEnumerator) 
    { 
        [chip drawShadow]; 
    }
}

-(void)drawMarkers
{
    for(GLChip* chip in self.chips.objectEnumerator) 
    { 
        chip.markerOpacity = self.markerOpacity;
        
        [chip drawMarker]; 
    }    
}

-(void)drawChips
{        
    GLChip* chip1     = [self.chips objectForKey:@"1"];
    GLChip* chip5     = [self.chips objectForKey:@"5"];
    GLChip* chip10    = [self.chips objectForKey:@"10"];
    GLChip* chip25    = [self.chips objectForKey:@"25"];
    GLChip* chip100   = [self.chips objectForKey:@"100"];
    GLChip* chip500   = [self.chips objectForKey:@"500"];
    GLChip* chip1000  = [self.chips objectForKey:@"1000"];
    GLChip* chip2500  = [self.chips objectForKey:@"2500"];
    GLChip* chip10000 = [self.chips objectForKey:@"10000"];
    
    [chip1     setOpacity:self.opacity];
    [chip5     setOpacity:self.opacity];
    [chip10    setOpacity:self.opacity];
    [chip25    setOpacity:self.opacity];
    [chip100   setOpacity:self.opacity];
    [chip500   setOpacity:self.opacity];
    [chip1000  setOpacity:self.opacity];
    [chip2500  setOpacity:self.opacity];
    [chip10000 setOpacity:self.opacity];

    GLfloat position = 3 * self.offset.value;
    
    [chip1     setLocation:Vector3DMake(position +  6, 0, -4.3)];
    [chip5     setLocation:Vector3DMake(position +  3, 0, -4.3)];
    [chip10    setLocation:Vector3DMake(position +  0, 0, -4.3)];
    [chip25    setLocation:Vector3DMake(position -  3, 0, -4.3)];
    [chip100   setLocation:Vector3DMake(position -  6, 0, -4.3)];
    [chip500   setLocation:Vector3DMake(position -  9, 0, -4.3)];
    [chip1000  setLocation:Vector3DMake(position - 12, 0, -4.3)];
    [chip2500  setLocation:Vector3DMake(position - 15, 0, -4.3)];
    [chip10000 setLocation:Vector3DMake(position - 18, 0, -4.3)];
    
    [chip1     draw];
    [chip10000 draw];
    [chip5     draw];
    [chip2500  draw];
    [chip10    draw];
    [chip1000  draw];
    [chip25    draw];
    [chip500   draw];
    [chip100   draw];
}    

@end
