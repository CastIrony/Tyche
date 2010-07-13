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

-(void)layoutCards;
-(void)makeControlPoints;

-(void)discardCardWithSuit:(int)suit numeral:(int)numeral                   afterDelay:(NSTimeInterval)delay andThen:(simpleBlock)work;
-(void)dealCardWithSuit:   (int)suit numeral:(int)numeral held:(BOOL)isHeld afterDelay:(NSTimeInterval)delay andThen:(simpleBlock)work;

-(void)clearCards;

-(void)startDragForCard:(GLCard*)card;
-(void)dragCardToTarget:(int)target withDelta:(GLfloat)delta;
-(void)stopDrag;

@end
