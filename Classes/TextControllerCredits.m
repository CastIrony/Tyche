#import "GameControllerSP.h"
#import "GameRenderer.h"

#import "TextControllerCredits.h"

@implementation TextControllerCredits

@synthesize gameController = _gameController;
@synthesize showButton = _showButton;
@dynamic creditTotal;
@dynamic betTotal;

-(int)creditTotal { return _creditTotal; }
-(int)betTotal { return _betTotal; }

-(void)setCreditTotal:(int)creditTotal
{
    _creditTotal = creditTotal;
}

-(void)setBetTotal:(int)betTotal
{
    _betTotal = betTotal;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        Color3D labelColor = Color3DMake(1, 1, 1, 0.9); 
        
        [self.styles setObject:[NSNumber numberWithFloat:0.1]                                  forKey:@"fadeMargin"]; 
        [self.styles setObject:[NSNumber numberWithBool:YES]                                   forKey:@"hasShadow"];
        [self.styles setObject:[UIFont   fontWithName:@"Helvetica-Bold" size:25]               forKey:@"font"];
        [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(6, 0.75)]                  forKey:@"labelSize"];
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
        
        [label setObject:[NSString stringWithFormat:@"Credits: %d", self.creditTotal] forKey:@"textString"];          
        
        [label setObject:@"credits" forKey:@"key"]; 
        
        [labels addObject:label]; 
    }
    
    if(self.betTotal)
    {
        { 
            NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
            
            [label setObject:[NSString stringWithFormat:@"Bet: %d", self.betTotal] forKey:@"textString"];     
            [label setObject:[NSValue  valueWithCGSize:CGSizeMake(6, 0.65)] forKey:@"labelSize"];
            [label setObject:@"bet" forKey:@"key"]; 
            
            [labels addObject:label]; 
        }
        
        if(self.showButton)
        { 
            NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
            
            [label setObject:[NSNumber numberWithBool:YES]  forKey:@"hasBorder"];
            [label setObject:[NSNumber numberWithFloat:0.3] forKey:@"fadeMargin"]; 
            [label setObject:[NSValue  valueWithCGSize:CGSizeMake(3, 0.75)] forKey:@"labelSize"];
            [label setObject:@"cancel_bet" forKey:@"key"]; 
            [label setObject:@"CANCEL"     forKey:@"textString"];
            
            [labels addObject:label]; 
        }
    }
    else if(self.showButton)
    {
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:[NSNumber numberWithBool:YES]  forKey:@"hasBorder"];
        [label setObject:[NSNumber numberWithFloat:0.3] forKey:@"fadeMargin"]; 
        
        [label setObject:[NSValue  valueWithCGSize:CGSizeMake(3, 0.75)] forKey:@"labelSize"];
        
        [label setObject:@"cancel_bet" forKey:@"key"]; 
        [label setObject:@"ALL IN" forKey:@"textString"];
        
        [labels addObject:label]; 
    }
    
    [self fillWithDictionaries:labels];
}

@end
