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
    Texture2D*       _textureHearts;
    Texture2D*       _textureDiamonds;
    Texture2D*       _textureClubs;
    Texture2D*       _textureSpades;
}


@property (nonatomic, assign) GameRenderer*   renderer;
@property (nonatomic, retain) NSMutableArray* cards;
@property (nonatomic, retain) GLCard*         draggedCard;
@property (nonatomic, assign) GLfloat         initialAngle;
@property (nonatomic, assign) int             initialIndex;
@property (nonatomic, assign) int             finalIndex;
@property (nonatomic, retain) Texture2D*      textureHearts;
@property (nonatomic, retain) Texture2D*      textureDiamonds;
@property (nonatomic, retain) Texture2D*      textureClubs;
@property (nonatomic, retain) Texture2D*      textureSpades;

-(void)drawFronts;
-(void)drawBacks;
-(void)drawShadows;
-(void)drawLabels;

-(void)layoutCards;
-(void)resetCardsWithBendFactor:(GLfloat)bendFactor;
-(void)discardCardWithSuit:(int)suit numeral:(int)numeral;
-(void)addCardWithSuit:(int)suit numeral:(int)numeral held:(BOOL)held;
-(void)dealCardWithSuit:(int)suit numeral:(int)numeral;
-(void)clearCards;

-(void)startDragForCard:(GLCard*)card;
-(void)dragCardToTarget:(int)target withDelta:(GLfloat)delta;
-(void)stopDrag;

@end
