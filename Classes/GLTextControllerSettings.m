#import "GLRenderer.h"
#import "GLMenuLayerController.h"
#import "GLTextControllerSettings.h"

@implementation GLTextControllerSettings

@synthesize settingKeys;
@synthesize settingNames;
@synthesize settingChoiceKeys;
@synthesize settingChoiceNames;
@synthesize settingChoiceSelected;

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        self.center = YES;
        
        NSMutableArray* keys = [NSMutableArray array];
        NSMutableDictionary* names = [NSMutableDictionary dictionary];
        NSMutableDictionary* choiceKeys = [NSMutableDictionary dictionary];
        NSMutableDictionary* choiceNames = [NSMutableDictionary dictionary];
        NSMutableDictionary* choiceSelected = [NSMutableDictionary dictionary];
    
        [keys addObject:@"camera"];
        [keys addObject:@"soundEffects"];
        
        [names setObject:@"Camera" forKey:@"camera"];
        [names setObject:@"Sound Effects" forKey:@"soundEffects"];
        
        [choiceSelected setObject:@"automatic" forKey:@"camera"];
        [choiceSelected setObject:@"off" forKey:@"soundEffects"];
        
        { NSMutableArray* array = [NSMutableArray array]; [array addObject:@"manual"]; [array addObject:@"automatic"]; [choiceKeys setObject:array forKey:@"camera"];       }
        { NSMutableArray* array = [NSMutableArray array]; [array addObject:@"off"];    [array addObject:@"on"];        [choiceKeys setObject:array forKey:@"soundEffects"]; }
        
        { NSMutableDictionary* dictionary = [NSMutableDictionary dictionary]; [dictionary setObject:@"Manual" forKey:@"manual"]; [dictionary setObject:@"Automatic" forKey:@"automatic"]; [choiceNames setObject:dictionary forKey:@"camera"];       }
        { NSMutableDictionary* dictionary = [NSMutableDictionary dictionary]; [dictionary setObject:@"Off"    forKey:@"off"];    [dictionary setObject:@"On"        forKey:@"on"];        [choiceNames setObject:dictionary forKey:@"soundEffects"]; }
        
        self.settingKeys = keys;
        self.settingNames = names;
        self.settingChoiceKeys = choiceKeys;
        self.settingChoiceNames = choiceNames;
        self.settingChoiceSelected = choiceSelected;
    }
    
    return self;
}

-(void)update
{
    color colorNormal      = colorMake(0.8, 0, 0, 0.8); 
    color colorTouched     = colorMake(0.4, 0, 0, 0.8); 
    
    [self.styles setObject:[UIFont   fontWithName:@"Futura-Medium" size:20]                  forKey:@"font"];
    [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(2.75, 0.42)]                 forKey:@"labelSize"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorNormal  objCType:@encode(color)] forKey:@"colorNormal"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(color)] forKey:@"colorTouched"];
    [self.styles setObject:[NSNumber numberWithFloat:0.0]                                    forKey:@"fadeMargin"]; 
    [self.styles setObject:[NSNumber numberWithFloat:0.4]                                    forKey:@"topMargin"]; 
    [self.styles setObject:[NSNumber numberWithFloat:0.4]                                    forKey:@"bottomMargin"]; 

    NSMutableArray* labels = [NSMutableArray array];
    
    NSMutableDictionary* titleLabel = [NSMutableDictionary dictionary]; 
    
    [titleLabel setObject:@"title"    forKey:@"key"]; 
    [titleLabel setObject:@"Settings" forKey:@"textString"];          
    [titleLabel setObject:[UIFont  fontWithName:@"Futura-Medium" size:35]                  forKey:@"font"];
    [titleLabel setObject:[NSValue valueWithCGSize:CGSizeMake(3.75, 0.6)]                  forKey:@"labelSize"];
    [titleLabel setObject:[NSValue valueWithBytes:&colorTouched objCType:@encode(color)] forKey:@"colorNormal"];
    [titleLabel setObject:[NSNumber numberWithFloat:0.2]                                   forKey:@"topMargin"]; 

    [labels addObject:titleLabel]; 
    
    for(NSString* settingKey in self.settingKeys)
    { 
        NSString* settingName = [self.settingNames objectForKey:settingKey];
        NSString* settingChoiceKey = [self.settingChoiceSelected objectForKey:settingKey];
        NSString* settingChoiceName = [(NSDictionary*)[self.settingChoiceNames objectForKey:settingKey] objectForKey:settingChoiceKey];
        
        NSMutableDictionary* label = [NSMutableDictionary dictionary]; 
        
        [label setObject:settingKey                                                            forKey:@"key"]; 
        [label setObject:[NSString stringWithFormat:@"%@: %@", settingName, settingChoiceName] forKey:@"textString"];     
        
        [labels addObject:label]; 
    }
    
    [self fillWithDictionaries:labels];
}

@end
