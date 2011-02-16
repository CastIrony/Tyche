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
        
        self.opacity = [AnimatedFloat withValue:1];
    
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
    NSMutableArray* newKeys = [NSMutableArray array];
    NSMutableDictionary* newDictionary = [NSMutableDictionary dictionary];
    
    for(NSDictionary* dictionary in dictionaries)
    {
        GLLabel* newLabel = [GLLabel withDictionaries:[NSArray arrayWithObjects:self.styles, dictionary, nil]];
        
        newLabel.owner = self;
        newLabel.textController = self;
        
        NSString* key = newLabel.key;
        
        [newKeys addObject:key];
        [newDictionary setObject:newLabel forKey:key];
    }   
    
    [self.items setKeys:newKeys andDictionary:newDictionary];
    
    [self layoutItems];
}
    
-(void)empty
{
    [self fillWithDictionaries:[[[NSArray alloc] init] autorelease]];
}

-(void)layoutItems
{
    GLfloat totalHeight = 0;
    GLfloat previousMargin = 0;
    GLfloat previousPadding = 0;
    
    for(GLLabel* liveItem in self.items.liveObjects)
    {        
        totalHeight += previousPadding + MAX(liveItem.topMargin, previousMargin) + liveItem.topPadding + liveItem.layoutSize.height;
        
        previousMargin = liveItem.bottomMargin;
        previousPadding = liveItem.bottomPadding;
    }
    
    totalHeight += previousMargin + previousPadding;
    
    GLfloat position = self.center ? -(totalHeight / 2.0) : 0;
    
    previousMargin = 0;
    previousPadding = 0;
    
    for(GLLabel* liveItem in self.items.liveObjects)
    {
        Vector3D targetLocation = Vector3DMake(0, 0, position + previousPadding + MAX(liveItem.topMargin, previousMargin) + liveItem.topPadding + (liveItem.layoutSize.height / 2));
        
        for(GLLabel* label in [self.items objectsForKey:liveItem.key])
        {
            if(label.layoutLocation)
            {
                label.layoutLocation = [AnimatedVector3D withStartValue:label.layoutLocation.value endValue:targetLocation forTime:0.4];
            }
            else 
            {
                label.layoutLocation = [AnimatedVector3D withValue:targetLocation];
            }
        }
                    
        [liveItem.layoutOpacity setValue:1.0 forTime:0.4 andThen:nil];
        
        position += previousPadding + MAX(liveItem.topMargin, previousMargin) + liveItem.topPadding + liveItem.layoutSize.height;
        
        previousMargin = liveItem.bottomMargin;
        previousPadding = liveItem.bottomPadding;
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