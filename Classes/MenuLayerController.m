#import "NSArray+Circle.h"

#import "Common.h"
#import "AnimatedFloat.h"
#import "MenuController.h"
#import "MenuLayerController.h"
#import "GameRenderer.h"
#import "DisplayContainer.h"

@implementation MenuLayerController

@synthesize renderer = _renderer;
@synthesize menuLayers = _menuLayers;
@synthesize hidden = _hidden;

@dynamic currentLayer;

-(MenuController*)currentLayer
{
    return [self.menuLayers.liveObjects lastObject];
}

-(id)init
{
    self = [super init];
    
    if(self) 
    {
        self.menuLayers = [DisplayContainer container];
        self.hidden = [AnimatedFloat withValue:0];
    }
    
    return self;
}

-(void)pushMenu:(MenuController*)menu forKey:(NSString*)key
{
    menu.owner = self;
    
    menu.death = [AnimatedFloat withStartValue:1 endValue:0 speed:1];
    menu.death.curve = AnimationEaseInOut;

    //self.currentLayer.collapsed = [AnimatedFloat withStartValue:self.currentLayer.collapsed.value endValue:1 speed:1];
    
    [self.menuLayers insertObject:menu asLastWithKey:key];
}

-(void)popUntilKey:(NSString*)target
{
    if(![self.menuLayers.liveKeys containsObject:key]) { return; }
    
    //self.currentLayer.collapsed = [AnimatedFloat withStartValue:self.currentLayer.collapsed.value endValue:1 speed:1];
    
    for(NSString* key in self.menuLayers.liveKeys.reverseObjectEnumerator)
    {
        if([key isEqualToString:target]) { break; }
                
        
        MenuController* menu = [self.menus liveObjectForKey:key];
        
        menu.death = [AnimatedFloat withStartValue:menu.death.value endValue:1 speed:1];
        
        menu.death.onStart = ^{ [self.menus pruneLiveForKey:key]; };    
        menu.death.onEnd   = ^{ [self.menus pruneDeadForKey:key]; };
        
        menu.death.curve = AnimationEaseInOut;
    }
}

-(void)cancelMenuLayer
{
    NSString* key = [self.menuLayerKeys objectBefore:[self.menuLayerKeys lastObject]];
    
    if([key isEqualToString:[self.menuLayerKeys lastObject]]) { return; }
    
    [self popUntilKey:key];
}

-(void)draw
{
    if(within(self.hidden.value, 1, 0.001)) { return; }
    
    TRANSACTION_BEGIN
    {    
        glTranslatef(self.hidden.value * -15 , 0, 0);
        
        for(NSString* key in self.menuLayerKeys)
        {
            MenuController* layer = [self.menuLayers objectForKey:key];
            
            [layer draw];
        }
    }
    TRANSACTION_END
}

@end

@implementation MenuLayerController (Touchable)

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    TRANSACTION_BEGIN
    {    
        glTranslatef(self.hidden.value * -15, 0, 0);
            
        for(NSString* key in self.menuLayerKeys)
        {
            MenuController* layer = [self.menuLayers objectForKey:key];
            
            if(layer && within(layer.hidden.value, 0, 0.001) && within(layer.collapsed.value, 0, 0.001))
            {
                object = [layer testTouch:touch withPreviousObject:object];
            }
        }
    }
    TRANSACTION_END
    
   return object;
}

-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point
{

}

-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    
}

-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    
}

@end