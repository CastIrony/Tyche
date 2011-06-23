#import "GLTexture.h"
#import "MC3DVector.h"
#import "GLPlayer.h"
#import "GLFlatCard.h"
#import "AnimationGroup.h"
#import "AnimatedFloat.h"
#import "AnimatedVec3.h"
#import "GLCamera.h"
#import "DisplayContainer.h"
#import "DisplayContainer.h"
#import "GLRenderer.h"
#import "GLFlatCardGroup.h"

@implementation GLFlatCardGroup

+(GLFlatCardGroup*)flatCardGroup
{
    return [[[GLFlatCardGroup alloc] init] autorelease];
}

@synthesize player          = _player;
@synthesize cards           = _cards;

@dynamic bendFactor;
@dynamic angleFlip;

-(GLfloat)bendFactor
{
    return self.cards.liveObjects.count ? [[(GLFlatCard*)[self.cards.liveObjects objectAtIndex:0] bendFactor] value] : 0;
}

-(void)setBendFactor:(GLfloat)bendFactor
{
    for(GLFlatCard* card in self.cards.liveObjects)
    {
        if(within(card.bendFactor.value, bendFactor, 0.001)) { continue; }
        
        card.bendFactor = [AnimatedFloat floatWithValue:bendFactor];
    }
}

-(GLfloat)angleFlip
{
    return self.cards.liveObjects.count ? [[(GLFlatCard*)[self.cards.liveObjects objectAtIndex:0] isFlipped] value] * 180 : 0;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        _cards = [[DisplayContainer alloc] init];
        
        _cards.delay = 0.2;
    }
    
    return self;
}

-(void)layoutCards
{
    NSUInteger cardCount = self.cards.liveObjects.count;
    NSUInteger currentPosition = 0;
    
    GLfloat delta = clipFloat(25.0 / (cardCount - 1), 0, 6);
    
    GLfloat currentAngle = (cardCount - 1) * -delta / 2.0;
    
    for(GLFlatCard* card in self.cards.liveObjects)
    {
        card.position = currentPosition;
        
        card.angleFan.curve = AnimationLinear;
        
        [card.angleFan setValue:currentAngle forTime:0.2];
        
        currentPosition++;
        
        currentAngle += delta;
    }
}

-(void)updateCardsWithKeys:(NSArray*)keys andThen:(SimpleBlock)work
{
    NSMutableArray* newKeys = [NSMutableArray array];
    NSMutableDictionary* newDictionary = [NSMutableDictionary dictionary];
    
    for(NSString* key in keys)
    {
        [newKeys addObject:key];
        
        GLFlatCard* card = [GLFlatCard cardWithKey:key];
        
        card.cardGroup = self;
        
        [newDictionary setObject:card forKey:key];
    }
    
    [self.cards setLiveKeys:newKeys liveDictionary:newDictionary andThen:work];
    
    [self layoutCards];
}

-(void)draw
{
    for(GLFlatCard* card in self.cards.objects) 
    { 
        [card draw]; 
    }
}

@end