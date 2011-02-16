#import "GameController.h"

@class DisplayContainer;
@class GLCard;

@interface GLCardGroup : NSObject 

@property (nonatomic, assign) GameRenderer*     renderer;
@property (nonatomic, assign) GLfloat           bendFactor;
@property (nonatomic, readonly) GLfloat           angleFlip;

@property (nonatomic, retain) DisplayContainer* cards;

@property (nonatomic, retain) GLCard*           draggedCard;
@property (nonatomic, assign) GLfloat           initialAngle;
@property (nonatomic, assign) int               initialIndex;
@property (nonatomic, assign) int               finalIndex;
@property (nonatomic, assign) BOOL              showLabels;

-(void)drawFronts;
-(void)drawBacks;
-(void)drawShadows;
-(void)drawLabels;

-(void)flipCardsAndThen:(SimpleBlock)work;
-(void)unflipCardsAndThen:(SimpleBlock)work;

-(void)updateCardsWithKeys:(NSArray*)keys held:(NSArray*)heldKeys andThen:(SimpleBlock)work;

-(void)layoutCards;
-(void)makeControlPoints;

-(void)startDragForCard:(GLCard*)card;
-(void)dragCardToTarget:(int)target withDelta:(GLfloat)delta;
-(void)stopDrag;

@end
