#import "GameController.h"

@class DisplayContainer;
@class GLPlayer;
@class GLFlatCard;

@interface GLFlatCardGroup : NSObject 

+(GLFlatCardGroup*)flatCardGroup;

@property (nonatomic, assign) GLPlayer*         player;
@property (nonatomic, retain) DisplayContainer* cards;
@property (nonatomic, assign) GLfloat           bendFactor;
@property (nonatomic, readonly) GLfloat         angleFlip;

-(void)draw;

-(void)updateCardsWithKeys:(NSArray*)keys andThen:(SimpleBlock)work;

-(void)layoutCards;

@end
