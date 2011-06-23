#import "NSArray+JBCommon.h"

#import "Common.h"
#import "AnimatedFloat.h"
#import "GLMenuController.h"
#import "GLMenuLayerController.h"
#import "GLRenderer.h"
#import "DisplayContainer.h"

@implementation GLMenuLayerController

@synthesize renderer = _renderer;
@synthesize menuLayers = _menuLayers;
@synthesize hidden = _hidden;

@dynamic currentLayer;

-(GLMenuController*)currentLayer
{
    return [self.menuLayers.liveObjects lastObject];
}

-(id)init
{
    self = [super init];
    
    if(self) 
    {
        self.menuLayers = [DisplayContainer container];
        
        self.hidden = [AnimatedFloat floatWithValue:0];
    }
    
    return self;
}

-(void)showMenus
{   
    [self.renderer.camera setMenuVisible:YES];
    
    [self.hidden setValue:0 forTime:1];
    
    [self.renderer.lightness setValue:0.4 forTime:1];
}

-(void)hideMenus
{    
    [self.renderer.camera setMenuVisible:NO];
    
    [self.hidden setValue:1 forTime:1]; 
    
    [self.renderer.lightness setValue:1 forTime:1];
}

-(void)pushMenuLayer:(GLMenuController*)menuLayer forKey:(NSString*)key
{
    menuLayer.owner = self;
    
    menuLayer.hidden = [AnimatedFloat floatWithValue:1];
    [menuLayer.hidden setValue:0 forTime:0.5];

    [self.currentLayer.collapsed setValue:1 forTime:0.5];
    [self.currentLayer layoutMenus];
    
    menuLayer.first = (self.menuLayers.liveObjects.count == 0);
    
    NSMutableArray* newKeys = [[self.menuLayers.liveKeys mutableCopy] autorelease];
    NSMutableDictionary* newDictionary = [[self.menuLayers.liveDictionary mutableCopy] autorelease];

    [newKeys removeObject:key];
    [newKeys addObject:key];
    
    [newDictionary setObject:menuLayer forKey:key];
    
    [self.menuLayers setLiveKeys:newKeys liveDictionary:newDictionary andThen:nil];
}

-(void)popUntilKey:(NSString*)target
{
    if(![self.menuLayers.liveKeys containsObject:target]) { return; }
     
    GLMenuController* currentLayer = (GLMenuController*)[self.menuLayers liveObjectForKey:target];
    
    for(NSString* key in self.menuLayers.liveKeys.reverseObjectEnumerator)
    {
        if([key isEqualToString:target]) { break; }
        
        GLMenuController* menuLayer = (GLMenuController*)[self.menuLayers liveObjectForKey:key];
        
        [menuLayer killWithDisplayContainer:self.menuLayers key:key andThen:^{ [currentLayer layoutMenus]; }];
    }
         
    [currentLayer.collapsed setValue:0 forTime:0.5 andThen:nil];
    [currentLayer layoutMenus];

}

-(void)cancelMenuLayer
{
    [self popUntilKey:[self.menuLayers.liveKeys objectBefore:[self.menuLayers.liveKeys lastObject]]];
}

-(void)draw
{
    if(within(self.hidden.value, 1, 0.001)) { return; }
    
    TRANSACTION_BEGIN
    {    
        glTranslatef(self.hidden.value * -15 , 0, 0);
        
        for(GLMenuController* layer in self.menuLayers.objects)
        {            
            [layer draw];
        }
    }
    TRANSACTION_END
}

@end

@implementation GLMenuLayerController (Touchable)

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    TRANSACTION_BEGIN
    {    
        glTranslatef(self.hidden.value * -15, 0, 0);
            
        for(GLMenuController* layer in self.menuLayers.liveObjects)
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