#import "TextController.h"

@interface TextControllerPageMarker : TextController 
{
    int _page;
    int _total;
}

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int total;

@end
