#import "Geometry.h"
#import "MC3DVector.h"
#import "Bezier.h"
#import "GLPlayer.h"
#import "GLTexture.h"
#import "GLFlatCardGroup.h"
#import "AnimatedFloat.h"
#import "AnimatedVec3.h"
#import "GLRenderer.h"
#import "DisplayContainer.h"
#import "TextureController.h"
#import "GLCamera.h"
#import "GLFlatCard.h"

@implementation GLFlatCard

@synthesize cardGroup   = _cardGroup;
@synthesize angleJitter = _angleJitter;
@synthesize suit        = _suit;
@synthesize numeral     = _numeral;
@synthesize position    = _position;
@synthesize dealt      = _dealt;
@synthesize death      = _death;
@synthesize angleFan   = _angleFan;
@synthesize bendFactor = _bendFactor;
@synthesize isFlipped  = _isFlipped;

@synthesize key              = _key;
@synthesize displayContainer = _displayContainer;

@dynamic isDead;
@dynamic isAlive;

-(void)dealloc
{
    free(arrayVertex);
    free(arrayTexture0);
    free(arrayTexture1);
    free(arrayMesh);
    
    [super dealloc];
}

-(void)appearAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work
{
    self.angleJitter = randomFloat(-3.0, 3.0);
    
    [self.dealt setValue:1 forTime:1 afterDelay:delay andThen:work];
}

-(NSString*)description
{
    NSString* status = @"D";
    
    if(self.isAlive) { status = @"A"; }
    if(self.isDead)  { status = @"X"; }
    
    return [NSString stringWithFormat:@"<GLFlatCard key:'%@', status:'%@:%3i'>", self.key, status, (int)(self.death.value * 100)];
}

+(GLFlatCard*)cardWithKey:(NSString*)key
{
    NSArray* components = [key componentsSeparatedByString:@"-"];
    
    int suit    = [[components objectAtIndex:0] intValue];    
    int numeral = [[components objectAtIndex:1] intValue];
    
    GLFlatCard* card = [[[GLFlatCard alloc] initWithSuit:suit numeral:numeral] autorelease];
    
    card.key = key;
    
    return card;
}

-(id)initWithSuit:(int)suit numeral:(int)numeral
{
    self = [super init];
    
    if(self)
    {   
        _numeral = numeral;
        _suit    = suit;
        
        arrayVertex         = malloc(4 * sizeof(vec3));
        arrayTexture0       = malloc(4 * sizeof(vec2));
        arrayTexture1       = malloc(4 * sizeof(vec2));
        arrayMesh           = malloc(6 * sizeof(GLushort));
        textureSizeCard     = vec2Make(172.0 / 1024.0, 252.0 / 1024.0);
        
        arrayVertex[0] = vec3Make(-2.0,  0.0, -3.0);
        arrayVertex[1] = vec3Make( 2.0,  0.0, -3.0);
        arrayVertex[2] = vec3Make(-2.0,  0.0,  3.0);
        arrayVertex[3] = vec3Make( 2.0,  0.0,  3.0);
                
        textureSizeCard = vec2Make(172.0 / 1024.0, 252.0 / 1024.0);

        textureOffsetCard[ 0] = vec2Make(826.0 / 1024.0, 702.0 / 1024.0); // Shadow
        textureOffsetCard[ 1] = vec2Make( 26.0 / 1024.0,  36.0 / 1024.0); // Ace
        textureOffsetCard[ 2] = vec2Make(226.0 / 1024.0,  36.0 / 1024.0); // 2
        textureOffsetCard[ 3] = vec2Make(428.0 / 1024.0,  36.0 / 1024.0); // 3
        textureOffsetCard[ 4] = vec2Make(626.0 / 1024.0,  36.0 / 1024.0); // 4
        textureOffsetCard[ 5] = vec2Make(826.0 / 1024.0,  36.0 / 1024.0); // 5
        textureOffsetCard[ 6] = vec2Make( 26.0 / 1024.0, 369.0 / 1024.0); // 6
        textureOffsetCard[ 7] = vec2Make(226.0 / 1024.0, 369.0 / 1024.0); // 7
        textureOffsetCard[ 8] = vec2Make(426.0 / 1024.0, 369.0 / 1024.0); // 8
        textureOffsetCard[ 9] = vec2Make(626.0 / 1024.0, 369.0 / 1024.0); // 9
        textureOffsetCard[10] = vec2Make(826.0 / 1024.0, 369.0 / 1024.0); // 10
        textureOffsetCard[11] = vec2Make( 26.0 / 1024.0, 702.0 / 1024.0); // Jack
        textureOffsetCard[12] = vec2Make(226.0 / 1024.0, 702.0 / 1024.0); // Queen
        textureOffsetCard[13] = vec2Make(426.0 / 1024.0, 702.0 / 1024.0); // King
        textureOffsetCard[14] = vec2Make(626.0 / 1024.0, 702.0 / 1024.0); // Back

        arrayTexture0[0] = vec2Make(0, 0);
        arrayTexture0[1] = vec2Make(1, 0);
        arrayTexture0[2] = vec2Make(0, 1);
        arrayTexture0[3] = vec2Make(1, 1);
        
        arrayTexture1[0] = vec2Make(textureOffsetCard[numeral].x + textureSizeCard.x, textureOffsetCard[numeral].y                    );
        arrayTexture1[1] = vec2Make(textureOffsetCard[numeral].x                    , textureOffsetCard[numeral].y                    );
        arrayTexture1[2] = vec2Make(textureOffsetCard[numeral].x + textureSizeCard.x, textureOffsetCard[numeral].y + textureSizeCard.y);
        arrayTexture1[3] = vec2Make(textureOffsetCard[numeral].x                    , textureOffsetCard[numeral].y + textureSizeCard.y);
        
        GenerateBezierMesh(arrayMesh, 2, 2);
        
        self.angleFan   = [AnimatedFloat floatWithValue:0];
        self.dealt      = [AnimatedFloat floatWithValue:0];
        self.death      = [AnimatedFloat floatWithValue:0];

        self.bendFactor = [AnimatedFloat floatWithValue:0];
        self.isFlipped  = [AnimatedFloat floatWithValue:0];
    }
    
    return self;
}

-(BOOL)isEqual:(id)object
{
    GLFlatCard* card = (GLFlatCard*)object;
    
    if(card.suit    != self.suit)    { return NO; }
    if(card.numeral != self.numeral) { return NO; }
    
    return YES;
}

-(void)draw
{   
    GLfloat bendOpacity = 1.0 - easeInOut(self.bendFactor.value, 0.2, 0.6); 
    GLfloat flipOpacity = easeInOut(1.0 - self.isFlipped.value, 0.4, 0.6);
    GLfloat heldOpacity = bendOpacity * flipOpacity;
    
    GLfloat deathOpacity = MIN(-4.0 * (1.0 + self.death.value - self.dealt.value) + 4.0, 1.0);
    
    GLfloat opacity = heldOpacity * deathOpacity;
    
    TRANSACTION_BEGIN
    {
        glTranslatef(0, 0, -30 * (1 + self.death.value - self.dealt.value));
        
        glTranslatef( 6.0, 0,  2.0);
        glRotatef(1.5 * self.angleFan.value, 0, 1, 0);
        glTranslatef(-1.0, 0, -2.0);
        glRotatef(self.angleJitter / 2.0, 0, 1, 0);
        
        glDisableClientState(GL_NORMAL_ARRAY);
        
        if(within(opacity, 0, 0.001)) { return; }
        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        GLfloat lightness = self.cardGroup.player.renderer.lightness.value;
        
        glColor4f(lightness, lightness, lightness, opacity);
        
        glVertexPointer  (3, GL_FLOAT, 0, arrayVertex);
        glNormal3f(0.0, -1.0, 0.0);
        
        glClientActiveTexture(GL_TEXTURE0); 
        glActiveTexture(GL_TEXTURE0); 
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"cards"]);
        glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0);      
        
        glClientActiveTexture(GL_TEXTURE1); 
        glActiveTexture(GL_TEXTURE1); 
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:[NSString stringWithFormat:@"suit%d", _suit]]);
        glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture1);      
        
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, arrayMesh);
        
        glClientActiveTexture(GL_TEXTURE1); 
        glActiveTexture(GL_TEXTURE1); 
        glBindTexture(GL_TEXTURE_2D, 0);
        glClientActiveTexture(GL_TEXTURE0); 
        glActiveTexture(GL_TEXTURE0); 

        glEnableClientState(GL_NORMAL_ARRAY);
    }
    TRANSACTION_END
}

-(BOOL)isAlive { return within(self.death.endValue, 0, 0.001); }
-(BOOL)isDead  { return within(self.death.value,    1, 0.001); }

-(void)dieAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work
{
    [self.death setValue:1 forTime:1 afterDelay:delay andThen:work];
}

@end