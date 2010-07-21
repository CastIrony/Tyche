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
@synthesize first         = _first;

-(id)initWithRenderer:(GameRenderer*)renderer
{
    self = [super init];
    
    if(self) 
    {
        self.renderer = renderer;
        
        self.menus = [DisplayContainer container];
        
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
    
    if(!self.currentKey) { self.currentKey = key; }
    
    [self layoutMenus];
}

-(void)deleteMenuForKey:(NSString*)key
{
    GLMenu* menu = [self.menus liveObjectForKey:key];
    
    [menu.death setValue:1 forTime:1 andThen:^{ [self.menus pruneDeadForKey:key]; [self layoutMenus]; }];
    
    [self.menus pruneLiveForKey:key]; 
    [self layoutMenus];
}

-(void)updateOffset
{
    if(self.currentKey)
    {
        int currentIndex = [self.menus.keys indexOfObject:self.currentKey];
        
        if(currentIndex != NSNotFound)
        {
            [self.offset setValue:currentIndex forTime:0.5 andThen:nil];
        }
    }
    else if(self.isAlive) 
    {
        [self.offset setValue:-1 forTime:0.5 andThen:nil];
        
        [self.owner cancelMenuLayer];
    }
}

-(void)layoutMenus
{
    NSArray* liveMenus = self.menus.liveObjects;
            
    if(liveMenus.count == 0) { return; }
    
    int counter = 0;
          
    BOOL collapsed = self.collapsed.endValue > 0.5;
    
    for(NSString* key in self.menus.liveKeys)
    {   
        GLMenu* menu = [self.menus liveObjectForKey:key];
        
        if(menu.location)
        {
            [menu.location setValue:-4.0 * counter forTime:1.0 andThen:nil];
        }
        else 
        {
            menu.location = [AnimatedFloat withValue:-4.0 * counter];
        }
            
        [menu.opacity setValue:([key isEqualToString:self.currentKey] || !collapsed) forTime:1.0 andThen:nil];
        
        [menu.dots setDots:liveMenus.count current:counter];
        
        counter++;
    }
        
    [self updateOffset];
}

-(void)draw
{    
    TRANSACTION_BEGIN
    {   
        GLfloat offset = (1 - (self.death.value + self.hidden.value)) * (self.offset.value * 4) + ((self.death.value + self.hidden.value) * -5);
        
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
        [self.offset setValue:self.initialOffset + (pointTo.x - pointFrom.x) / -320.0 forTime:0.05 andThen:nil];
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
            if(!self.first && [self.currentKey isEqualToString:[self.menus.keys objectAtIndex:0]])
            {
                self.currentKey = nil;
            }
            else 
            {
                self.currentKey = [self.menus keyBefore:self.currentKey];
            }
        }
        else if(pointTo.x - pointFrom.x < -10)
        {
            self.currentKey = [self.menus keyAfter:self.currentKey];
        }

        [self updateOffset];
    }
}

@end

@implementation MenuController (Killable)

@dynamic isDead;
@dynamic isAlive;

-(BOOL)isAlive { return within(self.death.value, 0, 0.001) && self.death.endTime < CFAbsoluteTimeGetCurrent(); }
-(BOOL)isDead  { return within(self.death.value, 1, 0.001) && self.death.endTime < CFAbsoluteTimeGetCurrent(); }

-(void)killWithDisplayContainer:(DisplayContainer*)container key:(id)key andThen:(simpleBlock)work
{
    [self.death setValue:1 forTime:0.5 andThen:^{ [container pruneDeadForKey:key]; runLater(work); }];
    
    [container pruneLiveForKey:key];
}

@end
