#import "GameRenderer.h"
#import "MenuController.h"
#import "MenuLayerController.h"
#import "TextControllerServerInfo.h"
#import "NSArray+Circle.h"

@implementation TextControllerServerInfo

@synthesize serverName = _serverName;
@synthesize serverIcon = _serverIcon;

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
    Color3D colorNormal      = Color3DMake(0.5, 0.0, 0, 0.75); 
    Color3D colorTouched     = Color3DMake(0.0, 0.0, 0, 0.75); 
    
    [self.styles setObject:[UIFont   fontWithName:@"Futura-Medium" size:20]                      forKey:@"font"];
    [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(3.75, 0.42)]                      forKey:@"labelSize"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(Color3D)] forKey:@"colorNormal"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(Color3D)] forKey:@"colorTouched"];
    [self.styles setObject:[NSNumber numberWithBool:NO]   forKey:@"hasShadow"]; 
    [self.styles setObject:[NSNumber numberWithFloat:0.0] forKey:@"fadeMargin"]; 
    [self.styles setObject:[NSNumber numberWithFloat:0.4] forKey:@"topMargin"]; 
    [self.styles setObject:[NSNumber numberWithFloat:0.4] forKey:@"bottomMargin"]; 

    NSMutableArray* labels = [[[NSMutableArray alloc] init] autorelease];
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"delete" forKey:@"key"]; 
        [label setObject:@"Join Game" forKey:@"textString"];
        [label setObject:[UIFont fontWithName:@"Futura-Medium" size:30] forKey:@"font"];
        [label setObject:[NSValue  valueWithBytes:&colorNormal  objCType:@encode(Color3D)] forKey:@"colorNormal"];
        [label setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(Color3D)] forKey:@"colorTouched"];
        [label setObject:[NSValue valueWithCGSize:CGSizeMake(3.5, 0.84)] forKey:@"labelSize"];

        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"title2" forKey:@"key"]; 
        [label setObject:self.serverName forKey:@"textString"];     
        
        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"collapse" forKey:@"key"]; 
        [label setObject:self.serverIcon forKey:@"textString"]; 
        [label setObject:[UIFont fontWithName:@"Futura-Medium" size:150] forKey:@"font"];
        [label setObject:[NSValue valueWithCGSize:CGSizeMake(3, 2.5)] forKey:@"labelSize"];

        [labels addObject:label]; 
    }
        
    [self fillWithDictionaries:labels];
}

@end