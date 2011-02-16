#import "GLTexture.h"
#import "Geometry.h"
#import "GLCard.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "GLCardGroup.h"
#import "CameraController.h"
#import "DisplayContainer.h"
#import "DisplayContainer.h"
#import "GameRenderer.h"

@implementation GLCardGroup

@synthesize renderer        = _renderer;
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

-(GLfloat)angleFlip
{
    return self.cards.liveObjects.count ? [[(GLCard*)[self.cards.liveObjects objectAtIndex:0] angleFlip] value] : 0;
}


-(void)setBendFactor:(GLfloat)bendFactor
{
    for(GLCard* card in self.cards.liveObjects)
    {
        if(within(card.bendFactor.value, bendFactor, 0.001)) { continue; }
           
        card.bendFactor = [AnimatedFloat withValue:bendFactor];
    }
}

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        _cards = [[DisplayContainer alloc] init];
        
        _cards.delay = 0.2;
        
        _initialIndex = -1;
        _finalIndex   = -1;
        _initialAngle = 0.0;
        _draggedCard  = nil;
        _showLabels = YES;
    }
    
    return self;
}

-(void)flipCardsAndThen:(SimpleBlock)work
{
    self.renderer.camera.status = CameraStatusCardsFlipped;
    
    int i = 0;
    
    for(GLCard* card in self.cards.liveObjects)
    {
        [card.location setValue:(4 * i - 8) forTime:1];
        
        [card.angleFlip setValue:180 forTime:1 andThen:(i == 0) ? work : nil];
                
        i++;
    }
}

-(void)unflipCardsAndThen:(SimpleBlock)work
{    
    self.renderer.camera.status = CameraStatusNormal;
    
    int i = 0;
    
    if(self.cards.liveObjects.count == 0) { RUNBLOCK(work); }
    
    for(GLCard* card in self.cards.liveObjects)
    {
        [card.location setValue:0 forTime:1];
        
        [card.angleFlip setValue:0 forTime:1 andThen:(i == 0) ? work : nil];
                
        i++;
    }
}

-(void)layoutCards
{
    NSUInteger cardCount = self.cards.liveObjects.count;
    NSUInteger currentPosition = 0;
    
    GLfloat delta = clipFloat(25.0 / (cardCount - 1), 0, 6);
    
    GLfloat currentAngle = (cardCount - 1) * -delta / 2.0 - 1.0;

    for(GLCard* card in self.cards.liveObjects)
    {
        card.position = currentPosition;
        
        card.angleFan.curve = AnimationLinear;
        
        [card.angleFan setValue:currentAngle forTime:0.2];
                
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
    
    [self.cards setKeys:newKeys dictionary:newDictionary andThen:work];

    [self layoutCards];
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
    self.draggedCard.isSelected = [AnimatedFloat withValue:1];
}

-(void)dragCardToTarget:(int)target withDelta:(GLfloat)delta
{
    if(self.draggedCard)
    {
        NSMutableArray* newKeys = [[[self.cards liveKeys] mutableCopy] autorelease];

        [newKeys removeObject:self.draggedCard.key];
        [newKeys insertObject:self.draggedCard.key atIndex:target];
    
        [self.cards setKeys:newKeys andDictionary:self.cards.liveDictionary];
        
        [self layoutCards];
        
        self.finalIndex = target;
        
        self.draggedCard.angleFan = [AnimatedFloat withValue:self.initialAngle - delta * 25 / 480];
    }
}

-(void)stopDrag
{
    if(self.draggedCard) 
    { 
        if(self.initialIndex >= 0 && self.finalIndex >= 0)
        {
            [self.renderer.gameController moveCardIndex:self.initialIndex toIndex:self.finalIndex];
        }
        
        [self layoutCards];
        
        self.draggedCard.isSelected = 0;
        self.draggedCard = nil;
        self.initialAngle = 0.0;
        self.initialIndex = -1;
        self.finalIndex = -1;
    }
}

@end
