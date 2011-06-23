#import "GLTextController.h"

@interface GLTextControllerSettings : GLTextController 

@property (nonatomic, copy) NSArray*      settingKeys;
@property (nonatomic, copy) NSDictionary* settingNames;
@property (nonatomic, copy) NSDictionary* settingChoiceKeys;
@property (nonatomic, copy) NSDictionary* settingChoiceNames;
@property (nonatomic, copy) NSDictionary* settingChoiceSelected;

@end