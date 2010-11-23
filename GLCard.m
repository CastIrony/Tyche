#import "Common.h"
#import "Geometry.h"
#import "Bezier.h"
#import "GLTexture.h"
#import "Projection.h"
#import "GLCardGroup.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "GameRenderer.h"
#import "DisplayContainer.h"
#import "TextureController.h"
#import "CameraController.h"

#import "GLCard.h"

@implementation GLCard

@synthesize cardGroup   = _cardGroup;
@synthesize angleJitter = _angleJitter;
@synthesize suit        = _suit;
@synthesize numeral     = _numeral;
@synthesize position    = _position;
@synthesize location   = _location;
@synthesize dealt      = _dealt;
@synthesize death      = _death;
@synthesize isHeld     = _isHeld;
@synthesize isSelected = _isSelected;
@synthesize bendFactor = _bendFactor;
@synthesize angleFlip  = _angleFlip;
@synthesize angleFan   = _angleFan;

@dynamic isMeshAnimating;
@dynamic key;

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

-(BOOL)isMeshAnimating
{    
    return 1; //!self.bendFactor.hasEnded || !self.angleFlip.hasEnded || !self.angleFan.hasEnded || !self.location.hasEnded;
}

-(NSString*)key
{    
    return [NSString stringWithFormat:@"%d-%d", self.suit, self.numeral];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"Card with suit:%d numeral:%d", self.suit, self.numeral];
}

+(GLCard*)cardWithKey:(NSString*)key
{
    NSArray* components = [key componentsSeparatedByString:@"-"];
    
    int suit    = [[components objectAtIndex:0] intValue];    
    int numeral = [[components objectAtIndex:1] intValue];
    
    return [[[GLCard alloc]initWithSuit:suit numeral:numeral] autorelease];
}
    
-(id)initWithSuit:(int)suit numeral:(int)numeral
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
        
        arrayVertexFront      = malloc(meshWidthFront  * meshHeightFront  * sizeof(Vector3D));
        arrayVertexBack       = malloc(meshWidthBack   * meshHeightBack   * sizeof(Vector3D));
        arrayVertexShadow     = malloc(meshWidthShadow * meshHeightShadow * sizeof(Vector3D));
        arrayVertexBackSimple = malloc(4 * sizeof(Vector3D));
        
        arrayNormalFront      = malloc(meshWidthFront  * meshHeightFront  * sizeof(Vector3D));
        arrayNormalBack       = malloc(meshWidthBack   * meshHeightBack   * sizeof(Vector3D));
        arrayNormalShadow     = malloc(meshWidthShadow * meshHeightShadow * sizeof(Vector3D));
        arrayNormalBackSimple = malloc(4 * sizeof(Vector3D));
        
        arrayTexture0Front      = malloc(meshWidthFront  * meshHeightFront  * sizeof(Vector2D));
        arrayTexture0Back       = malloc(meshWidthBack   * meshHeightBack   * sizeof(Vector2D));
        arrayTexture0Shadow     = malloc(meshWidthShadow * meshHeightShadow * sizeof(Vector2D));
        arrayTexture0BackSimple = malloc(4 * sizeof(Vector2D));
        
        arrayTexture1Front      = malloc(meshWidthFront  * meshHeightFront  * sizeof(Vector2D));
        arrayTexture1Back       = malloc(meshWidthBack   * meshHeightBack   * sizeof(Vector2D));
        arrayTexture1BackSimple = malloc(4 * sizeof(Vector2D));
        
        arrayMeshFront      = malloc((meshWidthFront  - 1) * (meshHeightFront  - 1) * 6 * sizeof(GLushort));
        arrayMeshBack       = malloc((meshWidthBack   - 1) * (meshHeightBack   - 1) * 6 * sizeof(GLushort));
        arrayMeshShadow     = malloc((meshWidthShadow - 1) * (meshHeightShadow - 1) * 6 * sizeof(GLushort));
        arrayMeshBackSimple = malloc(6 * sizeof(GLushort));
        
        textureSizeCard     = Vector2DMake(172.0 / 1024.0, 252.0 / 1024.0);
        textureSizeLabel    = Vector2DMake(116.0 / 1024.0,  62.0 / 1024.0);
        
        textureOffsetCard[ 0] = Vector2DMake(826.0 / 1024.0, 702.0 / 1024.0); // Shadow
        textureOffsetCard[ 1] = Vector2DMake( 26.0 / 1024.0,  36.0 / 1024.0); // Ace
        textureOffsetCard[ 2] = Vector2DMake(226.0 / 1024.0,  36.0 / 1024.0); // 2
        textureOffsetCard[ 3] = Vector2DMake(428.0 / 1024.0,  36.0 / 1024.0); // 3
        textureOffsetCard[ 4] = Vector2DMake(626.0 / 1024.0,  36.0 / 1024.0); // 4
        textureOffsetCard[ 5] = Vector2DMake(826.0 / 1024.0,  36.0 / 1024.0); // 5
        textureOffsetCard[ 6] = Vector2DMake( 26.0 / 1024.0, 369.0 / 1024.0); // 6
        textureOffsetCard[ 7] = Vector2DMake(226.0 / 1024.0, 369.0 / 1024.0); // 7
        textureOffsetCard[ 8] = Vector2DMake(426.0 / 1024.0, 369.0 / 1024.0); // 8
        textureOffsetCard[ 9] = Vector2DMake(626.0 / 1024.0, 369.0 / 1024.0); // 9
        textureOffsetCard[10] = Vector2DMake(826.0 / 1024.0, 369.0 / 1024.0); // 10
        textureOffsetCard[11] = Vector2DMake( 26.0 / 1024.0, 702.0 / 1024.0); // Jack
        textureOffsetCard[12] = Vector2DMake(226.0 / 1024.0, 702.0 / 1024.0); // Queen
        textureOffsetCard[13] = Vector2DMake(426.0 / 1024.0, 702.0 / 1024.0); // King
        textureOffsetCard[14] = Vector2DMake(626.0 / 1024.0, 702.0 / 1024.0); // Back
        
        GenerateBezierTextures(arrayTexture0Front,  meshWidthFront,  meshHeightFront,  Vector2DMake(1, 1), Vector2DMake(0, 0));
        GenerateBezierTextures(arrayTexture0Back,   meshWidthBack,   meshHeightBack,   Vector2DMake(1, 1), Vector2DMake(0, 0)); 
        GenerateBezierTextures(arrayTexture0Shadow, meshWidthShadow, meshHeightShadow, textureSizeCard, textureOffsetCard[0]);
        GenerateBezierTextures(arrayTexture1Front,  meshWidthFront,  meshHeightFront,  textureSizeCard, textureOffsetCard[self.numeral]);
        GenerateBezierTextures(arrayTexture1Back,   meshWidthBack,   meshHeightBack,   textureSizeCard, textureOffsetCard[14]); 
        
        GenerateBezierTextures(arrayTexture0BackSimple, 2, 2, Vector2DMake(1, 1), Vector2DMake(0, 0)); 
        GenerateBezierTextures(arrayTexture1BackSimple, 2, 2, textureSizeCard, textureOffsetCard[14]); 

        GenerateBezierMesh(arrayMeshFront,      meshWidthFront,  meshHeightFront);
        GenerateBezierMesh(arrayMeshBack,       meshWidthBack,   meshHeightBack);                                         
        GenerateBezierMesh(arrayMeshShadow,     meshWidthShadow, meshHeightShadow);
        GenerateBezierMesh(arrayMeshBackSimple, 2, 2);                                         

        self.isHeld     = [AnimatedFloat withValue:0];
        self.isSelected = [AnimatedFloat withValue:0];
        self.angleFlip  = [AnimatedFloat withValue:0];
        self.angleFan   = [AnimatedFloat withValue:0];
        self.bendFactor = [AnimatedFloat withValue:0];
        self.dealt      = [AnimatedFloat withValue:0];
        self.death      = [AnimatedFloat withValue:0];
        self.location   = [AnimatedFloat withValue:0];
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
    TRANSACTION_BEGIN
    {    
        glTranslatef(self.location.value, -1.0 * sin(DEGREES_TO_RADIANS(self.angleFlip.value)), -30 * (1 + self.death.value - self.dealt.value));
    
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            
        GLfloat held = self.isHeld.value * 0.5 + 0.5;
        GLfloat lightness = self.cardGroup.renderer.lightness.value;
        
        glColor4f(lightness, lightness, lightness, held);
        
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
    TRANSACTION_END
}

-(void)drawBack
{
    TRANSACTION_BEGIN
    {    
        glTranslatef(self.location.value, -1.0 * sin(DEGREES_TO_RADIANS(self.angleFlip.value)), -30 * (1 + self.death.value - self.dealt.value));
        
        if(within(self.bendFactor.value, 0, 0.001))
        {
            GLfloat held = self.isHeld.value     * 0.5 + 0.5;
            
            GLfloat lightness = self.cardGroup.renderer.lightness.value;
            
            glColor4f(lightness, lightness, lightness, held);
            
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
            GLfloat held = self.isHeld.value     * 0.5 + 0.5;
            
            GLfloat lightness = self.cardGroup.renderer.lightness.value;
            
            glColor4f(lightness, lightness, lightness, held);
                
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
    TRANSACTION_END
}

-(void)drawShadow
{
    TRANSACTION_BEGIN
    {    
        glTranslatef(self.location.value, -1.0 * sin(DEGREES_TO_RADIANS(self.angleFlip.value)), -30 * (1 + self.death.value - self.dealt.value));
        
        glDisable(GL_CULL_FACE);
        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"suit0"]);
        
        GLfloat held = self.isHeld.value * 0.5 + 0.5;
        
        glColor4f(1, 1, 1, held);    
            
        glVertexPointer  (3, GL_FLOAT, 0, arrayVertexShadow);
        glNormalPointer  (   GL_FLOAT, 0, arrayNormalShadow);
        glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0Shadow);            
        
        glDrawElements(GL_TRIANGLES, (meshWidthShadow - 1) * (meshHeightShadow - 1) * 6, GL_UNSIGNED_SHORT, arrayMeshShadow);
        
        glEnable(GL_CULL_FACE);
    }
    TRANSACTION_END
}

-(void)drawLabel
{
    TRANSACTION_BEGIN
    {    
        glTranslatef(self.location.value, -1.0 * sin(DEGREES_TO_RADIANS(self.angleFlip.value)), -30 * (1 + self.death.value - self.dealt.value));
    
        //TODO: FIX THIS STUFF LATER
        
        if(self.angleFlip.value < 90)
        {        
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
            Vector3D arrayVertex  [4];
            Vector3D arrayNormal  [4];
            Vector2D arrayTexture0[4];
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
                
                glColor4f(1, 1, 1, self.isHeld.value);
                            
                GenerateBezierTextures(arrayTexture0, 2, 2, Vector2DMake(1,1), Vector2DMake(0,0));
                
                glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0);
                
                glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, arrayMesh);
            }
            
            // DRAW
            {
                glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"draw"]);
                
                glColor4f(1, 1, 1, (1 - self.isHeld.value) / 2);
                
                GenerateBezierTextures(arrayTexture0, 2, 2, Vector2DMake(1,1), Vector2DMake(0,0));
                
                glTexCoordPointer(2, GL_FLOAT, 0, arrayTexture0);
                
                glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, arrayMesh);
            }
        }
    }
    TRANSACTION_END
}

-(void)makeControlPoints
{
    if(!self.isMeshAnimating) { return; }
    
    Vector3D baseCorners[] = 
    {
        Vector3DMake( 2.0,  0.0,  3.0),
        Vector3DMake( 2.0,  0.0, -3.0),
        Vector3DMake(-2.0,  0.0,  3.0),
        Vector3DMake(-2.0,  0.0, -3.0)
    };
    
    Vector3D labelCorners[] = 
    {
        Vector3DMake(-0.6,  0.0,  3.0),
        Vector3DMake(-0.6,  0.0,  3.5),
        Vector3DMake( 0.6,  0.0,  3.0),
        Vector3DMake( 0.6,  0.0,  3.5)
    };

    GenerateBezierControlPoints(controlPointsBase,  baseCorners);
    GenerateBezierControlPoints(controlPointsLabel, labelCorners);
        
    controlPointsFront[ 0] = controlPointsBase [ 0];
    controlPointsFront[ 1] = controlPointsBase [ 1];
    controlPointsFront[ 2] = controlPointsBase [ 2];
    controlPointsFront[ 3] = controlPointsBase [ 3];
    
    controlPointsFront[ 4] = controlPointsBase [ 4];
    controlPointsFront[ 5] = controlPointsBase [ 5];
    controlPointsFront[ 6] = controlPointsBase [ 6];
    controlPointsFront[ 7] = controlPointsBase [ 7];
    
    controlPointsFront[ 8] = controlPointsBase [ 8];
    controlPointsFront[ 9] = controlPointsBase [ 9];
    controlPointsFront[10] = controlPointsBase [10];
    controlPointsFront[11] = controlPointsBase [11];
    
    controlPointsFront[12] = controlPointsBase [12];
    controlPointsFront[13] = controlPointsBase [13];
    controlPointsFront[14] = controlPointsBase [14];
    controlPointsFront[15] = controlPointsBase [15];
        
    controlPointsBack[ 0]  = controlPointsBase [ 3];
    controlPointsBack[ 1]  = controlPointsBase [ 2];
    controlPointsBack[ 2]  = controlPointsBase [ 1];
    controlPointsBack[ 3]  = controlPointsBase [ 0];
    
    controlPointsBack[ 4]  = controlPointsBase [ 7];
    controlPointsBack[ 5]  = controlPointsBase [ 6];
    controlPointsBack[ 6]  = controlPointsBase [ 5];
    controlPointsBack[ 7]  = controlPointsBase [ 4];
    
    controlPointsBack[ 8]  = controlPointsBase [11];
    controlPointsBack[ 9]  = controlPointsBase [10];
    controlPointsBack[10]  = controlPointsBase [ 9];
    controlPointsBack[11]  = controlPointsBase [ 8];
    
    controlPointsBack[12]  = controlPointsBase [15];
    controlPointsBack[13]  = controlPointsBase [14];
    controlPointsBack[14]  = controlPointsBase [13];
    controlPointsBack[15]  = controlPointsBase [12];
    
    controlPointsShadow[ 0] = controlPointsBase [ 3];
    controlPointsShadow[ 1] = controlPointsBase [ 2];
    controlPointsShadow[ 2] = controlPointsBase [ 1];
    controlPointsShadow[ 3] = controlPointsBase [ 0];
    
    controlPointsShadow[ 4] = controlPointsBase [ 7];
    controlPointsShadow[ 5] = controlPointsBase [ 6];
    controlPointsShadow[ 6] = controlPointsBase [ 5];
    controlPointsShadow[ 7] = controlPointsBase [ 4];
    
    controlPointsShadow[ 8] = controlPointsBase [11];
    controlPointsShadow[ 9] = controlPointsBase [10];
    controlPointsShadow[10] = controlPointsBase [ 9];
    controlPointsShadow[11] = controlPointsBase [ 8];
    
    controlPointsShadow[12] = controlPointsBase [15];
    controlPointsShadow[13] = controlPointsBase [14];
    controlPointsShadow[14] = controlPointsBase [13];
    controlPointsShadow[15] = controlPointsBase [12];
    
    [self rotateWithAngle:self.angleFlip.value aroundPoint:Vector3DMake(0.0, 0.0, 0.0) andAxis:Vector3DMake(0.0, 0.0, 1.0)];
    [self rotateWithAngle:self.angleJitter aroundPoint:Vector3DMake(0.0, 0.0, 0.0) andAxis:Vector3DMake(0.0, 1.0, 0.0)];
    [self rotateWithAngle:self.bendFactor.value * self.angleFan.value aroundPoint:Vector3DMake(0.0, 0.0, -30.0) andAxis:Vector3DMake(0.0, 1.0, 0.0)];
    
    [self bendWithAngle:self.bendFactor.value * 108 aroundPoint:Vector3DMake(0.0, 0.0, 0.0) andAxis:Vector3DMake(1.0, 0.0, 0.0)];
    
    [self scaleWithFactor:Vector3DMake(1.0, 1.2, 1.0) fromPoint:Vector3DMake(0.0, 0.0, 0.0)];
    
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

-(void)rotateWithAngle:(GLfloat)angle aroundPoint:(Vector3D)point andAxis:(Vector3D)axis
{   
    rotateVectors(controlPointsShadow, 16, angle, point, axis);
    rotateVectors(controlPointsFront,  16, angle, point, axis);
    rotateVectors(controlPointsBack,   16, angle, point, axis);
    rotateVectors(controlPointsLabel,  16, angle, point, axis);
}

-(void)bendWithAngle:(GLfloat)angle aroundPoint:(Vector3D)point andAxis:(Vector3D)axis
{   
    rotateVectors(controlPointsShadow,  8, angle, point, axis);
    rotateVectors(controlPointsFront,   8, angle, point, axis);
    rotateVectors(controlPointsBack,    8, angle, point, axis);
    rotateVectors(controlPointsLabel,  16, angle, point, axis);
}

-(void)scaleWithFactor:(Vector3D)factor fromPoint:(Vector3D)point
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

-(void)scaleShadowWithFactor:(Vector3D)factor fromPoint:(Vector3D)point
{
    for(int i = 0; i < 16; i++)
    {
        controlPointsShadow[i].x = (controlPointsShadow[i].x - point.x) * factor.x + point.x;
        controlPointsShadow[i].y = (controlPointsShadow[i].y - point.y) * factor.y + point.y;
        controlPointsShadow[i].z = (controlPointsShadow[i].z - point.z) * factor.z + point.z;
    }
}

-(void)translateWithVector:(Vector3D)vector
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
    Vector3D light = Vector3DMake(0, -20, 0);
    
    for(int i = 0; i < 16; i++)
    {
        controlPointsShadow[i] = Vector3DProjectShadow(light, controlPointsShadow[i]);
    }
}

@end

@implementation GLCard (Touchable)

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    TRANSACTION_BEGIN
    {    
        glTranslatef(self.location.value, -1.0 * sin(DEGREES_TO_RADIANS(self.angleFlip.value)), -30 * (1 + self.death.value - self.dealt.value));
        
        GLfloat model_view[16];
        glGetFloatv(GL_MODELVIEW_MATRIX, model_view);
        
        GLfloat projection[16];
        glGetFloatv(GL_PROJECTION_MATRIX, projection);
        
        GLint viewport[4];
        glGetIntegerv(GL_VIEWPORT, viewport);
        
        Vector2D points[16];
        ProjectVectors(controlPointsFront, points, 16, model_view, projection, viewport);
        
        GLushort triangles[54];
        GenerateBezierMesh(triangles, 4, 4);
        
        CGPoint touchPoint = [touch locationInView:touch.view];
        
        Vector2D touchLocation = Vector2DMake(touchPoint.x, 480 - touchPoint.y);
        
        return TestTriangles(touchLocation, points, triangles, 18) ? self : object;
    }
    TRANSACTION_END
}

-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point
{
    GLfloat angle = self.cardGroup.renderer.camera.pitchAngle.value * self.cardGroup.renderer.camera.pitchFactor.value;
    
    if(angle > 60)
    {
        [self.cardGroup startDragForCard:self];
    }
}

-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    int target = 480 - ((pointTo.y) / 96.0);
    
    if(target < 0) { target = 0; }
    if(target > 4) { target = 4; }
    
    GLfloat delta = pointTo.y - pointFrom.y;
    
    [self.cardGroup dragCardToTarget:target withDelta:delta];
}

-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    GLfloat angle = self.cardGroup.renderer.camera.pitchAngle.value * self.cardGroup.renderer.camera.pitchFactor.value;
    
    [self.cardGroup stopDrag];

    GLfloat delta = absf(pointFrom.y, pointTo.y);
        
    if(delta < 20)
    {
        if(angle > 60)
        {
            [self.cardGroup.renderer.gameController cardFrontTouched:self.position];
        }
        else
        {            
            [self.cardGroup.renderer.gameController cardBackTouched:self.position];
        }
    }
}

@end

@implementation GLCard (Killable)

@dynamic isDead;
@dynamic isAlive;

-(BOOL)isAlive { return within(self.death.value, 0, 0.001) && self.death.hasEnded; }
-(BOOL)isDead  { return within(self.death.value, 1, 0.001) && self.death.hasEnded; }

-(void)killWithDisplayContainer:(DisplayContainer*)container key:(id)key andThen:(simpleBlock)work
{
    [self.death setValue:1 forTime:1 andThen:^{ [container pruneDeadForKey:key]; runLater(work); }];
    
    [container pruneLiveForKey:key]; 
}

@end