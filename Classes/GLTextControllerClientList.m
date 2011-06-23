#import "GLRenderer.h"
#import "GLMenuLayerController.h"

#import "GLTextControllerClientList.h"

@implementation GLTextControllerClientList

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        self.center = YES;
    }
    
    return self;
}

-(void)update
{
    color colorNormal      = colorMake(0.8, 0, 0, 0.9); 
    color colorTouched     = colorMake(0,   0, 0, 0.9); 
    //color labelColorTransparent = colorMake(1,   1, 1, 0.9); 
    
    [self.styles setObject:[NSNumber numberWithFloat:0.1]                                    forKey:@"fadeMargin"]; 
    [self.styles setObject:[UIFont   fontWithName:@"Futura-Medium" size:20]                 forKey:@"font"];
    [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(3, 0.42)]                    forKey:@"labelSize"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorNormal  objCType:@encode(color)] forKey:@"colorNormal"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(color)] forKey:@"colorTouched"];
    [self.styles setObject:[NSNumber numberWithFloat:0.4] forKey:@"topMargin"]; 
    [self.styles setObject:[NSNumber numberWithFloat:0.4] forKey:@"bottomMargin"]; 
    
    NSMutableArray* labels = [NSMutableArray array];
    
    { 
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:@"join_multiplayer" forKey:@"key"]; 
        [label setObject:@"Connecting..."    forKey:@"textString"];          
        [label setObject:[NSValue  valueWithBytes:&colorTouched  objCType:@encode(color)] forKey:@"colorNormal"];
        
        [labels addObject:label]; 
    }
    
    { 
        //☐☑☒✖
                
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:@"new_multiplayer" forKey:@"key"]; 
        [label setObject:@"Joel's asddasdsasadsdsdsad iPhone"   forKey:@"textString"];     
        [label setObject:@" ☐ "             forKey:@"bulletLeftString"];
        [label setObject:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];

        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:@"new_game"    forKey:@"key"]; 
        [label setObject:@"John's iPod" forKey:@"textString"]; 
        [label setObject:@" ☑ "         forKey:@"bulletLeftString"];
        [label setObject:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];

        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:@"calibrate"    forKey:@"key"]; 
        [label setObject:@"Jim's iPhone" forKey:@"textString"]; 
        [label setObject:@" ☒ "          forKey:@"bulletLeftString"];
        [label setObject:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];

        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:@"start"      forKey:@"key"]; 
        [label setObject:@"Start Game" forKey:@"textString"];          
        
        [labels addObject:label]; 
    }
    
    
    [(NSMutableDictionary*)[labels objectAtIndex:0] setObject:[UIFont  fontWithName:@"Futura-Medium" size:35] forKey:@"font"];
    [(NSMutableDictionary*)[labels objectAtIndex:0] setObject:[NSValue valueWithCGSize:CGSizeMake(3.75, 0.6)]  forKey:@"labelSize"];
    [(NSMutableDictionary*)[labels objectAtIndex:4] setObject:[UIFont  fontWithName:@"Futura-Medium" size:35] forKey:@"font"];
    [(NSMutableDictionary*)[labels objectAtIndex:4] setObject:[NSValue valueWithCGSize:CGSizeMake(3.75, 0.6)]  forKey:@"labelSize"];
    
    [self fillWithDictionaries:labels];
}

@end