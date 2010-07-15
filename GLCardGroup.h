#import "GameController.h"

@class DisplayContainer;
@class GLCard;

@interface GLCardGroup : NSObject 

@property (nonatomic, assign) GameRenderer*     renderer;
@property (nonatomic, assign) GLfloat           bendFactor;

@property (nonatomic, retain) DisplayContainer* cards;

@property (nonatomic, retain) GLCard*           draggedCard;
@property (nonatomic, assign) GLfloat           initialAngle;
@property (nonatomic, assign) int               initialIndex;
@property (nonatomic, assign) int               finalIndex;

-(void)drawFronts;
-(void)drawBacks;
-(void)drawShadows;
-(void)drawLabels;

-(void)flipCardsAndThen:(simpleBlock)work;
-(void)unflipCardsAndThen:(simpleBlock)work;

-(void)updateCardsWithKeys:(NSArray*)keys held:(NSArray*)heldKeys andThen:(simpleBlock)work;

-(void)layoutCards;
-(void)makeControlPoints;

-(void)startDragForCard:(GLCard*)card;
-(void)dragCardToTarget:(int)target withDelta:(GLfloat)delta;
-(void)stopDrag;

@end
