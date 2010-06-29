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
        self.menuLayers.alive = [NSPredicate predicateWithFormat:@"isAlive = YES"];
        self.menuLayers.dead  = [NSPredicate predicateWithFormat:@"isDead  = YES"];
        
        self.hidden = [AnimatedFloat withValue:0];
    }
    
    return self;
}

-(void)pushMenuLayer:(MenuController*)menuLayer forKey:(NSString*)key
{
    menuLayer.owner = self;
    
    menuLayer.hidden = [AnimatedFloat withStartValue:1 endValue:0 speed:1];
    menuLayer.hidden.curve = AnimationEaseInOut;

    self.currentLayer.collapsed = [AnimatedFloat withStartValue:self.currentLayer.collapsed.value endValue:1 speed:1];
    
    [self.menuLayers insertObject:menuLayer asLastWithKey:key];
}

-(void)popUntilKey:(NSString*)target
{
    if(![self.menuLayers.liveKeys containsObject:target]) { return; }
        
    for(NSString* key in self.menuLayers.liveKeys.reverseObjectEnumerator)
    {
        if([key isEqualToString:target]) { break; }
        
        MenuController* menuLayer = [self.menuLayers liveObjectForKey:key];
        
        menuLayer.death = [AnimatedFloat withStartValue:menuLayer.death.value endValue:1 speed:1];
        
        menuLayer.death.onStart = ^{ [self.menuLayers pruneLiveForKey:key]; };    
        menuLayer.death.onEnd   = ^{ [self.menuLayers pruneDeadForKey:key]; };
        
        menuLayer.death.curve = AnimationEaseInOut;
    }
     
    MenuController* currentLayer = [self.menuLayers liveObjectForKey:target];
    
    currentLayer.collapsed = [AnimatedFloat withStartValue:currentLayer.collapsed.value endValue:0 speed:1];
}

-(void)cancelMenuLayer
{
    [self popUntilKey:[self.menuLayers liveKeyBefore:[self.menuLayers.liveKeys lastObject]]];
}

-(void)draw
{
    if(within(self.hidden.value, 1, 0.001)) { return; }
    
    TRANSACTION_BEGIN
    {    
        glTranslatef(self.hidden.value * -15 , 0, 0);
        
        for(MenuController* layer in self.menuLayers.objects)
        {            
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
            
        for(MenuController* layer in self.menuLayers.liveObjects)
        {
            if(layer && within(layer.collapsed.value, 0, 0.001))
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