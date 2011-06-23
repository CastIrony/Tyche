#import "GLText.h"
#import "GLRenderer.h"
#import "AnimatedFloat.h"
#import "AnimatedVec3.h"
#import "DisplayContainer.h"

#import "GLTextController.h"

@implementation GLTextController

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
        
        self.opacity = [AnimatedFloat floatWithValue:1];
    
        self.items = [DisplayContainer container];
        
        self.styles = [NSMutableDictionary dictionary];
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
        GLText* newLabel = [GLText withDictionaries:[NSArray arrayWithObjects:self.styles, dictionary, nil]];
        
        newLabel.owner = self;
        newLabel.textController = self;
        
        NSString* key = newLabel.key;
        
        [newKeys addObject:key];
        [newDictionary setObject:newLabel forKey:key];
    }   
    
    [self.items setLiveKeys:newKeys liveDictionary:newDictionary andThen:nil];
    
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
    
    for(GLText* liveItem in self.items.liveObjects)
    {        
        totalHeight += previousPadding + MAX(liveItem.topMargin, previousMargin) + liveItem.topPadding + liveItem.layoutSize.height;
        
        previousMargin = liveItem.bottomMargin;
        previousPadding = liveItem.bottomPadding;
    }
    
    totalHeight += previousMargin + previousPadding;
    
    GLfloat position = self.center ? -(totalHeight / 2.0) : 0;
    
    previousMargin = 0;
    previousPadding = 0;
    
    for(GLText* liveItem in self.items.liveObjects)
    {
        vec3 targetLocation = vec3Make(0, 0, position + previousPadding + MAX(liveItem.topMargin, previousMargin) + liveItem.topPadding + (liveItem.layoutSize.height / 2));
        
        for(GLText* label in [self.items objectsForKey:liveItem.key])
        {
            if(label.layoutLocation)
            {
                [label.layoutLocation setValue:targetLocation forTime:0.4];
            }
            else 
            {
                [label.layoutLocation setValue:targetLocation];
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
        
        for(GLText* item in self.items.objects)
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

@implementation GLTextController (Touchable)

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    id returnObject = object;
    
    TRANSACTION_BEGIN
    {
        glRotatef(self.anglePitch, 1, 0, 0);
                
        glTranslatef(self.location.x, self.location.y, self.location.z);
        
        for(GLText* item in self.items.liveObjects)
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