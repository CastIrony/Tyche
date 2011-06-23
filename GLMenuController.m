#import "NSArray+JBCommon.h"
#import "GLMenuLayerController.h"
#import "GLRenderer.h"
#import "AnimatedFloat.h"
#import "AnimatedVec3.h"
#import "GLMenu.h"
#import "GLTextController.h"
#import "GLText.h"
#import "GLDots.h"
#import "DisplayContainer.h"

#import "GLMenuController.h"

@implementation GLMenuController

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
@synthesize key              = _key;
@synthesize displayContainer = _displayContainer;

-(id)initWithRenderer:(GLRenderer*)renderer
{
    self = [super init];
    
    if(self) 
    {
        self.renderer = renderer;
        
        self.menus = [DisplayContainer container];
        
        self.offset    = [AnimatedFloat floatWithValue:0];
        self.hidden    = [AnimatedFloat floatWithValue:0];
        self.death     = [AnimatedFloat floatWithValue:0];
        self.collapsed = [AnimatedFloat floatWithValue:0];
    }
    
    return self;
}

+(GLMenuController*)withRenderer:(GLRenderer *)renderer
{
    return [[[self alloc] initWithRenderer:renderer] autorelease];
}

-(void)addMenu:(GLMenu*)menu forKey:(NSString*)key
{
    menu.owner = self;
    
    NSMutableArray* newKeys = [[self.menus.liveKeys mutableCopy] autorelease];
    NSMutableDictionary* newDictionary = [[self.menus.liveDictionary mutableCopy] autorelease];

    [newKeys removeObject:key];
    [newKeys addObject:key];
    
    [newDictionary setObject:menu forKey:key];
    
    [self.menus setLiveKeys:newKeys liveDictionary:newDictionary andThen:nil];

    if(!self.currentKey) { self.currentKey = key; }
    
    [self layoutMenus];
}

-(void)deleteMenuForKey:(NSString*)key
{
    NSMutableArray* newKeys = [[self.menus.liveKeys mutableCopy] autorelease];

    [newKeys removeObject:key];
    
    [self.menus setLiveKeys:newKeys liveDictionary:self.menus.liveDictionary andThen:nil];

    [self layoutMenus];
}

-(void)updateOffset
{
    if(self.currentKey)
    {
        int currentIndex = [self.menus.keys indexOfObject:self.currentKey];
        
        if(currentIndex != NSNotFound)
        {
            [self.offset setValue:currentIndex forTime:0.3 andThen:nil];
        }
    }
    else if(self.isAlive) 
    {
        [self.offset setValue:-1 forTime:0.3 andThen:nil];
        
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
        GLMenu* menu = (GLMenu*)[self.menus liveObjectForKey:key];
        
        if(menu.location)
        {
            [menu.location setValue:-4.0 * counter forTime:1.0 andThen:nil];
        }
        else 
        {
            menu.location = [AnimatedFloat floatWithValue:-4.0 * counter];
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
                self.currentKey = [self.menus.keys objectBefore:self.currentKey];
            }
        }
        else if(pointTo.x - pointFrom.x < -10)
        {
            self.currentKey = [self.menus.keys objectAfter:self.currentKey];
        }

        [self updateOffset];
    }
}

-(BOOL)isAlive { return within(self.death.endValue, 0, 0.001); }
-(BOOL)isDead  { return within(self.death.value,    1, 0.001); }

-(void)dieAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work
{
    [self.death setValue:1 forTime:0.3 afterDelay:delay andThen:work];
}

@end
