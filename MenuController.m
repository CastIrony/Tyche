#import "NSArray+Circle.h"
#import "MenuLayerController.h"
#import "GameRenderer.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "GLMenu.h"
#import "TextController.h"
#import "GLLabel.h"
#import "GLDots.h"
#import "DisplayContainer.h"

#import "MenuController.h"

@implementation MenuController

@synthesize renderer      = _renderer;
@synthesize menus         = _menus;
@synthesize offset        = _offset;
@synthesize initialOffset = _initialOffset;
@synthesize currentKey    = _currentKey;
@synthesize collapsed     = _collapsed;
@synthesize death         = _death;
@synthesize hidden        = _hidden;
@synthesize owner         = _owner;

@dynamic isDead;
@dynamic isAlive;

-(id)initWithRenderer:(GameRenderer*)renderer
{
    self = [super init];
    
    if(self) 
    {
        self.renderer = renderer;
        
        self.menus = [DisplayContainer container];
        self.menus.alive = [NSPredicate predicateWithFormat:@"isAlive = YES"];
        self.menus.dead  = [NSPredicate predicateWithFormat:@"isDead  = YES"];
        
        self.offset = [AnimatedFloat withValue:0];
        
        self.hidden    = [AnimatedFloat withValue:0];
        self.death     = [AnimatedFloat withValue:0];
        self.collapsed = [AnimatedFloat withValue:0];
    }
    
    return self;
}

+(MenuController*)withRenderer:(GameRenderer *)renderer
{
    return [[[self alloc] initWithRenderer:renderer] autorelease];
}

-(BOOL)isAlive
{
    return within(self.death.value, 0, 0.001) && self.death.endTime < CFAbsoluteTimeGetCurrent();
}

-(BOOL)isDead
{
    return within(self.death.value, 1, 0.001) && self.death.endTime < CFAbsoluteTimeGetCurrent();
}

-(void)addMenu:(GLMenu*)menu forKey:(NSString*)key
{
    menu.owner = self;
    
    [self.menus insertObject:menu asLastWithKey:key];
    
    [self layoutMenus];
}

-(void)deleteMenuForKey:(NSString*)key
{
    GLMenu* menu = [self.menus liveObjectForKey:key];
    
    menu.death = [AnimatedFloat withStartValue:menu.death.value endValue:1 speed:1];
    
    menu.death.onStart = ^{ [self.menus pruneLiveForKey:key]; };    
    menu.death.onEnd   = ^{ [self.menus pruneDeadForKey:key]; };

    menu.death.curve = AnimationEaseInOut;
    
    [self layoutMenus];
}

-(void)updateOffset
{
    int currentIndex = [self.menus.keys indexOfObject:self.currentKey];
    
    if(currentIndex != NSNotFound)
    {
        if(self.renderer.animated)
        {
            self.offset = [AnimatedFloat withStartValue:self.offset.value endValue:currentIndex speed:2.0];
            self.offset.curve = AnimationEaseInOut;
        }
        else
        {
            self.offset = [AnimatedFloat withValue:currentIndex];
        }
    }
}

-(void)layoutMenus
{
    BOOL collapsed = _collapsed.endValue > 0.5;
    
    NSArray* liveMenus = self.menus.liveObjects;
        
    NSLog(@"%@", self.menus.liveObjects);
    
    if(liveMenus.count == 0) { return; }
    
    int counter = 0;
      
    for(NSString* key in self.menus.keys)
    {
        GLMenu* menu = [self.menus liveObjectForKey:key];
        
        BOOL visible = !collapsed || key == self.currentKey;
        
        if(self.renderer.animated)
        {
            menu.opacity = [AnimatedFloat withStartValue:menu.opacity.value endValue:visible forTime:1.0];
            menu.opacity.curve = AnimationEaseInOut;

            menu.location = [AnimatedFloat withStartValue:menu.location.value endValue:-4.0 * counter forTime:1.0];
            menu.location.curve = AnimationEaseInOut;
        }
        else 
        {
            menu.opacity = [AnimatedFloat withValue:visible];
            
            menu.location = [AnimatedFloat withValue:-4.0 * counter];
        }

        [menu.dots setDots:liveMenus.count current:counter];
        
        if(!collapsed) 
        { 
            counter++; 
        } 
    }
        
    [self updateOffset];
}

-(void)draw
{    
    TRANSACTION_BEGIN
    {   
        GLfloat offset = (1 - (self.death.value + self.hidden.value)) * (self.offset.value * 4) + ((self.death.value + self.hidden.value) * -15);
        
        glTranslatef(offset, 0, 0);
                
        for(GLMenu* menu in self.menus.objects)
        {
            menu.angleSin = 7.5 * sin(2 * self.offset.value + 2 * menu.angleJitter);
            
            menu.lightness = 1 - self.collapsed.value * 0.5;
                        
            [menu reset];
            [menu draw];
        }
    }
    TRANSACTION_END
}

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    TRANSACTION_BEGIN
    {
        GLfloat offset = (1 - (self.death.value + self.hidden.value)) * (self.offset.value * 4) + ((self.death.value + self.hidden.value) * -15);
        
        glTranslatef(offset, 0, 0);
        
        for(GLMenu* menu in self.menus.liveObjects)
        {
            object = [menu testTouch:touch withPreviousObject:object];
        }
    }
    TRANSACTION_END
    
    return object;
}

-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{    
    if(within(self.collapsed.value, 0, 0.001))
    {
        self.offset = [AnimatedFloat withValue:self.initialOffset + (pointTo.x - pointFrom.x) / -320.0];
    }
}

-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point
{    
    if(within(self.collapsed.value, 0, 0.001))
    {
        self.initialOffset = self.offset.value;
    }
}

-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    if(within(self.collapsed.value, 0, 0.001))
    {
        if(pointTo.x - pointFrom.x > 10)
        {
            self.currentKey = [self.menus keyBefore:self.currentKey];
        }
        else if(pointTo.x - pointFrom.x < -10)
        {
            self.currentKey = [self.menus keyAfter:self.currentKey];
        }
        else 
        {
            [self deleteMenuForKey:self.currentKey]; 
        }

        [self updateOffset];
    }
}

@end
