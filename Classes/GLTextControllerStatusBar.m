#import "GLTextControllerStatusBar.h"

@implementation GLTextControllerStatusBar

@synthesize gameController = _gameController;
@synthesize text = _text;

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        color labelColor = colorMake(1, 1, 1, 0.9); 
        
        [self.styles setObject:[NSNumber numberWithFloat:0.1]                                  forKey:@"fadeMargin"]; 
        [self.styles setObject:[NSNumber numberWithBool:YES]                                   forKey:@"hasShadow"];
        [self.styles setObject:[UIFont   fontWithName:@"Futura-Medium" size:30]               forKey:@"font"];
        [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(15, 0.96)]                  forKey:@"labelSize"];
        [self.styles setObject:[NSValue  valueWithBytes:&labelColor objCType:@encode(color)] forKey:@"colorNormal"];
        [self.styles setObject:[NSValue  valueWithBytes:&labelColor objCType:@encode(color)] forKey:@"colorTouched"];
        [self.styles setObject:[NSNumber numberWithFloat:0.2] forKey:@"topMargin"]; 
        [self.styles setObject:[NSNumber numberWithFloat:0.2] forKey:@"bottomMargin"]; 
        
        self.center = YES;
    }
    
    return self;
}

-(void)update
{
    NSMutableArray* labels = [NSMutableArray array];
    
    { 
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:self.text forKey:@"textString"];          
        
        [label setObject:@"text" forKey:@"key"]; 
        
        [labels addObject:label]; 
    }    
    
    [self fillWithDictionaries:labels];
}


@end
