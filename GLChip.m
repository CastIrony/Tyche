#import "Geometry.h"
#import "MC3DVector.h"
#import "Bezier.h"
#import "GLTexture.h"
#import "GLPlayer.h"
#import "Projection.h"
#import "AnimatedFloat.h"
#import "AnimatedVec3.h"
#import "GLRenderer.h"
#import "TextureController.h"
#import "GLChipGroup.h"

#import "GLChip.h"

@implementation GLChip

@synthesize location         = _location;
@synthesize chipNumber       = _chipNumber;
@synthesize maxCount         = _maxCount;
@synthesize count            = _count;
@synthesize markerOpacity    = _markerOpacity;
@synthesize initialCount     = _initialCount;
@synthesize chipGroup        = _chipGroup;
@synthesize key              = _key;
@synthesize displayContainer = _displayContainer;

-(BOOL)isAlive { return YES; }
-(BOOL)isDead  { return NO; }

-(void)appearAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work { return; }
-(void)dieAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work { return; }

+(GLChip*)chip
{
    return [[[GLChip alloc] init] autorelease];
}

-(id)init
{
    self = [super init];
    
    if(self) 
    {        
        chipSize = vec2Make(131.0 / 1024.0, 131.0 / 1024.0);
        
        chipOffsets[0]   = vec2Make(  0.0 / 1024.0,   0.0 / 1024.0); // 1
        chipOffsets[1]   = vec2Make(131.0 / 1024.0,   0.0 / 1024.0); // 5
        chipOffsets[2]   = vec2Make(262.0 / 1024.0,   0.0 / 1024.0); // 10
        chipOffsets[3]   = vec2Make(393.0 / 1024.0,   0.0 / 1024.0); // 25
        chipOffsets[4]   = vec2Make(  0.0 / 1024.0, 131.0 / 1024.0); // 100
        chipOffsets[5]   = vec2Make(131.0 / 1024.0, 131.0 / 1024.0); // 500
        chipOffsets[6]   = vec2Make(262.0 / 1024.0, 131.0 / 1024.0); // 1000
        chipOffsets[7]   = vec2Make(393.0 / 1024.0, 131.0 / 1024.0); // 2500
        chipOffsets[8]   = vec2Make(  0.0 / 1024.0, 262.0 / 1024.0); // 10000
        
        markerOffsets[0] = vec2Make(  0.0 / 1024.0, 393.0 / 1024.0); // 1
        markerOffsets[1] = vec2Make(131.0 / 1024.0, 393.0 / 1024.0); // 5
        markerOffsets[2] = vec2Make(262.0 / 1024.0, 393.0 / 1024.0); // 10
        markerOffsets[3] = vec2Make(393.0 / 1024.0, 393.0 / 1024.0); // 25
        markerOffsets[4] = vec2Make(  0.0 / 1024.0, 524.0 / 1024.0); // 100
        markerOffsets[5] = vec2Make(131.0 / 1024.0, 524.0 / 1024.0); // 500
        markerOffsets[6] = vec2Make(262.0 / 1024.0, 524.0 / 1024.0); // 1000
        markerOffsets[7] = vec2Make(393.0 / 1024.0, 524.0 / 1024.0); // 2500
        markerOffsets[8] = vec2Make(  0.0 / 1024.0, 655.0 / 1024.0); // 10000
        
        shadingOffset    = vec2Make(524.0 / 1024.0,   0.0 / 1024.0); // Shading
        shadowOffset     = vec2Make(655.0 / 1024.0,   0.0 / 1024.0); // Shadow

        stackVectors = malloc( 8 * (100 + 1) * sizeof(vec3));
        stackTexture = malloc( 8 * (100 + 1) * sizeof(vec2));
        stackMesh    = malloc(12 * (100 + 1) * sizeof(GLushort));
        stackColors  = malloc( 8 * (100 + 1) * sizeof(color));
                
        shadowVectors = malloc( 8 * (100 + 1) * sizeof(vec3));
        shadowTexture = malloc( 8 * (100 + 1) * sizeof(vec2));
        shadowMesh    = malloc(12 * (100 + 1) * sizeof(GLushort));
        shadowColors  = malloc( 8 * (100 + 1) * sizeof(color));
        
        self.count = [AnimatedFloat floatWithValue:0];
    }
    
    return self;
}

-(void)dealloc
{
    free(stackVectors);
    free(stackTexture);
    free(stackMesh);   
    free(stackColors); 
    free(shadowVectors);
    free(shadowTexture);
    free(shadowMesh);   
    free(shadowColors);
}

-(void)drawSpot
{

}

-(void)generateMesh
{
    int stackCount = clipInt(self.count.value, 0, 100);

    GLfloat fade = self.count.value - stackCount;
    
    int seed = arc4random();
    
    srand48(self.chipNumber);
    
    vec3 rotateAxis = vec3Make(0, 1, 0);
    
    int offsetVector  = 0;
    int offsetTexture = 0;
    int offsetColors  = 0;
    int offsetMesh    = 0;
    int offsetSprite  = 0;
    
    GLfloat distance = sqrt(self.location.x * self.location.x + self.location.z * self.location.z);
    
    GLfloat lightness = clipFloat(1.0 - 0.03 * distance, 0.0, 1.0) * self.chipGroup.player.renderer.lightness.value;
        
    for(int chipCounter = 0; chipCounter <= stackCount; chipCounter++) 
    {
        GLfloat displacement = -0.15 * (chipCounter + 1);
        
        vec3 locationJitter = randomvec3(self.location.x, self.location.y + displacement, self.location.z, 0.1, 0.0, 0.1);
        
        GLfloat angleJitter = randomFloat(-30, 30);
        
        stackVectors[offsetVector++] = vec3Make(locationJitter.x - 1.0, locationJitter.y, locationJitter.z - 1.0);
        stackVectors[offsetVector++] = vec3Make(locationJitter.x + 1.0, locationJitter.y, locationJitter.z - 1.0);
        stackVectors[offsetVector++] = vec3Make(locationJitter.x - 1.0, locationJitter.y, locationJitter.z + 1.0);
        stackVectors[offsetVector++] = vec3Make(locationJitter.x + 1.0, locationJitter.y, locationJitter.z + 1.0);
        
        rotateVectors(stackVectors + offsetVector - 4, 4, angleJitter, locationJitter, rotateAxis);
        
        stackTexture[offsetTexture++] = vec2Make(1.0 * chipSize.x + chipOffsets[self.chipNumber].x, 0.0 * chipSize.y + chipOffsets[self.chipNumber].y);
        stackTexture[offsetTexture++] = vec2Make(0.0 * chipSize.x + chipOffsets[self.chipNumber].x, 0.0 * chipSize.y + chipOffsets[self.chipNumber].y);
        stackTexture[offsetTexture++] = vec2Make(1.0 * chipSize.x + chipOffsets[self.chipNumber].x, 1.0 * chipSize.y + chipOffsets[self.chipNumber].y);
        stackTexture[offsetTexture++] = vec2Make(0.0 * chipSize.x + chipOffsets[self.chipNumber].x, 1.0 * chipSize.y + chipOffsets[self.chipNumber].y);
        
        stackColors[offsetColors++] = colorMake(lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, self.chipGroup.opacity);
        stackColors[offsetColors++] = colorMake(lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, self.chipGroup.opacity);
        stackColors[offsetColors++] = colorMake(lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, self.chipGroup.opacity);
        stackColors[offsetColors++] = colorMake(lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, self.chipGroup.opacity);
        
        stackMesh[offsetMesh++] = offsetSprite * 4 + 0;
        stackMesh[offsetMesh++] = offsetSprite * 4 + 1;
        stackMesh[offsetMesh++] = offsetSprite * 4 + 2;
        stackMesh[offsetMesh++] = offsetSprite * 4 + 2;
        stackMesh[offsetMesh++] = offsetSprite * 4 + 1;
        stackMesh[offsetMesh++] = offsetSprite * 4 + 3;
        
        offsetSprite++;
        
        if(chipCounter >= stackCount - 2)
        {
            stackVectors[offsetVector++] = vec3Make(locationJitter.x - 1.0, locationJitter.y, locationJitter.z - 1.0);
            stackVectors[offsetVector++] = vec3Make(locationJitter.x + 1.0, locationJitter.y, locationJitter.z - 1.0);
            stackVectors[offsetVector++] = vec3Make(locationJitter.x - 1.0, locationJitter.y, locationJitter.z + 1.0);
            stackVectors[offsetVector++] = vec3Make(locationJitter.x + 1.0, locationJitter.y, locationJitter.z + 1.0);
            
            stackTexture[offsetTexture++] = vec2Make(1.0 * chipSize.x + shadingOffset.x, 0.0 * chipSize.y + shadingOffset.y);
            stackTexture[offsetTexture++] = vec2Make(0.0 * chipSize.x + shadingOffset.x, 0.0 * chipSize.y + shadingOffset.y);
            stackTexture[offsetTexture++] = vec2Make(1.0 * chipSize.x + shadingOffset.x, 1.0 * chipSize.y + shadingOffset.y);
            stackTexture[offsetTexture++] = vec2Make(0.0 * chipSize.x + shadingOffset.x, 1.0 * chipSize.y + shadingOffset.y);
            
            stackColors[offsetColors++] = colorMake(self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness);
            stackColors[offsetColors++] = colorMake(self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness);
            stackColors[offsetColors++] = colorMake(self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness);
            stackColors[offsetColors++] = colorMake(self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness);
                        
            stackMesh[offsetMesh++] = offsetSprite * 4 + 0;
            stackMesh[offsetMesh++] = offsetSprite * 4 + 1;
            stackMesh[offsetMesh++] = offsetSprite * 4 + 2;
            stackMesh[offsetMesh++] = offsetSprite * 4 + 2;
            stackMesh[offsetMesh++] = offsetSprite * 4 + 1;
            stackMesh[offsetMesh++] = offsetSprite * 4 + 3;
            
            offsetSprite++;
        }
    }
    
    stackVectors[offsetVector - 8].z -= 3 * (1 - fade);
    stackVectors[offsetVector - 7].z -= 3 * (1 - fade);
    stackVectors[offsetVector - 6].z -= 3 * (1 - fade);
    stackVectors[offsetVector - 5].z -= 3 * (1 - fade);
    stackVectors[offsetVector - 4].z -= 3 * (1 - fade);
    stackVectors[offsetVector - 3].z -= 3 * (1 - fade);
    stackVectors[offsetVector - 2].z -= 3 * (1 - fade);
    stackVectors[offsetVector - 1].z -= 3 * (1 - fade);
        
    stackColors[offsetColors - 8] = colorMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity,             fade * self.chipGroup.opacity);
    stackColors[offsetColors - 7] = colorMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity,             fade * self.chipGroup.opacity);
    stackColors[offsetColors - 6] = colorMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity,             fade * self.chipGroup.opacity);
    stackColors[offsetColors - 5] = colorMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity,             fade * self.chipGroup.opacity);
    stackColors[offsetColors - 4] = colorMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity);
    stackColors[offsetColors - 3] = colorMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity);
    stackColors[offsetColors - 2] = colorMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity);
    stackColors[offsetColors - 1] = colorMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity);
    
    _meshSize = offsetMesh;

    srand48(seed);
}

-(void)draw
{
    if(self.chipGroup.opacity < 0.0001) { return; }
    
    [self generateMesh];

    glDisableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"chips"]);
    
    glNormal3f(0.0, -1.0, 0.0);

    glTexCoordPointer(2, GL_FLOAT, 0, stackTexture);            
    glColorPointer   (4, GL_FLOAT, 0, stackColors);                                    
    glVertexPointer  (3, GL_FLOAT, 0, stackVectors);
    
    glDrawElements(GL_TRIANGLES, _meshSize, GL_UNSIGNED_SHORT, stackMesh);    
        
    glEnableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
}

-(void)drawMarker
{    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"chips"]);
    
    vec3 vertexArray[] = 
    {
        vec3Make(-1,  0.0, -1),        
        vec3Make( 1,  0.0, -1),        
        vec3Make(-1,  0.0,  1),        
        vec3Make( 1,  0.0,  1),
    };
        
    vec2 textureArrayShadow[] = 
    {
        vec2Make(1.0 * chipSize.x + markerOffsets[self.chipNumber].x, 0.0 * chipSize.y + markerOffsets[self.chipNumber].y),
        vec2Make(0.0 * chipSize.x + markerOffsets[self.chipNumber].x, 0.0 * chipSize.y + markerOffsets[self.chipNumber].y),
        vec2Make(1.0 * chipSize.x + markerOffsets[self.chipNumber].x, 1.0 * chipSize.y + markerOffsets[self.chipNumber].y),
        vec2Make(0.0 * chipSize.x + markerOffsets[self.chipNumber].x, 1.0 * chipSize.y + markerOffsets[self.chipNumber].y),
    };
    
    GLushort meshArray[6];
    
    GenerateBezierMesh(meshArray, 2, 2);
    
    glNormal3f(0.0, -1.0, 0.0);
    
    glDisableClientState(GL_NORMAL_ARRAY);
    
    glVertexPointer(3, GL_FLOAT, 0, vertexArray);
    glTexCoordPointer(2, GL_FLOAT, 0, textureArrayShadow);            

    glColor4f(self.markerOpacity, self.markerOpacity, self.markerOpacity, self.markerOpacity);

    TRANSACTION_BEGIN
    {
        glTranslatef(self.location.x, self.location.y, self.location.z);
        
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, meshArray);    
    }
    TRANSACTION_END
    
    glEnableClientState(GL_NORMAL_ARRAY);
}

-(void)drawShadow
{
    float countValue = self.count.value;
    
    int stackCount = countValue;
    
    if(stackCount < 0) { return; }
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"chips"]);
    
    glColor4f(1,1,1,1);
    
    vec3 vertexArray[4];
    
    vec2 textureArrayShadow[] = 
    {
        vec2Make(1.0 * chipSize.x + shadowOffset.x, 0.0 * chipSize.y + shadowOffset.y),
        vec2Make(0.0 * chipSize.x + shadowOffset.x, 0.0 * chipSize.y + shadowOffset.y),
        vec2Make(1.0 * chipSize.x + shadowOffset.x, 1.0 * chipSize.y + shadowOffset.y),
        vec2Make(0.0 * chipSize.x + shadowOffset.x, 1.0 * chipSize.y + shadowOffset.y),
    };
    
    GLushort meshArray[6];
    
    GenerateBezierMesh(meshArray, 2, 2);
    
    glNormal3f(0.0, -1.0, 0.0);
    
    glDisableClientState(GL_NORMAL_ARRAY);
    
    glTexCoordPointer(2, GL_FLOAT, 0, textureArrayShadow);            
    
    vec3 light = vec3Make(-self.chipGroup.player.renderer.currentOffset.value, -7.5, 0);
    
    for(int i = 0; i < stackCount; i += 5)
    {        
        GLfloat displacement = -0.15 * (i + 1);
        
        vertexArray[0] = vec3ProjectShadow(light, vec3Make(self.location.x - 1.2, self.location.y + displacement, self.location.z - 1.2));        
        vertexArray[1] = vec3ProjectShadow(light, vec3Make(self.location.x + 1.2, self.location.y + displacement, self.location.z - 1.2));        
        vertexArray[2] = vec3ProjectShadow(light, vec3Make(self.location.x - 1.2, self.location.y + displacement, self.location.z + 1.2));        
        vertexArray[3] = vec3ProjectShadow(light, vec3Make(self.location.x + 1.2, self.location.y + displacement, self.location.z + 1.2));
        
        glVertexPointer(3, GL_FLOAT, 0, vertexArray);

        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, meshArray);    
    }

    GLfloat opacity = clipFloat(countValue, 0, 1);
    
    GLfloat displacement = -0.15 * (countValue + 1);
    
    vertexArray[0] = vec3ProjectShadow(light, vec3Make(self.location.x - 1.2, self.location.y + displacement, self.location.z - 1.2));        
    vertexArray[1] = vec3ProjectShadow(light, vec3Make(self.location.x + 1.2, self.location.y + displacement, self.location.z - 1.2));        
    vertexArray[2] = vec3ProjectShadow(light, vec3Make(self.location.x - 1.2, self.location.y + displacement, self.location.z + 1.2));        
    vertexArray[3] = vec3ProjectShadow(light, vec3Make(self.location.x + 1.2, self.location.y + displacement, self.location.z + 1.2));

    glColor4f(opacity, opacity, opacity, opacity);
    
    glVertexPointer(3, GL_FLOAT, 0, vertexArray);
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, meshArray);   
    
    glEnableClientState(GL_NORMAL_ARRAY);
}

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    if(self.chipGroup.frozen) { return object; }

    GLfloat model_view[16];

    TRANSACTION_BEGIN
    {    
        glTranslatef(self.location.x, self.location.y + -0.1 * (self.count.value + 1), self.location.z);
        
        glScalef(1.25, 1.25, 1.25);   
        
        glGetFloatv(GL_MODELVIEW_MATRIX, model_view);
    }
    TRANSACTION_END
    
    GLfloat projection[16];
    glGetFloatv(GL_PROJECTION_MATRIX, projection);
    
    GLint viewport[4];
    glGetIntegerv(GL_VIEWPORT, viewport);
	
    vec3 vertexArrayPattern[] = 
    {
        vec3Make( 1.0,  0.0, -1.0),        
        vec3Make(-1.0,  0.0, -1.0),        
        vec3Make( 1.0,  0.0,  1.0),        
        vec3Make(-1.0,  0.0,  1.0),
    };
    
    vec2 points[16];
    ProjectVectors(vertexArrayPattern, points, 4, model_view, projection, viewport);
    
    GLushort triangles[6];
    GenerateBezierMesh(triangles, 2, 2);
    
    CGPoint touchPoint = [touch locationInView:touch.view];
    
    vec2 touchLocation = vec2Make(touchPoint.x, UIScreen.mainScreen.bounds.size.height - touchPoint.y);
    
    return TestTriangles(touchLocation, points, triangles, 2) ? self : object;
}

-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point
{    
    self.initialCount = self.count.value;
}

-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    float newCount = self.initialCount - clipFloat(pointTo.x - pointFrom.x, -100, 100) / 100;
    
    [self.count setValue:fmin(newCount, self.maxCount) forTime:0.05];
}

-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    GLfloat deltaX = pointTo.x - pointFrom.x;
    
    [self.count setValue:(int)(self.count.value + 0.5) forTime:0.5];

    
    if(deltaX > 0) 
    { 
        if(self.chipNumber == 0) { [self.chipGroup.player.renderer.gameController chipSwipedUpWithKey:@"1"]; }
        if(self.chipNumber == 1) { [self.chipGroup.player.renderer.gameController chipSwipedUpWithKey:@"5"]; }
        if(self.chipNumber == 2) { [self.chipGroup.player.renderer.gameController chipSwipedUpWithKey:@"10"]; }
        if(self.chipNumber == 3) { [self.chipGroup.player.renderer.gameController chipSwipedUpWithKey:@"50"]; }
        if(self.chipNumber == 4) { [self.chipGroup.player.renderer.gameController chipSwipedUpWithKey:@"100"]; }
        if(self.chipNumber == 5) { [self.chipGroup.player.renderer.gameController chipSwipedUpWithKey:@"500"]; }
        if(self.chipNumber == 6) { [self.chipGroup.player.renderer.gameController chipSwipedUpWithKey:@"1000"]; }
        if(self.chipNumber == 7) { [self.chipGroup.player.renderer.gameController chipSwipedUpWithKey:@"5000"]; }
        if(self.chipNumber == 8) { [self.chipGroup.player.renderer.gameController chipSwipedUpWithKey:@"10000"]; }
    }
    else if(deltaX <= 0) 
    { 
        if(self.chipNumber == 0) { [self.chipGroup.player.renderer.gameController chipSwipedDownWithKey:@"1"]; }
        if(self.chipNumber == 1) { [self.chipGroup.player.renderer.gameController chipSwipedDownWithKey:@"5"]; }
        if(self.chipNumber == 2) { [self.chipGroup.player.renderer.gameController chipSwipedDownWithKey:@"10"]; }
        if(self.chipNumber == 3) { [self.chipGroup.player.renderer.gameController chipSwipedDownWithKey:@"50"]; }
        if(self.chipNumber == 4) { [self.chipGroup.player.renderer.gameController chipSwipedDownWithKey:@"100"]; }
        if(self.chipNumber == 5) { [self.chipGroup.player.renderer.gameController chipSwipedDownWithKey:@"500"]; }
        if(self.chipNumber == 6) { [self.chipGroup.player.renderer.gameController chipSwipedDownWithKey:@"1000"]; }
        if(self.chipNumber == 7) { [self.chipGroup.player.renderer.gameController chipSwipedDownWithKey:@"5000"]; }
        if(self.chipNumber == 8) { [self.chipGroup.player.renderer.gameController chipSwipedDownWithKey:@"10000"]; }
    }
}

@end