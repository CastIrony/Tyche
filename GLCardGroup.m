#import "GLTexture.h"
#import "MC3DVector.h"
#import "GLPlayer.h"
#import "GLCard.h"
#import "AnimationGroup.h"
#import "AnimatedFloat.h"
#import "AnimatedVec3.h"
#import "GLCardGroup.h"
#import "GLCamera.h"
#import "DisplayContainer.h"
#import "DisplayContainer.h"
#import "GLRenderer.h"

@implementation GLCardGroup

+(GLCardGroup*)cardGroup
{
    return [[[GLCardGroup alloc] init] autorelease];
}

@synthesize player          = _player;
@synthesize cards           = _cards;
@synthesize draggedCard     = _draggedCard;
@synthesize initialAngle    = _initialAngle;
@synthesize initialIndex    = _initialIndex;
@synthesize finalIndex      = _finalIndex;
@synthesize showLabels      = _showLabels;

@dynamic bendFactor;
@dynamic angleFlip;

-(GLfloat)bendFactor
{
    return self.cards.liveObjects.count ? [[(GLCard*)[self.cards.liveObjects objectAtIndex:0] bendFactor] value] : 0;
}

-(void)setBendFactor:(GLfloat)bendFactor
{
    for(GLCard* card in self.cards.liveObjects)
    {
        if(within(card.bendFactor.value, bendFactor, 0.001)) { continue; }
        
        card.bendFactor = [AnimatedFloat floatWithValue:bendFactor];
    }
}

-(GLfloat)angleFlip
{
    return self.cards.liveObjects.count ? [[(GLCard*)[self.cards.liveObjects objectAtIndex:0] isFlipped] value] * 180 : 0;
}

-(BOOL)isAnimating
{
    for(GLCard* card in self.cards.objects)
    {
        if(!card.dealt.hasEnded)      return YES;
        if(!card.death.hasEnded)      return YES;
        if(!card.isHeld.hasEnded)     return YES;
        if(!card.isFlipped.hasEnded)  return YES;
        if(!card.angleFan.hasEnded)   return YES;
        if(!card.bendFactor.hasEnded) return YES;
    }
    
    return NO;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        self.cards = [[[DisplayContainer alloc] init] autorelease];
        
        self.cards.delay = 0.2;
        
        self.initialIndex = -1;
        self.finalIndex   = -1;
        self.initialAngle = 0.0;
        self.draggedCard  = nil;
        self.showLabels = YES;
    }
    
    return self;
}

-(void)setFlipped:(BOOL)flipped andThen:(SimpleBlock)work;
{    
    AnimationGroup* animationGroup = [AnimationGroup animationGroup];
    
    for(GLCard* card in self.cards.liveObjects)
    {
        //GLfloat location = flipped ? (4 * card.position - 8) : 0;
        //GLfloat angleFlip = flipped ? 180 : 0;
        
//        [card.isFlipped setValue:location withSpeed:1];
//        [card.angleFlip setValue:angleFlip withSpeed:180];
        
        [card.isFlipped setValue:flipped withSpeed:1];
        
        [animationGroup addAnimation:card.isFlipped]; 
    }
    
    [animationGroup finishAndThen:work];
}

-(void)layoutCards
{
    NSUInteger cardCount = self.cards.liveObjects.count;
    NSUInteger currentPosition = 0;
    
    GLfloat delta = clipFloat(22.5 / (cardCount - 1), 0, 6);
    
    GLfloat currentAngle = (cardCount - 1) * -delta / 2.0;

    for(GLCard* card in self.cards.liveObjects)
    {
        card.position = currentPosition;
                
        [card.angleFan setValue:currentAngle forTime:0.3];
                
        currentPosition++;
        
        currentAngle += delta;
    }
}

-(void)updateCardsWithKeys:(NSArray*)keys held:(NSArray*)heldKeys andThen:(SimpleBlock)work
{
    NSMutableArray* newKeys = [NSMutableArray array];
    NSMutableDictionary* newDictionary = [NSMutableDictionary dictionary];
    
    for(NSString* key in keys)
    {
        [newKeys addObject:key];
        
        GLCard* card = [GLCard cardWithKey:key held:[heldKeys containsObject:key]];
        
        card.cardGroup = self;
        
        [newDictionary setObject:card forKey:key];
    }

    BOOL cardsKeysChanged = ![self.cards.keys isEqualToArray:newKeys];
    
    [self.cards setLiveKeys:newKeys liveDictionary:newDictionary andThen:work];

    if(cardsKeysChanged)
    {
        [self layoutCards];
    }
}

-(void)makeControlPoints
{
    for(GLCard* card in self.cards.objects) 
    {         
        [card makeControlPoints]; 
    }
}

-(void)drawFronts
{
    for(GLCard* card in self.cards.objects.reverseObjectEnumerator) 
    { 
        [card drawFront]; 
    }
}

-(void)drawBacks
{
    for(GLCard* card in self.cards.objects) 
    { 
        [card drawBack]; 
    }
}

-(void)drawShadows
{
    for(GLCard* card in self.cards.objects) 
    { 
        [card drawShadow]; 
    }
}

-(void)drawLabels
{
    for(GLCard* card in self.cards.objects) 
    { 
        [card drawLabel]; 
    }
}

-(void)startDragForCard:(GLCard*)card
{
    if(self.draggedCard) { return; }
    
    self.draggedCard = card;
    self.initialAngle = card.angleFan.value;
    self.initialIndex = card.position;
}

-(void)dragCardToTarget:(int)target withDelta:(GLfloat)delta
{
    if(self.draggedCard)
    {
        NSMutableArray* newKeys = [[[self.cards liveKeys] mutableCopy] autorelease];

        [newKeys removeObject:self.draggedCard.key];
        [newKeys insertObject:self.draggedCard.key atIndex:target];
    
        BOOL cardsKeysChanged = ![self.cards.keys isEqualToArray:newKeys];
        
        [self.cards setLiveKeys:newKeys liveDictionary:self.cards.liveDictionary andThen:nil];
        
        if(cardsKeysChanged)
        {
            [self layoutCards];
        }
        
        self.finalIndex = target;
        
        [self.draggedCard.angleFan setValue:self.initialAngle - delta * 25 / 480];
    }
}

-(void)stopDrag
{
    if(self.draggedCard) 
    { 
        if(self.initialIndex >= 0 && self.finalIndex >= 0)
        {
            [self.player.renderer.gameController moveCardIndex:self.initialIndex toIndex:self.finalIndex];
        }
        
        [self layoutCards];
        
        self.draggedCard = nil;
        self.initialAngle = 0.0;
        self.initialIndex = -1;
        self.finalIndex = -1;
    }
}

@end
