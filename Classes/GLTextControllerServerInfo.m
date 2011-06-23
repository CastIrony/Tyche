#import "GLRenderer.h"
#import "GLMenuController.h"
#import "GLMenuLayerController.h"
#import "GLTextControllerServerInfo.h"
#import "NSArray+JBCommon.h"

@implementation GLTextControllerServerInfo

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
    color colorNormal      = colorMake(0.5, 0.0, 0, 0.75); 
    color colorTouched     = colorMake(0.0, 0.0, 0, 0.75); 
    
    [self.styles setObject:[UIFont   fontWithName:@"Futura-Medium" size:20]                      forKey:@"font"];
    [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(3.75, 0.42)]                      forKey:@"labelSize"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(color)] forKey:@"colorNormal"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(color)] forKey:@"colorTouched"];
    [self.styles setObject:[NSNumber numberWithBool:NO]   forKey:@"hasShadow"]; 
    [self.styles setObject:[NSNumber numberWithFloat:0.0] forKey:@"fadeMargin"]; 
    [self.styles setObject:[NSNumber numberWithFloat:0.4] forKey:@"topMargin"]; 
    [self.styles setObject:[NSNumber numberWithFloat:0.4] forKey:@"bottomMargin"]; 

    NSMutableArray* labels = [NSMutableArray array];
    
    { 
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:@"delete" forKey:@"key"]; 
        [label setObject:@"Join Game" forKey:@"textString"];
        [label setObject:[UIFont fontWithName:@"Futura-Medium" size:30] forKey:@"font"];
        [label setObject:[NSValue  valueWithBytes:&colorNormal  objCType:@encode(color)] forKey:@"colorNormal"];
        [label setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(color)] forKey:@"colorTouched"];
        [label setObject:[NSValue valueWithCGSize:CGSizeMake(3.5, 0.84)] forKey:@"labelSize"];

        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:@"title2" forKey:@"key"]; 
        [label setObject:self.serverName forKey:@"textString"];     
        
        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:@"collapse" forKey:@"key"]; 
        [label setObject:self.serverIcon forKey:@"textString"]; 
        [label setObject:[UIFont fontWithName:@"Futura-Medium" size:150] forKey:@"font"];
        [label setObject:[NSValue valueWithCGSize:CGSizeMake(3, 2.5)] forKey:@"labelSize"];

        [labels addObject:label]; 
    }
        
    [self fillWithDictionaries:labels];
}

@end