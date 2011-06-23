#import "Geometry.h"
#import "MC3DVector.h"
#import "Bezier.h"
#import "GLPlayer.h"
#import "GLTexture.h"
#import "Projection.h"
#import "GLCardGroup.h"
#import "AnimatedFloat.h"
#import "AnimatedVec3.h"
#import "GLRenderer.h"
#import "DisplayContainer.h"
#import "TextureController.h"
#import "GLCamera.h"

#import "GLCard.h"

@implementation GLCard

@synthesize cardGroup   = _cardGroup;
@synthesize angleJitter = _angleJitter;
@synthesize suit        = _suit;
@synthesize numeral     = _numeral;
@synthesize position    = _position;
@synthesize dealt      = _dealt;
@synthesize death      = _death;
@synthesize isHeld     = _isHeld;
@synthesize bendFactor = _bendFactor;
@synthesize isFlipped  = _isFlipped;
@synthesize angleFan   = _angleFan;
@synthesize cancelTap  = _cancelTap;

@synthesize key              = _key;
@synthesize displayContainer = _displayContainer;

@dynamic isDead;
@dynamic isAlive;

@dynamic isMeshAnimating;

-(void)dealloc
{
    free(arrayVertexFront);
    free(arrayVertexBack);
    free(arrayVertexBackSimple);
    free(arrayVertexShadow);
    free(arrayNormalFront);
    free(arrayNormalBack);
    free(arrayNormalBackSimple);
    free(arrayNormalShadow);
    free(arrayTexture0Front);
    free(arrayTexture0Back);
    free(arrayTexture0BackSimple);
    free(arrayTexture0Shadow);
    free(arrayTexture1Front);
    free(arrayTexture1Back);
    free(arrayTexture1BackSimple);
    free(arrayMeshFront);
    free(arrayMeshBack);
    free(arrayMeshBackSimple);
    free(arrayMeshShadow);
    
    [super dealloc];
}

-(void)appearAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work
{
    self.angleJitter = randomFloat(-3.0, 3.0);

    [self.dealt setValue:1 forTime:1 afterDelay:delay andThen:work];
}

-(BOOL)isMeshAnimating
{    
    return YES;//!self.bendFactor.hasEnded || !self.isFlipped.hasEnded || !self.angleFan.hasEnded;
}

-(NSString*)description
{
    NSString* status = @"D";
    
    if(self.isAlive) { status = @"A"; }
    if(self.isDead)  { status = @"X"; }
    
    return [NSString stringWithFormat:@"<GLCard key:'%@', status:'%@:%3i'>", self.key, status, (int)(self.death.value * 100)];
}

+(GLCard*)cardWithKey:(NSString*)key
{
    NSArray* components = [key componentsSeparatedByString:@"-"];
    
    int suit    = [[components objectAtIndex:0] intValue];    
    int numeral = [[components objectAtIndex:1] intValue];
    
    GLCard* card = [[[GLCard alloc]initWithSuit:suit numeral:numeral held:YES] autorelease];
    
    card.key = key;
    
    return card;
}
 
+(GLCard*)cardWithKey:(NSString*)key held:(BOOL)held
{
    NSArray* components = [key componentsSeparatedByString:@"-"];
    
    int suit    = [[components objectAtIndex:0] intValue];    
    int numeral = [[components objectAtIndex:1] intValue];
    
    GLCard* card = [[[GLCard alloc]initWithSuit:suit numeral:numeral held:held] autorelease];
    
    card.key = key;
    
    return card;
}
          
-(id)initWithSuit:(int)suit numeral:(int)numeral held:(BOOL)held
{
    self = [super init];
    
    if(self)
    {   
        _numeral = numeral;
        _suit    = suit;
        
        meshWidthFront   = 9;
        meshHeightFront  = 3;
        meshWidthBack    = 5;
        meshHeightBack   = 2;
        meshWidthShadow  = 5;
        meshHeightShadow = 2;
        
        arrayVertexFront      = malloc(meshWidthFront  * meshHeightFront  * sizeof(vec3));
        arrayVertexBack       = malloc(meshWidthBack   * meshHeightBack   * sizeof(vec3));
        arrayVertexShadow     = malloc(meshWidthShadow * meshHeightShadow * sizeof(vec3));
        arrayVertexBackSimple = malloc(4 * sizeof(vec3));
        
        arrayNormalFront      = malloc(meshWidthFront  * meshHeightFront  * sizeof(vec3));
        arrayNormalBack       = malloc(meshWidthBack   * meshHeightBack   * sizeof(vec3));
        arrayNormalShadow     = malloc(meshWidthShadow * meshHeightShadow * sizeof(vec3));
        arrayNormalBackSimple = malloc(4 * sizeof(vec3));
        
        arrayTexture0Front      = malloc(meshWidthFront  * meshHeightFront  * sizeof(vec2));
        arrayTexture0Back       = malloc(meshWidthBack   * meshHeightBack   * sizeof(vec2));
        arrayTexture0Shadow     = malloc(meshWidthShadow * meshHeightShadow * sizeof(vec2));
        arrayTexture0BackSimple = malloc(4 * sizeof(vec2));
        
        arrayTexture1Front      = malloc(meshWidthFront  * meshHeightFront  * sizeof(vec2));
        arrayTexture1Back       = malloc(meshWidthBack   * meshHeightBack   * sizeof(vec2));
        arrayTexture1BackSimple = malloc(4 * sizeof(vec2));
        
        arrayMeshFront      = malloc((meshWidthFront  - 1) * (meshHeightFront  - 1) * 6 * sizeof(GLushort));
        //arrayMeshBack       = malloc((meshWidthBack   - 1) * (meshHeightBack   - 1) * 6 * sizeof(GLushort));
        //arrayMeshShadow     = malloc((meshWidthShadow - 1) * (meshHeightShadow - 1) * 6 * sizeof(GLushort));
        arrayMeshBack       = malloc((meshWidthBack   - 1) * 6 * sizeof(GLushort));
        arrayMeshShadow     = malloc((meshWidthShadow - 1) * 6 * sizeof(GLushort));
        arrayMeshBackSimple = malloc(6 * sizeof(GLushort));
        
        textureSizeCard     = vec2Make(172.0 / 1024.0, 252.0 / 1024.0);
        textureSizeLabel    = vec2Make(116.0 / 1024.0,  62.0 / 1024.0);
        
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
        
        GenerateBezierTextures(arrayTexture0Front,  meshWidthFront,  meshHeightFront,  vec2Make(1, 1), vec2Make(0, 0));
        GenerateBezierTextures(arrayTexture0Back,   meshWidthBack,   meshHeightBack,   vec2Make(1, 1), vec2Make(0, 0)); 
        GenerateBezierTextures(arrayTexture0Shadow, meshWidthShadow, meshHeightShadow, vec2Make(1, 1), vec2Make(0, 0));
        GenerateBezierTextures(arrayTexture1Front,  meshWidthFront,  meshHeightFront,  textureSizeCard, textureOffsetCard[self.numeral]);
        GenerateBezierTextures(arrayTexture1Back,   meshWidthBack,   meshHeightBack,   textureSizeCard, textureOffsetCard[14]); 
        
        GenerateBezierTextures(arrayTexture0BackSimple, 2, 2, vec2Make(1, 1), vec2Make(0, 0)); 
        GenerateBezierTextures(arrayTexture1BackSimple, 2, 2, textureSizeCard, textureOffsetCard[14]); 

        GenerateBezierMesh(arrayMeshFront,      meshWidthFront,  meshHeightFront);
        GenerateBezierMesh(arrayMeshBack,       meshWidthBack,   meshHeightBack);                                         
        GenerateBezierMesh(arrayMeshShadow,     meshWidthShadow, meshHeightShadow);
        GenerateBezierMesh(arrayMeshBackSimple, 2, 2);                                         

        self.isHeld     = [AnimatedFloat floatWithValue:held];
        self.isFlipped  = [AnimatedFloat floatWithValue:0];
        self.angleFan   = [AnimatedFloat floatWithValue:0];
        self.bendFactor = [AnimatedFloat floatWithValue:0];
        self.dealt      = [AnimatedFloat floatWithValue:0];
        self.death      = [AnimatedFloat floatWithValue:0];
    }
    
    return self;
}

-(BOOL)isEqual:(id)object
{
    GLCard* card = (GLCard*)object;
    
    if(card.suit    != self.suit)    { return NO; }
    if(card.numeral != self.numeral) { return NO; }
    
    return YES;
}

-(void)drawFront
{   
    GLfloat bendOpacity = easeInOut(self.bendFactor.value, 0.2, 0.6); 
    GLfloat flipOpacity = easeInOut(1.0 - self.isFlipped.value, 0.4, 0.6);
    GLfloat heldOpacity = easeInOut(self.isHeld.value + bendOpacity * flipOpacity * 0.7, 0.0, 1.0);
    
    GLfloat deathOpacity = MIN(-4.0 * (1.0 + self.death.value - self.dealt.value) + 4.0, 1.0);
    
    GLfloat opacity = heldOpacity * deathOpacity;
    
    if(within(opacity, 0, 0.001)) { return; }

    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
    GLfloat lightness = self.cardGroup.player.renderer.lightness.value;
    
    glColor4f(lightness, lightness, lightness, opacity);
    
    glVertexPointer  (3, GL_FLOAT, 0, arrayVertexFront);
    glNormalPointer  (   GL_FLOAT, 0, arrayNormalFront);
            
    glClientActiveTexture(GL_TEXTURE0); 
    glActiveTexture(GL_TEXTURE0); 
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"cards"]);
    glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0Front);      
    
    glClientActiveTexture(GL_TEXTURE1); 
    glActiveTexture(GL_TEXTURE1); 
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:[NSString stringWithFormat:@"suit%d", _suit]]);
    glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture1Front);      
    
    glDrawElements(GL_TRIANGLES, (meshWidthFront - 1) * (meshHeightFront - 1) * 6, GL_UNSIGNED_SHORT, arrayMeshFront);
    
    glClientActiveTexture(GL_TEXTURE1); 
    glActiveTexture(GL_TEXTURE1); 
    glBindTexture(GL_TEXTURE_2D, 0);
    glClientActiveTexture(GL_TEXTURE0); 
    glActiveTexture(GL_TEXTURE0); 
}

-(void)drawBack
{
    GLfloat bendOpacity = easeInOut(self.bendFactor.value, 0.2, 0.6); 
    GLfloat flipOpacity = easeInOut(1.0 - self.isFlipped.value, 0.4, 0.6);
    GLfloat heldOpacity = easeInOut(self.isHeld.value + bendOpacity * flipOpacity * 0.7, 0.0, 1.0);
    
    GLfloat deathOpacity = MIN(-4.0 * (1.0 + self.death.value - self.dealt.value) + 4.0, 1.0);
    
    GLfloat opacity = heldOpacity * deathOpacity;
            
    if(within(opacity, 0, 0.001)) { return; }
        
    if(within(self.bendFactor.value, 0, 0.001))
    {
        GLfloat lightness = self.cardGroup.player.renderer.lightness.value;
    
        glColor4f(lightness, lightness, lightness, opacity);
        
        glVertexPointer  (3, GL_FLOAT, 0, arrayVertexBackSimple);                                                                             
        glNormalPointer  (   GL_FLOAT, 0, arrayNormalBackSimple);                                                                             
        
        glClientActiveTexture(GL_TEXTURE0); 
        glActiveTexture(GL_TEXTURE0); 
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"cards"]);
        glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0BackSimple);      
        
        glClientActiveTexture(GL_TEXTURE1); 
        glActiveTexture(GL_TEXTURE1); 
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"suit0"]);
        glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture1BackSimple);      
        
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, arrayMeshBackSimple);
        
        glClientActiveTexture(GL_TEXTURE1); 
        glActiveTexture(GL_TEXTURE1); 
        glBindTexture(GL_TEXTURE_2D, 0);
        glClientActiveTexture(GL_TEXTURE0); 
        glActiveTexture(GL_TEXTURE0); 
    }
    else 
    {
        GLfloat lightness = self.cardGroup.player.renderer.lightness.value;
                    
        glColor4f(lightness, lightness, lightness, opacity);
            
        glVertexPointer  (3, GL_FLOAT, 0, arrayVertexBack);                                                                             
        glNormalPointer  (   GL_FLOAT, 0, arrayNormalBack);                                                                             
            
        glClientActiveTexture(GL_TEXTURE0); 
        glActiveTexture(GL_TEXTURE0); 
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"cards"]);
        glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0Back);      
        
        glClientActiveTexture(GL_TEXTURE1); 
        glActiveTexture(GL_TEXTURE1); 
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"suit0"]);
        glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture1Back);      
            
        glDrawElements(GL_TRIANGLES, (meshWidthBack - 1) * (meshHeightBack - 1) * 6, GL_UNSIGNED_SHORT, arrayMeshBack);
        
        glClientActiveTexture(GL_TEXTURE1); 
        glActiveTexture(GL_TEXTURE1); 
        glBindTexture(GL_TEXTURE_2D, 0);
        glClientActiveTexture(GL_TEXTURE0); 
        glActiveTexture(GL_TEXTURE0); 
    }
}

-(void)drawShadow
{
    GLfloat bendOpacity = easeInOut(self.bendFactor.value, 0.2, 0.6); 
    GLfloat flipOpacity = easeInOut(1.0 - self.isFlipped.value, 0.4, 0.6);
    GLfloat heldOpacity = easeInOut(self.isHeld.value + bendOpacity * flipOpacity * 0.7, 0.0, 1.0);
    
    GLfloat deathOpacity = MIN(-4.0 * (1.0 + self.death.value - self.dealt.value) + 4.0, 1.0);
    
    GLfloat opacity = heldOpacity * deathOpacity;
                
    if(within(opacity, 0, 0.001)) { return; }

    glDisable(GL_CULL_FACE);
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"shadow"]);
                        
    glColor4f(1, 1, 1, opacity);

    glVertexPointer  (3, GL_FLOAT, 0, arrayVertexShadow);
    glNormalPointer  (   GL_FLOAT, 0, arrayNormalShadow);
    glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0Shadow);            
    
    glDrawElements(GL_TRIANGLES, (meshWidthShadow - 1) * (meshHeightShadow - 1) * 6, GL_UNSIGNED_SHORT, arrayMeshShadow);
    
    glEnable(GL_CULL_FACE);
}

-(void)drawLabel
{
    if(!self.cardGroup.showLabels) { return; }

    GLfloat bendOpacity = easeInOut(self.bendFactor.value, 0.2, 0.6); 
    GLfloat flipOpacity = easeInOut(1.0 - self.isFlipped.value, 0.4, 0.6);
    GLfloat heldOpacity = easeInOut(self.isHeld.value + bendOpacity * flipOpacity * 0.7, 0.0, 1.0);
    
    GLfloat deathOpacity = MIN(-4.0 * (1.0 + self.death.value - self.dealt.value) + 4.0, 1.0);
    
    GLfloat opacity = heldOpacity * deathOpacity;
    
    if(within(opacity, 0, 0.001)) { return; }
    
    //TODO: FIX THIS STUFF LATER
    
    if(self.isFlipped.value < 0.5)
    {        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
        vec3 arrayVertex  [4];
        vec3 arrayNormal  [4];
        vec2 arrayTexture0[4];
        GLushort arrayMesh    [6];
        
        //GLushort arrayMesh[6];  
        
        GenerateBezierVertices(arrayVertex,  2, 2, controlPointsLabel);
        GenerateBezierNormals (arrayNormal,  2, 2, controlPointsLabel);
        GenerateBezierMesh    (arrayMesh,    2, 2);
        
        glVertexPointer  (3, GL_FLOAT, 0, arrayVertex);
        glNormalPointer  (   GL_FLOAT, 0, arrayNormal);

        // HOLD
        {
            glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"hold"]);
                            
            glColor4f(1, 1, 1, opacity * self.isHeld.value);
                        
            GenerateBezierTextures(arrayTexture0, 2, 2, vec2Make(1,1), vec2Make(0,0));
            
            glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0);
            
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, arrayMesh);
        }
        
        // DRAW
        {
            glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"draw"]);
            
            glColor4f(1, 1, 1, opacity * (1.0 - self.isHeld.value) / 2.0);
            
            GenerateBezierTextures(arrayTexture0, 2, 2, vec2Make(1,1), vec2Make(0,0));
            
            glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0);
            
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, arrayMesh);
        }
    }
}

-(void)makeControlPoints
{
    if(!self.isMeshAnimating) { return; }
    
    vec3 baseCorners[] = 
    {
        vec3Make( 2.0,  0.0,  3.0),
        vec3Make( 2.0,  0.0, -3.0),
        vec3Make(-2.0,  0.0,  3.0),
        vec3Make(-2.0,  0.0, -3.0)
    };
    
    vec3 labelCorners[] = 
    {
        vec3Make( 0.0,  0.0,  3.0),
        vec3Make( 0.0,  0.0,  3.5),
        vec3Make( 1.2,  0.0,  3.0),
        vec3Make( 1.2,  0.0,  3.5)
    };

    GenerateBezierControlPoints(controlPointsBase,  baseCorners);
    GenerateBezierControlPoints(controlPointsLabel, labelCorners);
        
    controlPointsFront[ 0] = controlPointsBase[ 0];
    controlPointsFront[ 1] = controlPointsBase[ 1];
    controlPointsFront[ 2] = controlPointsBase[ 2];
    controlPointsFront[ 3] = controlPointsBase[ 3];
    
    controlPointsFront[ 4] = controlPointsBase[ 4];
    controlPointsFront[ 5] = controlPointsBase[ 5];
    controlPointsFront[ 6] = controlPointsBase[ 6];
    controlPointsFront[ 7] = controlPointsBase[ 7];
    
    controlPointsFront[ 8] = controlPointsBase[ 8];
    controlPointsFront[ 9] = controlPointsBase[ 9];
    controlPointsFront[10] = controlPointsBase[10];
    controlPointsFront[11] = controlPointsBase[11];
    
    controlPointsFront[12] = controlPointsBase[12];
    controlPointsFront[13] = controlPointsBase[13];
    controlPointsFront[14] = controlPointsBase[14];
    controlPointsFront[15] = controlPointsBase[15];
        
    controlPointsBack[ 0]  = controlPointsBase[ 3];
    controlPointsBack[ 1]  = controlPointsBase[ 2];
    controlPointsBack[ 2]  = controlPointsBase[ 1];
    controlPointsBack[ 3]  = controlPointsBase[ 0];
    
    controlPointsBack[ 4]  = controlPointsBase[ 7];
    controlPointsBack[ 5]  = controlPointsBase[ 6];
    controlPointsBack[ 6]  = controlPointsBase[ 5];
    controlPointsBack[ 7]  = controlPointsBase[ 4];
    
    controlPointsBack[ 8]  = controlPointsBase[11];
    controlPointsBack[ 9]  = controlPointsBase[10];
    controlPointsBack[10]  = controlPointsBase[ 9];
    controlPointsBack[11]  = controlPointsBase[ 8];
    
    controlPointsBack[12]  = controlPointsBase[15];
    controlPointsBack[13]  = controlPointsBase[14];
    controlPointsBack[14]  = controlPointsBase[13];
    controlPointsBack[15]  = controlPointsBase[12];
    
    controlPointsShadow[ 0] = controlPointsBase[ 3];
    controlPointsShadow[ 1] = controlPointsBase[ 2];
    controlPointsShadow[ 2] = controlPointsBase[ 1];
    controlPointsShadow[ 3] = controlPointsBase[ 0];
    
    controlPointsShadow[ 4] = controlPointsBase[ 7];
    controlPointsShadow[ 5] = controlPointsBase[ 6];
    controlPointsShadow[ 6] = controlPointsBase[ 5];
    controlPointsShadow[ 7] = controlPointsBase[ 4];
    
    controlPointsShadow[ 8] = controlPointsBase[11];
    controlPointsShadow[ 9] = controlPointsBase[10];
    controlPointsShadow[10] = controlPointsBase[ 9];
    controlPointsShadow[11] = controlPointsBase[ 8];
    
    controlPointsShadow[12] = controlPointsBase[15];
    controlPointsShadow[13] = controlPointsBase[14];
    controlPointsShadow[14] = controlPointsBase[13];
    controlPointsShadow[15] = controlPointsBase[12];
    
    GLfloat angleflip = self.isFlipped.value * 180;
    
    [self rotateWithAngle:angleflip aroundPoint:vec3Make(0.0, 0.0, 0.0) andAxis:vec3Make(0.0, 0.0, 1.0)];
    [self rotateWithAngle:self.angleJitter aroundPoint:vec3Make(0.0, 0.0, 0.0) andAxis:vec3Make(0.0, 1.0, 0.0)];
    [self rotateWithAngle:self.bendFactor.value * self.angleFan.value aroundPoint:vec3Make(0.0, 0.0, -25.0) andAxis:vec3Make(0.0, 1.0, 0.0)];
    
    [self bendWithAngle:self.bendFactor.value * 108 aroundPoint:vec3Make(0.0, 0.0, 0.0) andAxis:vec3Make(1.0, 0.0, 0.0)];
    
    [self scaleWithFactor:vec3Make(1.0, 1.2, 1.0) fromPoint:vec3Make(0.0, 0.0, 0.0)];
    
    [self translateWithVector:vec3Make(self.isFlipped.value * self.angleFan.value * 0.7, -1.0 * sin(DEGREES_TO_RADIANS(self.isFlipped.value * 180)), -30 * (1 + self.death.value - self.dealt.value))];
    
    [self flattenShadow];

    GenerateBezierVertices(arrayVertexFront,  meshWidthFront,  meshHeightFront,  controlPointsFront);
    GenerateBezierVertices(arrayVertexBack,   meshWidthBack,   meshHeightBack,   controlPointsBack);                             
    GenerateBezierVertices(arrayVertexShadow, meshWidthShadow, meshHeightShadow, controlPointsShadow);
    GenerateBezierVertices(arrayVertexBackSimple, 2, 2, controlPointsBack);                             

    GenerateBezierNormals(arrayNormalFront,  meshWidthFront,  meshHeightFront,  controlPointsFront);
    GenerateBezierNormals(arrayNormalBack,   meshWidthBack,   meshHeightBack,   controlPointsBack);                      
    GenerateBezierNormals(arrayNormalShadow, meshWidthShadow, meshHeightShadow, controlPointsShadow);
    GenerateBezierNormals(arrayNormalBackSimple, 2, 2, controlPointsBack);                      
}

-(void)rotateWithAngle:(GLfloat)angle aroundPoint:(vec3)point andAxis:(vec3)axis
{   
    rotateVectors(controlPointsShadow, 16, angle, point, axis);
    rotateVectors(controlPointsFront,  16, angle, point, axis);
    rotateVectors(controlPointsBack,   16, angle, point, axis);
    rotateVectors(controlPointsLabel,  16, angle, point, axis);
}

-(void)bendWithAngle:(GLfloat)angle aroundPoint:(vec3)point andAxis:(vec3)axis
{   
    rotateVectors(controlPointsShadow,  8, angle, point, axis);
    rotateVectors(controlPointsFront,   8, angle, point, axis);
    rotateVectors(controlPointsBack,    8, angle, point, axis);
    rotateVectors(controlPointsLabel,  16, angle, point, axis);
}

-(void)scaleWithFactor:(vec3)factor fromPoint:(vec3)point
{
    for(int i = 0; i < 16; i++)
    {
        controlPointsShadow[i].x = (controlPointsShadow[i].x - point.x) * factor.x + point.x;
        controlPointsShadow[i].y = (controlPointsShadow[i].y - point.y) * factor.y + point.y;
        controlPointsShadow[i].z = (controlPointsShadow[i].z - point.z) * factor.z + point.z;
        
        controlPointsFront[i].x  = (controlPointsFront[i].x  - point.x) * factor.x + point.x;
        controlPointsFront[i].y  = (controlPointsFront[i].y  - point.y) * factor.y + point.y;
        controlPointsFront[i].z  = (controlPointsFront[i].z  - point.z) * factor.z + point.z;
        
        controlPointsBack[i].x   = (controlPointsBack[i].x   - point.x) * factor.x + point.x;
        controlPointsBack[i].y   = (controlPointsBack[i].y   - point.y) * factor.y + point.y;
        controlPointsBack[i].z   = (controlPointsBack[i].z   - point.z) * factor.z + point.z;
        
        controlPointsLabel[i].x  = (controlPointsLabel[i].x   - point.x) * factor.x + point.x;
        controlPointsLabel[i].y  = (controlPointsLabel[i].y   - point.y) * factor.y + point.y;
        controlPointsLabel[i].z  = (controlPointsLabel[i].z   - point.z) * factor.z + point.z;
    }
}

-(void)scaleShadowWithFactor:(vec3)factor fromPoint:(vec3)point
{
    for(int i = 0; i < 16; i++)
    {
        controlPointsShadow[i].x = (controlPointsShadow[i].x - point.x) * factor.x + point.x;
        controlPointsShadow[i].y = (controlPointsShadow[i].y - point.y) * factor.y + point.y;
        controlPointsShadow[i].z = (controlPointsShadow[i].z - point.z) * factor.z + point.z;
    }
}

-(void)translateWithVector:(vec3)vector
{
    for(int i = 0; i < 16; i++)
    {
        controlPointsShadow[i].x = controlPointsShadow[i].x + vector.x;
        controlPointsShadow[i].y = controlPointsShadow[i].y + vector.y;
        controlPointsShadow[i].z = controlPointsShadow[i].z + vector.z;
        
        controlPointsFront[i].x  = controlPointsFront[i].x  + vector.x;
        controlPointsFront[i].y  = controlPointsFront[i].y  + vector.y;
        controlPointsFront[i].z  = controlPointsFront[i].z  + vector.z;
        
        controlPointsBack[i].x   = controlPointsBack[i].x   + vector.x;
        controlPointsBack[i].y   = controlPointsBack[i].y   + vector.y;
        controlPointsBack[i].z   = controlPointsBack[i].z   + vector.z;
        
        controlPointsLabel[i].x   = controlPointsLabel[i].x   + vector.x;
        controlPointsLabel[i].y   = controlPointsLabel[i].y   + vector.y;
        controlPointsLabel[i].z   = controlPointsLabel[i].z   + vector.z;
    }
}

-(void)flattenShadow
{
    vec3 light = vec3Make(0, -20, 0);
    
    for(int i = 0; i < 16; i++)
    {
        controlPointsShadow[i] = vec3ProjectShadow(light, controlPointsShadow[i]);
    }
}

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    GLfloat model_view[16];
    glGetFloatv(GL_MODELVIEW_MATRIX, model_view);
    
    GLfloat projection[16];
    glGetFloatv(GL_PROJECTION_MATRIX, projection);
    
    GLint viewport[4];
    glGetIntegerv(GL_VIEWPORT, viewport);
    
    vec2 points[16];
    ProjectVectors(controlPointsFront, points, 16, model_view, projection, viewport);
    
    GLushort triangles[54];
    GenerateBezierMesh(triangles, 4, 4);
    
    CGPoint touchPoint = [touch locationInView:touch.view];
    
    vec2 touchLocation = vec2Make(touchPoint.x, UIScreen.mainScreen.bounds.size.height - touchPoint.y);
        
    return TestTriangles(touchLocation, points, triangles, 18) ? self : object;
}

-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point
{
    self.cancelTap = NO;
    
    GLfloat angle = self.cardGroup.player.renderer.camera.pitchAngle.value * self.cardGroup.player.renderer.camera.pitchFactor.value;
    
    if(angle > 60)
    {
        [self.cardGroup startDragForCard:self];
    }
}

-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    GLfloat deltaX = pointTo.x - pointFrom.x;
    GLfloat deltaY = pointTo.y - pointFrom.y;

    if(!self.cancelTap)
    {
        GLfloat distance = sqrt(deltaX * deltaX + deltaY * deltaY);

        self.cancelTap = distance > 10;
    }

    int target = 5 - ((pointTo.y) / 96.0);
    
    if(target < 0) { target = 0; }
    if(target > 4) { target = 4; }
        
    [self.cardGroup dragCardToTarget:target withDelta:deltaY];
}

-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    GLfloat angle = self.cardGroup.player.renderer.camera.pitchAngle.value * self.cardGroup.player.renderer.camera.pitchFactor.value;
    
    [self.cardGroup stopDrag];
        
    if(!self.cancelTap)
    {
        if(angle > 60)
        {
            [self.cardGroup.player.renderer.gameController cardFrontTapped:self.position];
        }
        else
        {            
            [self.cardGroup.player.renderer.gameController cardBackTapped:self.position];
        }
    }
    
    self.cancelTap = NO;
}


-(BOOL)isAlive { return within(self.death.endValue, 0, 0.001); }
-(BOOL)isDead  { return within(self.death.value,    1, 0.001); }

-(void)absorb:(id<Displayable>)newObject
{
    if([newObject isKindOfClass:[GLCard class]])
    {
        GLCard* newCard = (GLCard*)newObject;
    
        [self.isHeld setValue:newCard.isHeld.value withSpeed:3];
    }
}

-(void)dieAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work
{
    [self.death setValue:1 forTime:1 afterDelay:delay andThen:work];
}

@end