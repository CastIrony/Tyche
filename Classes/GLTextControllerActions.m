#import "GLRenderer.h"

#import "GLTextControllerActions.h"

@implementation GLTextControllerActions

@synthesize gameController = _gameController;

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        color labelColor = colorMake(1, 1, 1, 0.9); 
        
        [self.styles setObject:[NSNumber numberWithBool:YES]                                 forKey:@"hasShadow"];
        [self.styles setObject:[UIFont   fontWithName:@"Futura-Medium" size:25]              forKey:@"font"];
        [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(3, 0.9)]                 forKey:@"labelSize"];
        [self.styles setObject:[NSValue  valueWithBytes:&labelColor objCType:@encode(color)] forKey:@"colorNormal"];
        [self.styles setObject:[NSValue  valueWithBytes:&labelColor objCType:@encode(color)] forKey:@"colorTouched"];
        [self.styles setObject:[NSNumber numberWithBool:YES]                                 forKey:@"hasBorder"];
        [self.styles setObject:[NSNumber numberWithFloat:0.3]                                forKey:@"fadeMargin"]; 
        [self.styles setObject:[NSNumber numberWithFloat:0.2]                                forKey:@"topMargin"]; 
        [self.styles setObject:[NSNumber numberWithFloat:0.2]                                forKey:@"bottomMargin"]; 
                
        self.center = YES;
    }
    
    return self;
}

@end
