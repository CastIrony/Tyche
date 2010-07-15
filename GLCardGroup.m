#import "GLTexture.h"
#import "Geometry.h"
#import "GLCard.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "GLCardGroup.h"
#import "CameraController.h"
#import "DisplayContainer.h"
#import "Killable.h"
#import "GameRenderer.h"

@implementation GLCardGroup

@synthesize renderer        = _renderer;
@synthesize cards           = _cards;
@synthesize draggedCard     = _draggedCard;
@synthesize initialAngle    = _initialAngle;
@synthesize initialIndex    = _initialIndex;
@synthesize finalIndex      = _finalIndex;

@dynamic bendFactor;

-(GLfloat)bendFactor
{
    return [[[self.cards.liveObjects objectAtIndex:0] bendFactor] value];
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
        
        _initialIndex = -1;
        _finalIndex   = -1;
        _initialAngle = 0.0;
        _draggedCard  = nil;
    }
    
    return self;
}

-(void)flipCardsAndThen:(simpleBlock)work
{
    self.renderer.camera.status = CameraStatusCardsFlipped;
    
    int i = 0;
    
    for(GLCard* card in self.cards.liveObjects)
    {
        card.location  = [AnimatedFloat withStartValue:card.location.value  endValue:(-4 * i + 8) forTime:1];
        card.angleFlip = [AnimatedFloat withStartValue:card.angleFlip.value endValue:180          forTime:1];
        
        if(i == 0) { card.angleFlip.onEnd = work; }
        
        i++;
    }
}

-(void)unflipCardsAndThen:(simpleBlock)work
{    
    self.renderer.camera.status = CameraStatusNormal;
    
    int i = 0;
    
    for(GLCard* card in self.cards.liveObjects)
    {
        card.location  = [AnimatedFloat withStartValue:card.location.value  endValue:0 forTime:1];
        card.angleFlip = [AnimatedFloat withStartValue:card.angleFlip.value endValue:0 forTime:1];
        
        if(i == 0) { card.angleFlip.onEnd = work; }
        
        i++;
    }
}

-(void)layoutCards
{
    GLfloat fan = -15 + 5 * self.cards.liveObjects.count;
    
    GLfloat position = 0;
    
    for(GLCard* card in self.cards.liveObjects)
    {
        card.position = position;
        card.angleFan = self.renderer.animated ? [AnimatedFloat withValue:fan] : [AnimatedFloat withStartValue:card.angleFan.value endValue:fan speed:0.5];
        
        position++;
        
        fan -= 5;
    }
}

-(void)updateCardsWithKeys:(NSArray*)keys andThen:(simpleBlock)work
{
    NSArray* liveKeys = [[self.cards.liveKeys copy] autorelease];
    
    int i = 0;
    
    for(NSString* key in keys)
    {
        if([self.cards.liveKeys containsObject:key])
        {
            [self.cards moveKey:key toIndex:i];
        }
        else
        {
            GLCard* card = [GLCard cardWithKey:key];
            
            card.cardGroup = self;
            card.dealt = [AnimatedFloat withStartValue:0 endValue:1 forTime:2];
            
            [self.cards insertObject:card withKey:key atIndex:i];
        }
        
        i++;
    }
    
    for(NSString* key in liveKeys)
    {
        if(![keys containsObject:key])
        {
            [[self.cards liveObjectForKey:key] killWithDisplayContainer:self.cards andKey:key];
        }
    }
    
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
    for(GLCard* card in self.cards.objects) 
    { 
        [card drawFront]; 
    }
}

-(void)drawBacks
{
    for(GLCard* card in self.cards.objects.reverseObjectEnumerator) 
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
//        [self.cards removeObjectIdenticalTo:self.draggedCard];
//        
//        [self.cards insertObject:self.draggedCard atIndex:target];
//        
//        [self layoutCards];
//        
//        self.finalIndex = target;
//        
//        self.draggedCard.angleFan = [AnimatedFloat withValue:self.initialAngle - delta * 25 / 480];
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
