#import "TextControllerStatusBar.h"

@implementation TextControllerStatusBar

@synthesize gameController = _gameController;
@synthesize text = _text;

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        Color3D labelColor = Color3DMake(1, 1, 1, 0.9); 
        
        [self.styles setObject:[NSNumber numberWithFloat:0.1]                                  forKey:@"fadeMargin"]; 
        [self.styles setObject:[NSNumber numberWithBool:YES]                                   forKey:@"hasShadow"];
        [self.styles setObject:[UIFont   fontWithName:@"Futura-Medium" size:30]               forKey:@"font"];
        [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(15, 0.96)]                  forKey:@"labelSize"];
        [self.styles setObject:[NSValue  valueWithBytes:&labelColor objCType:@encode(Color3D)] forKey:@"colorNormal"];
        [self.styles setObject:[NSValue  valueWithBytes:&labelColor objCType:@encode(Color3D)] forKey:@"colorTouched"];
        
        self.center = YES;
        self.padding = 0.2;
    }
    
    return self;
}

-(void)update
{
    NSMutableArray* labels = [[[NSMutableArray alloc] init] autorelease];
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:/*self.text*/@"Lorem ipsum dolor sit amet" forKey:@"textString"];          
        
        [label setObject:@"text" forKey:@"key"]; 
        
        [labels addObject:label]; 
    }    
    
    [self fillWithDictionaries:labels];
}


@end
