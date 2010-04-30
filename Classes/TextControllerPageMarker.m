#import "Texture2D.h"
#import "TextControllerPageMarker.h"

@implementation TextControllerPageMarker

@synthesize page = _page;
@synthesize total = _total;

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        Color3D labelColor = Color3DMake(0, 0, 0, 0.9); 
        
        [self.styles setObject:[NSNumber numberWithFloat:0.1]                                  forKey:@"fadeMargin"]; 
        [self.styles setObject:[NSNumber numberWithBool:NO]                                    forKey:@"hasShadow"];
        [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(3.75, 0.25)]               forKey:@"labelSize"];
        [self.styles setObject:[NSValue  valueWithBytes:&labelColor objCType:@encode(Color3D)] forKey:@"colorNormal"];
        [self.styles setObject:[NSValue  valueWithBytes:&labelColor objCType:@encode(Color3D)] forKey:@"colorTouched"];
        
        self.center = YES;
        self.padding = 0.2;
        
        self.page = 0;
        self.total = 1;
    }
    
    return self;
}

-(void)update
{
    NSMutableArray* labels = [[[NSMutableArray alloc] init] autorelease];
    
    if(self.total > 1)
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
                
        Texture2D* texture = [[[Texture2D alloc] initWithDots:self.total current:self.page] autorelease];
        
        [label setObject:texture forKey:@"textureText"]; 
        [label setObject:[NSValue valueWithCGSize:texture.contentSize] forKey:@"textSize"]; 
        [label setObject:@"text" forKey:@"key"]; 
        
        [labels addObject:label]; 
    }    
    
    [self fillWithDictionaries:labels];
}

@end