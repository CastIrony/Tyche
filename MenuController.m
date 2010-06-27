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

//@synthesize liveMenuKeys  = _liveMenuKeys;
//@synthesize allMenuKeys   = _allMenuKeys;
@synthesize menus         = _menus;

@synthesize offset        = _offset;
@synthesize initialOffset = _initialOffset;
//@synthesize currentIndex  = _currentIndex;
@synthesize currentKey    = _currentKey;
@synthesize collapsed     = _collapsed;
@synthesize hidden        = _hidden;
@synthesize owner         = _owner;

-(id)initWithRenderer:(GameRenderer*)renderer
{
    self = [super init];
    
    if(self) 
    {
        self.renderer = renderer;
        
//        self.liveMenuKeys = [[[NSMutableArray alloc] init] autorelease];
//        self.allMenuKeys = [[[NSMutableArray alloc] init] autorelease];
        self.menus = [DisplayContainer container];
        self.offset = [AnimatedFloat withValue:0];
        
        self.hidden = [AnimatedFloat withValue:0];
        self.collapsed = [AnimatedFloat withValue:0];
    }
    
    return self;
}

+(MenuController*)withRenderer:(GameRenderer *)renderer
{
    return [[[self alloc] initWithRenderer:renderer] autorelease];
}

-(void)addMenu:(GLMenu*)menu forKey:(NSString*)key
{
    menu.owner = self;
    
    [self.menus insertObject:menu asLastWithKey:key];
    
    [self layoutMenus];
}

-(void)deleteMenuForKey:(NSString*)key
{
//    TODO: fix this method
//
//    GLMenu* menu = [self.menus objectForKey:key];
//    
//    if(menu)
//    {
//        [self.liveMenuKeys removeObject:key];
//
//        if(self.renderer.animated)
//        {
//            menu.location = [AnimatedVector3D withStartValue:menu.location.value endValue:Vector3DMake(menu.location.value.x, menu.location.value.y, menu.location.value.z - 20) forTime:1.0];
//            menu.location.curve = AnimationEaseInOut;
//        }
//        
//        [self layoutMenus];
//    }
}

-(void)layoutMenus
{
    BOOL collapsed = _collapsed.endValue > 0.5;
    
    NSArray* liveMenus = self.menus.topObjects;
    
    //int currentIndex = [self.menus.keys indexOfObject:self.currentKey];
    
    if(liveMenus.count == 0) { return; }
    
    int counter = collapsed ?  : 0;
      
    for(NSString* key in self.menus.keys)
    {
        GLMenu* menu = [self.menus topObjectForKey:key];
        
        BOOL visible = !collapsed || key == self.currentKey;
        
        if(self.renderer.animated)
        {
            menu.opacity = [AnimatedFloat withStartValue:menu.opacity.value endValue:visible forTime:1.0];
            menu.opacity.curve = AnimationEaseInOut;

            menu.location = [AnimatedVector3D withStartValue:menu.location.value endValue:Vector3DMake(-4 * counter, 0, 0) forTime:1.0];
            menu.location.curve = AnimationEaseInOut;
        }
        else 
        {
            menu.opacity = [AnimatedFloat withValue:visible];
            
            menu.location = [AnimatedVector3D withValue:Vector3DMake(-4 * counter, 0, 0)];
        }

        [menu.dots setDots:liveMenus.count current:counter];
        
        if(!collapsed) 
        { 
            counter++; 
        } 
    }
        
    if([self.liveMenuKeys containsObject:self.currentKey])
    {
        self.currentIndex = clipInt([self.liveMenuKeys indexOfObject:self.currentKey], 0, self.liveMenuKeys.count - 1);
    }    
    else 
    {
        self.currentIndex = clipInt(self.currentIndex, 0, self.liveMenuKeys.count - 1);
        self.currentKey = [self.liveMenuKeys objectAtIndex:self.currentIndex];
    }
    
    if(self.currentIndex >= 0)
    {
        if(self.renderer.animated)
        {
            self.offset = [AnimatedFloat withStartValue:self.offset.value endValue:self.currentIndex speed:2.0];
            self.offset.curve = AnimationEaseInOut;
        }
        else
        {
            self.offset = [AnimatedFloat withValue:self.currentIndex];
        }
    }
}

-(void)draw
{    
    TRANSACTION_BEGIN
    {   
        GLfloat offset = (1 - self.hidden.value) * (self.offset.value * 4) + (self.hidden.value * -15);
        
        glTranslatef(offset, 0, 0);
                
        for(NSString* key in self.allMenuKeys)
        {
//            if(key == [self.allMenuKeys objectBefore:self.currentKey] || key == [self.allMenuKeys objectAfter:self.currentKey])
//            {
                GLMenu* menu = [self.menus objectForKey:key];
                
                menu.angleSin = 7.5 * sin(2 * self.offset.value + 2 * menu.angleJitter);
                
                menu.lightness = 1 - self.collapsed.value * 0.5;
                
                [menu reset];
                [menu draw];
//            }
        }
        
//        GLMenu* menu = [self.menus objectForKey:self.currentKey];
//        
//        menu.angleSin = 7.5 * sin(2 * self.offset.value + 2 * menu.angleJitter);
//
//        menu.lightness = 1 - self.collapsed.value * 0.5;
//        
//        [menu reset];
//        [menu draw];
    }
    TRANSACTION_END
    
    if(self.liveMenuKeys.count == 0)
    {
        [self.owner cancelMenuLayer];
    }
}

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    TRANSACTION_BEGIN
    {
        glTranslatef(self.offset.value * 4, 0, 0);
        
        for(NSString* key in self.allMenuKeys)
        {
            GLMenu* menu = [self.menus objectForKey:key];
            
            if(menu)
            {
                object = [menu testTouch:touch withPreviousObject:object];
            }
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
        int newIndex = self.currentIndex;
        
        if(pointTo.x - pointFrom.x > 10)
        {
            newIndex--;
        }
        else if(pointTo.x - pointFrom.x < -10)
        {
            newIndex++;
        }

        self.currentIndex = clipInt(newIndex, -1, self.liveMenuKeys.count - 1);
        self.currentKey = (self.currentIndex == -1) ? nil : [self.liveMenuKeys objectAtIndex:self.currentIndex];

        self.offset = [AnimatedFloat withStartValue:self.offset.value endValue:self.currentIndex speed:2.0];
        self.offset.curve = AnimationEaseInOut;

        if(newIndex < 0)
        {
            [self.owner cancelMenuLayer];
        }
    }
}

@end
