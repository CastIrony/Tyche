#import "NSArray+JBCommon.h"

#import "GLRenderer.h"
#import "GLMenuLayerController.h"
#import "GLTexture.h"

#import "GLTextControllerMainMenu.h"

@implementation GLTextControllerMainMenu

@synthesize appController = _appController;

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        self.center = NO;
    }
    
    return self;
}

-(void)update
{
    color colorNormal      = colorMake(0.8,   0, 0, 0.8); 
    color colorTouched     = colorMake(0.4,   0, 0, 0.8); 
    
    [self.styles setObject:[NSNumber numberWithFloat:0.0]                                    forKey:@"fadeMargin"]; 
    [self.styles setObject:[UIFont   fontWithName:@"Futura-Medium" size:30]                  forKey:@"font"];
    [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(3.75, 0.42)]                 forKey:@"labelSize"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorNormal  objCType:@encode(color)] forKey:@"colorNormal"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(color)] forKey:@"colorTouched"];
    [self.styles setObject:[NSNumber numberWithFloat:0.2] forKey:@"fadeMargin"]; 
    [self.styles setObject:[NSNumber numberWithFloat:0.4] forKey:@"topMargin"]; 
    [self.styles setObject:[NSNumber numberWithFloat:0.4] forKey:@"bottomMargin"]; 

    NSMutableArray* labels = [NSMutableArray array];
    
    { 
        NSMutableDictionary* label = [NSMutableDictionary dictionary];
        
        [label setObject:[[[GLTexture alloc] initWithImageFile:@"logo.png"] autorelease]           forKey:@"textureText"]; 
        
        [label setObject:@"Studly"        forKey:@"textString"];          
        [label setObject:[NSValue valueWithCGSize:CGSizeMake(3.75, 2)]                            forKey:@"labelSize"];
        [label setObject:[NSNumber numberWithFloat:0.05] forKey:@"topMargin"]; 
        [label setObject:[NSNumber numberWithFloat:0.0] forKey:@"bottomMargin"]; 
        [label setObject:[NSNumber numberWithFloat:-0.4] forKey:@"bottomPadding"]; 

        [label setObject:@"logo" forKey:@"key"]; 
        
        [labels addObject:label];
    }
    
    { 
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:@"join_multiplayer" forKey:@"key"]; 
        [label setObject:@"Join Game"        forKey:@"textString"];          
        
        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:@"new_multiplayer" forKey:@"key"]; 
        [label setObject:@"Start New Game"  forKey:@"textString"];     
        
        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:@"new_game"            forKey:@"key"]; 
        [label setObject:@"Start Single Player" forKey:@"textString"]; 
        
        [labels addObject:label]; 
    }

    [(NSMutableDictionary*)[labels objectAtIndex:1] setObject:[UIFont  fontWithName:@"Futura-Medium" size:50] forKey:@"font"];
    [(NSMutableDictionary*)[labels objectAtIndex:1] setObject:[NSValue valueWithCGSize:CGSizeMake(3.75, 0.6)]  forKey:@"labelSize"];
    
    [self fillWithDictionaries:labels];
}

-(void)draw
{
    [super draw];
}

@end
