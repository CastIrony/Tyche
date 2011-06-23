#import "GameController.h"

@class DisplayContainer;
@class GLPlayer;
@class GLCard;

@interface GLCardGroup : NSObject 

+(GLCardGroup*)cardGroup;

@property (nonatomic, assign) GLPlayer*         player;
@property (nonatomic, assign) GLfloat           bendFactor;
@property (nonatomic, readonly) GLfloat         angleFlip;

@property (nonatomic, retain) DisplayContainer* cards;

@property (nonatomic, retain) GLCard*           draggedCard;
@property (nonatomic, assign) GLfloat           initialAngle;
@property (nonatomic, assign) int               initialIndex;
@property (nonatomic, assign) int               finalIndex;
@property (nonatomic, assign) BOOL              showLabels;
@property (nonatomic, readonly) BOOL isAnimating;

-(void)drawFronts;
-(void)drawBacks;
-(void)drawShadows;
-(void)drawLabels;

-(void)setFlipped:(BOOL)flipped andThen:(SimpleBlock)work;

-(void)updateCardsWithKeys:(NSArray*)keys held:(NSArray*)heldKeys andThen:(SimpleBlock)work;

-(void)layoutCards;
-(void)makeControlPoints;

-(void)startDragForCard:(GLCard*)card;
-(void)dragCardToTarget:(int)target withDelta:(GLfloat)delta;
-(void)stopDrag;

@end
