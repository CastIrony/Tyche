#import "GameController.h"

@class GLCard;

@interface GLCardGroup : NSObject 
{
    GameRenderer*    _renderer;
    NSMutableArray*  _cards;
    GLCard*          _draggedCard;
    GLfloat          _initialAngle;
    int              _initialIndex;
    int              _finalIndex;
    GLTexture*       _textureHearts;
    GLTexture*       _textureDiamonds;
    GLTexture*       _textureClubs;
    GLTexture*       _textureSpades;
}


@property (nonatomic, assign) GameRenderer*   renderer;
@property (nonatomic, retain) NSMutableArray* cards;
@property (nonatomic, retain) GLCard*         draggedCard;
@property (nonatomic, assign) GLfloat         initialAngle;
@property (nonatomic, assign) int             initialIndex;
@property (nonatomic, assign) int             finalIndex;
@property (nonatomic, retain) GLTexture*      textureHearts;
@property (nonatomic, retain) GLTexture*      textureDiamonds;
@property (nonatomic, retain) GLTexture*      textureClubs;
@property (nonatomic, retain) GLTexture*      textureSpades;

-(void)drawFronts;
-(void)drawBacks;
-(void)drawShadows;
-(void)drawLabels;

-(void)layoutCards;
-(void)resetCardsWithBendFactor:(GLfloat)bendFactor;

-(void)discardCardWithSuit:(int)suit numeral:(int)numeral                   afterDelay:(NSTimeInterval)delay andThen:(simpleBlock)work;
-(void)dealCardWithSuit:   (int)suit numeral:(int)numeral held:(BOOL)isHeld afterDelay:(NSTimeInterval)delay andThen:(simpleBlock)work;

-(void)clearCards;

-(void)startDragForCard:(GLCard*)card;
-(void)dragCardToTarget:(int)target withDelta:(GLfloat)delta;
-(void)stopDrag;

@end
