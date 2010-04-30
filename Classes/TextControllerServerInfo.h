#import "TextController.h"

@interface TextControllerServerInfo : TextController 
{
    NSString* _serverName;
    NSString* _serverIcon;
}

@property (nonatomic, retain) NSString* serverName;
@property (nonatomic, retain) NSString* serverIcon;

@end