#import "NSArray+Circle.h"

#import "Common.h"
#import "AnimatedFloat.h"
#import "MenuController.h"
#import "MenuLayerController.h"
#import "GameRenderer.h"

@implementation MenuLayerController

@synthesize renderer = _renderer;
@synthesize menuLayerKeys = _menuLayerKeys;
@synthesize menuLayers = _menuLayers;
@synthesize currentKey = _currentKey;
@synthesize hidden = _hidden;

@dynamic currentLayer;

-(MenuController*)currentLayer
{
    return [self.menuLayers objectForKey:self.currentKey];
}

-(id)init
{
    self = [super init];
    
    if(self) 
    {
        self.menuLayerKeys = [[[NSMutableArray alloc] init] autorelease];
        self.menuLayers = [[[NSMutableDictionary alloc] init] autorelease];
        self.hidden = [AnimatedFloat withValue:0];
    }
    
    return self;
}

-(void)setKey:(NSString*)currentKey
{
    if(![self.menuLayerKeys containsObject:currentKey]) { return; }
    
    self.currentKey = currentKey;
    
    BOOL found = NO;
    
    for(NSString* key in self.menuLayerKeys) 
    {
        MenuController* layer = [self.menuLayers objectForKey:key];
        
        BOOL collapsed;
        BOOL hidden;
        
        if([key isEqualToString:currentKey]) 
        {
            found = YES;
            
            collapsed = NO;
            hidden    = NO;
        }
        else if(found)
        {
            collapsed = NO;
            hidden    = YES;
        }
        else 
        {
            collapsed = YES;
            hidden    = NO;
        }
        
        layer.collapsed = self.renderer.animated ? [AnimatedFloat withStartValue:layer.collapsed.value endValue:collapsed forTime:1] : [AnimatedFloat withValue:collapsed];
        layer.hidden = self.renderer.animated ? [AnimatedFloat withStartValue:layer.hidden.value endValue:hidden forTime:1] : [AnimatedFloat withValue:hidden];
    
        [layer layoutMenus];
    }
}   

-(void)addMenuLayer:(MenuController*)layer forKey:(NSString*)key
{
    [self.menuLayers setObject:layer forKey:key];
    [self.menuLayerKeys addObject:key];
    
    layer.owner = self;
}

-(void)removeMenuLayerForKey:(NSString*)key
{
    [self.menuLayerKeys removeObject:key];
    [self.menuLayers removeObjectForKey:key];
}

-(void)cancelMenuLayer;
{
    [self setCurrentKey:[self.menuLayerKeys objectBefore:self.currentKey]];
}

-(void)draw
{
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