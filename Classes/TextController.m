#import "GLLabel.h"
#import "GameRenderer.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "DisplayContainer.h"

#import "TextController.h"

@implementation TextController

@synthesize styles;

@synthesize items;

@synthesize renderer;
@synthesize location;
@synthesize padding;
@synthesize lightness;
@synthesize opacity;
@synthesize anglePitch;
@synthesize angleJitter;
@synthesize angleSin;
@synthesize center;
@synthesize owner;

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        self.center = YES;
        
        self.opacity = 1;
    
        self.items = [DisplayContainer container];
        
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
    NSMutableArray* liveKeys = [NSMutableArray array];
    
    for(NSMutableDictionary* dictionary in dictionaries)
    {
        GLLabel* newLabel = [GLLabel withDictionaries:[NSArray arrayWithObjects:self.styles, dictionary, nil]];
        
        NSString* key = newLabel.key;
        
        if(!key) { continue; }
                
        GLLabel* oldLabel = [self.items liveObjectForKey:key];
        
        if([newLabel isEqual:oldLabel]) 
        { 
            [self.items moveKeyToLast:key];
        }
        else 
        {
            newLabel.textController = self;
            newLabel.owner = self;
            
            if(oldLabel.layoutLocation) { newLabel.layoutLocation = [AnimatedVector3D withValue:oldLabel.layoutLocation.value]; }
                        
            [self.items insertObject:newLabel asLastWithKey:key];
        }

        [liveKeys addObject:key];          
    }   
    
    for(NSString* key in self.items.liveKeys)
    {
        if(![liveKeys containsObject:key])
        {                
            [[self.items liveObjectForKey:key] killWithDisplayContainer:self.items andKey:key];
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
    
    for(GLLabel* liveItem in self.items.liveObjects)
    {        
        totalHeight += liveItem.layoutSize.height + self.padding;
    }
    
    position = self.center ? -totalHeight / 2.0: 0;
    
    for(GLLabel* liveItem in self.items.liveObjects)
    {
        Vector3D targetLocation = Vector3DMake(0, 0, position + (liveItem.layoutSize.height / 2));
        
        for(GLLabel* label in [self.items objectsForKey:liveItem.key])
        {
            if(label.layoutLocation)
            {
                label.layoutLocation = [AnimatedVector3D withStartValue:label.layoutLocation.value endValue:targetLocation forTime:0.3];
            }
            else 
            {
                label.layoutLocation = [AnimatedVector3D withValue:targetLocation];
            }
        }
                    
        [liveItem.layoutOpacity setValue:1.0 forTime:0.3 andThen:nil];
        
        position += liveItem.layoutSize.height + self.padding;
    }
}

-(void)draw
{
    TRANSACTION_BEGIN
    {
        glRotatef(self.anglePitch, 1, 0, 0);
                
        glTranslatef(self.location.x, self.location.y, self.location.z);
        
        for(GLLabel* item in self.items.objects)
        {
            item.lightness = self.lightness;
            
            [item draw];
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
        
        for(GLLabel* item in self.items.liveObjects)
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