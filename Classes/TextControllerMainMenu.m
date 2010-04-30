#import "NSArray+Circle.h"

#import "GameRenderer.h"
#import "MenuLayerController.h"
#import "Texture2D.h"

#import "TextControllerMainMenu.h"

@implementation TextControllerMainMenu

@synthesize appController = _appController;
@synthesize textureLogo   = _textureLogo;

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        self.padding = 0.4;
        self.center = NO;
    }
    
    return self;
}

-(void)update
{
    Color3D colorNormal      = Color3DMake(0.8,   0, 0, 0.8); 
    Color3D colorTouched     = Color3DMake(0,   0.8, 0, 0.8); 
    
    [self.styles setObject:[NSNumber numberWithFloat:0.0]                                         forKey:@"fadeMargin"]; 
    [self.styles setObject:[UIFont   fontWithName:@"Helvetica-Bold" size:20]                      forKey:@"font"];
    [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(3.75, 0.35)]                      forKey:@"labelSize"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorNormal  objCType:@encode(Color3D)] forKey:@"colorNormal"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(Color3D)] forKey:@"colorTouched"];

    [self.styles setObject:[NSNumber numberWithFloat:0.2] forKey:@"fadeMargin"]; 

    NSMutableArray* labels = [[[NSMutableArray alloc] init] autorelease];
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease];
        
        [label setObject:[[[Texture2D alloc] initWithImageFile:@"logo.png"] autorelease]           forKey:@"textureText"]; 
        [label setObject:@"Join Game"        forKey:@"textString"];          
        [label setObject:[NSValue valueWithCGSize:CGSizeMake(181, 109)]                            forKey:@"textSize"]; 
        [label setObject:[NSValue valueWithCGSize:CGSizeMake(3.75, 1.4)]                            forKey:@"labelSize"];
        
        [label setObject:@"logo" forKey:@"key"]; 
        
        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"join_multiplayer" forKey:@"key"]; 
        [label setObject:@"Join Game"        forKey:@"textString"];          
        
        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"new_multiplayer" forKey:@"key"]; 
        [label setObject:@"Start New Game"  forKey:@"textString"];     
        
        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"new_game"            forKey:@"key"]; 
        [label setObject:@"Start Single Player" forKey:@"textString"]; 
        
        [labels addObject:label]; 
    }

    [(NSMutableDictionary*)[labels objectAtIndex:1] setObject:[UIFont  fontWithName:@"Helvetica-Bold" size:35] forKey:@"font"];
    [(NSMutableDictionary*)[labels objectAtIndex:1] setObject:[NSValue valueWithCGSize:CGSizeMake(3.75, 0.5)]  forKey:@"labelSize"];
    
    [self fillWithDictionaries:labels];
}

-(void)labelTouchedWithKey:(NSString*)key
{
    if([key isEqualToString:@"join_multiplayer"]) 
    {
        [self.renderer.menuLayerController setCurrentKey:[self.renderer.menuLayerController.menuLayerKeys objectAfter:self.renderer.menuLayerController.currentKey]];
    }
    
    //[self.renderer.appController labelTouchedWithKey:key];
}

-(void)draw
{
    [super draw];
}

@end
