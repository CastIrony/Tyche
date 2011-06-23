#import "GameController.h"
#import "GLRenderer.h"

#import "GLTextControllerCredits.h"

@implementation GLTextControllerCredits

@synthesize gameController = _gameController;
@synthesize showButton     = _showButton;
@synthesize creditTotal    = _creditTotal;
@synthesize betTotal       = _betTotal;

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        color labelColor = colorMake(1, 1, 1, 0.9); 
        
        [self.styles setObject:[NSNumber numberWithFloat:0.1]                                  forKey:@"fadeMargin"]; 
        [self.styles setObject:[NSNumber numberWithBool:YES]                                   forKey:@"hasShadow"];
        [self.styles setObject:[UIFont   fontWithName:@"Futura-Medium" size:25]                forKey:@"font"];
        [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(6, 0.9)]                   forKey:@"labelSize"];
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

    if(self.creditTotal > 0)
    {
        { 
            NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
            
            [label setObject:[NSString stringWithFormat:@"Credits: %d", self.creditTotal] forKey:@"textString"];          
            
            [label setObject:@"credits" forKey:@"key"]; 
            
            [labels addObject:label]; 
        }

        if(self.betTotal > 0)
        {
            { 
                NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
                
                [label setObject:[NSString stringWithFormat:@"Bet: %d", self.betTotal] forKey:@"textString"];     
                [label setObject:[NSValue  valueWithCGSize:CGSizeMake(6, 0.78)] forKey:@"labelSize"];
                [label setObject:@"bet" forKey:@"key"]; 
                
                [labels addObject:label]; 
            }
            
            if(self.showButton)
            { 
                NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
                
                [label setObject:[NSNumber numberWithBool:YES]  forKey:@"hasBorder"];
                [label setObject:[NSNumber numberWithFloat:0.3] forKey:@"fadeMargin"]; 
                [label setObject:[NSValue  valueWithCGSize:CGSizeMake(3, 0.9)] forKey:@"labelSize"];
                [label setObject:@"cancel_bet" forKey:@"key"]; 
                [label setObject:@"CANCEL"     forKey:@"textString"];
                
                [labels addObject:label]; 
            }
        }
        else if(self.showButton)
        {
            NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
            
            [label setObject:[NSNumber numberWithBool:YES]  forKey:@"hasBorder"];
            [label setObject:[NSNumber numberWithFloat:0.3] forKey:@"fadeMargin"]; 
            
            [label setObject:[NSValue  valueWithCGSize:CGSizeMake(3, 0.9)] forKey:@"labelSize"];
            
            [label setObject:@"cancel_bet" forKey:@"key"]; 
            [label setObject:@"ALL IN" forKey:@"textString"];
            
            [labels addObject:label]; 
        }
    }
    [self fillWithDictionaries:labels];
}

@end
