#import "GLLabel.h"
#import "GameRenderer.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"

#import "TextController.h"

@implementation TextController

@synthesize styles      = _styles;

@synthesize items;

@synthesize renderer    = _renderer;
@synthesize location    = _location;
@synthesize padding     = _padding;
@synthesize lightness   = _lightness;
@synthesize opacity     = _opacity;
@synthesize anglePitch  = _anglePitch;
@synthesize angleJitter = _angleJitter;
@synthesize angleSin    = _angleSin;
@synthesize center      = _center;
@synthesize owner       = _owner;

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        _liveKeys  = [[NSMutableArray      alloc] init];
        _liveItems = [[NSMutableDictionary alloc] init];
        _deadItems = [[NSMutableDictionary alloc] init];
                
        _center = YES;
        
        _opacity = 1;
    
        self.styles = [[[NSMutableDictionary alloc] init] autorelease];
        self.lightness = 1;
    }
    
    return self;
}

-(void)update
{
    
}

-(void)fillWithDictionaries:(NSArray*)dictionaries
{
    
    NSMutableArray*      liveKeys  = [[self.liveKeys  retain] autorelease];
    NSMutableDictionary* liveItems = [[self.liveItems retain] autorelease];
    
    self.liveKeys  = [[[NSMutableArray      alloc] init] autorelease];
    self.liveItems = [[[NSMutableDictionary alloc] init] autorelease];
    
    for(NSMutableDictionary* dictionary in dictionaries)
    {
        GLLabel* newLabel = [GLLabel withDictionaries:[NSArray arrayWithObjects:self.styles, dictionary, nil]];
        GLLabel* oldLabel = [liveItems objectForKey:newLabel.key];
        
        if([newLabel isEqual:oldLabel])
        {
            newLabel = oldLabel;
            oldLabel = nil;
        }
        
        if(oldLabel) 
        {             
            [self.deadItems setObject:oldLabel forKey:newLabel.key]; 
        }
        
        newLabel.textController = self;
        newLabel.owner = self;
        
        [self.liveItems setObject:newLabel forKey:newLabel.key];
        [self.liveKeys  addObject:newLabel.key];
    }   
    
    for(NSString* key in liveKeys)
    {
        if(![self.liveKeys containsObject:key])
        {        
            GLLabel* oldLabel = [liveItems objectForKey:key];
            
            if(oldLabel) 
            { 
                [self.deadItems setObject:oldLabel forKey:key]; 
            }
        }
    }
    
    [self layoutItems];
}
    
-(void)empty
{
    [self fillWithDictionaries:[[[NSArray alloc] init] autorelease]];
}

-(void)layoutItems
{
    GLfloat totalHeight = -self.padding;
    GLfloat position;
    
    for(NSString* key in self.liveKeys)
    {
        GLLabel* liveItem = [self.liveItems objectForKey:key];
        
        totalHeight += liveItem.layoutSize.height + self.padding;
    }
    
    position = self.center ? -totalHeight / 2.0: 0;
    
    for(NSString* key in self.liveKeys)
    {
        GLLabel* liveItem = [self.liveItems objectForKey:key];
        GLLabel* deadItem = [self.deadItems objectForKey:key];
        
        Vector3D targetLocation = Vector3DMake(0, 0, position + (liveItem.layoutSize.height / 2));
        
        if(self.renderer.animated)
        {
            if(deadItem.layoutLocation) 
            {
                liveItem.layoutLocation = [AnimatedVector3D withStartValue:deadItem.layoutLocation.value endValue:targetLocation forTime:0.3];
                deadItem.layoutLocation = [AnimatedVector3D withStartValue:deadItem.layoutLocation.value endValue:targetLocation forTime:0.3];
            }
            else if(liveItem.layoutLocation)
            {
                liveItem.layoutLocation = [AnimatedVector3D withStartValue:liveItem.layoutLocation.value endValue:targetLocation forTime:0.3];
                deadItem.layoutLocation = [AnimatedVector3D withStartValue:liveItem.layoutLocation.value endValue:targetLocation forTime:0.3];
            }
            else
            {
                liveItem.layoutLocation = [AnimatedVector3D withStartValue:targetLocation endValue:targetLocation forTime:0.3];
                deadItem.layoutLocation = [AnimatedVector3D withStartValue:targetLocation endValue:targetLocation forTime:0.3];
            }
            
            liveItem.layoutOpacity = [AnimatedFloat withStartValue:liveItem.layoutOpacity.value endValue:1.0 forTime:0.3];
        }
        else 
        {
            liveItem.layoutLocation = [AnimatedVector3D withValue:targetLocation];
            deadItem.layoutLocation = [AnimatedVector3D withValue:targetLocation];
            
            liveItem.layoutOpacity = [AnimatedFloat withValue:1.0];
        }
        
        position += liveItem.layoutSize.height + self.padding;
    }
    
    for(GLLabel* deadItem in self.deadItems.objectEnumerator)
    {
        if(self.renderer.animated)
        {
            deadItem.layoutOpacity = [AnimatedFloat withStartValue:deadItem.layoutOpacity.value endValue:0.0 forTime:0.4];
        }
        else 
        {
            deadItem.layoutOpacity = [AnimatedFloat withValue:0.0];
        }
        
    }
}

-(void)clearDeadItem:(NSString*)key
{
    [self.deadItems removeObjectForKey:key];   
}

-(void)draw
{
    TRANSACTION_BEGIN
    {
        glRotatef(self.anglePitch, 1, 0, 0);
                
        glTranslatef(self.location.x, self.location.y, self.location.z);
        
        for(GLLabel* deadItem in self.deadItems.objectEnumerator)
        {
            deadItem.lightness = self.lightness;
            
            [deadItem draw];
        }
        
        for(GLLabel* liveItem in self.liveItems.objectEnumerator)
        {                                      
            liveItem.lightness = self.lightness;
            
            [liveItem draw];
        }
    }
    TRANSACTION_END
}

-(void)labelTouchedWithKey:(NSString*)key
{
    [self.renderer labelTouchedWithKey:key];
}

@end

@implementation TextController (Touchable)

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    id returnObject = object;
    
    TRANSACTION_BEGIN
    {
        glRotatef(self.anglePitch, 1, 0, 0);
                
        glTranslatef(self.location.x, self.location.y, self.location.z);
        
        for(GLLabel* item in self.liveItems.objectEnumerator)
        {
            returnObject = [item testTouch:touch withPreviousObject:returnObject];
        }
    }
    TRANSACTION_END
    
    return returnObject;
}

-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point
{    
    [self.owner handleTouchDown:touch fromPoint:point];
}

-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    [self.owner handleTouchMoved:touch fromPoint:pointFrom toPoint:pointTo];
}

-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    [self.owner handleTouchUp:touch fromPoint:pointFrom toPoint:pointTo];
}

@end