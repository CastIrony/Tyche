#import "Constants.h"
#import "Geometry.h"
#import "Bezier.h"
#import "GLTexture.h"
#import "Projection.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "GameRenderer.h"
#import "TextureController.h"
#import "GLChipGroup.h"

#import "GLChip.h"

@implementation GLChip

@synthesize location      = _location;
@synthesize chipNumber    = _chipNumber;
@synthesize maxCount      = _maxCount;
@synthesize count         = _count;
@synthesize initialCount  = _initialCount;
@synthesize chipGroup     = _chipGroup;

#pragma mark -
#pragma mark INIT

+(GLChip*)chip
{
    return [[[GLChip alloc] init] autorelease];
}

-(id)init
{
    self = [super init];
    
    if(self) 
    {        
        chipSize = Vector2DMake(131.0 / 1024.0, 131.0 / 1024.0);
        
        chipOffsets[0]   = Vector2DMake(  0.0 / 1024.0,   0.0 / 1024.0); // 1
        chipOffsets[1]   = Vector2DMake(131.0 / 1024.0,   0.0 / 1024.0); // 5
        chipOffsets[2]   = Vector2DMake(262.0 / 1024.0,   0.0 / 1024.0); // 10
        chipOffsets[3]   = Vector2DMake(393.0 / 1024.0,   0.0 / 1024.0); // 25
        chipOffsets[4]   = Vector2DMake(  0.0 / 1024.0, 131.0 / 1024.0); // 100
        chipOffsets[5]   = Vector2DMake(131.0 / 1024.0, 131.0 / 1024.0); // 500
        chipOffsets[6]   = Vector2DMake(262.0 / 1024.0, 131.0 / 1024.0); // 1000
        chipOffsets[7]   = Vector2DMake(393.0 / 1024.0, 131.0 / 1024.0); // 2500
        chipOffsets[8]   = Vector2DMake(  0.0 / 1024.0, 262.0 / 1024.0); // 10000
        
        markerOffsets[0] = Vector2DMake(  0.0 / 1024.0, 393.0 / 1024.0); // 1
        markerOffsets[1] = Vector2DMake(131.0 / 1024.0, 393.0 / 1024.0); // 5
        markerOffsets[2] = Vector2DMake(262.0 / 1024.0, 393.0 / 1024.0); // 10
        markerOffsets[3] = Vector2DMake(393.0 / 1024.0, 393.0 / 1024.0); // 25
        markerOffsets[4] = Vector2DMake(  0.0 / 1024.0, 524.0 / 1024.0); // 100
        markerOffsets[5] = Vector2DMake(131.0 / 1024.0, 524.0 / 1024.0); // 500
        markerOffsets[6] = Vector2DMake(262.0 / 1024.0, 524.0 / 1024.0); // 1000
        markerOffsets[7] = Vector2DMake(393.0 / 1024.0, 524.0 / 1024.0); // 2500
        markerOffsets[8] = Vector2DMake(  0.0 / 1024.0, 655.0 / 1024.0); // 10000
        
        shadingOffset    = Vector2DMake(524.0 / 1024.0,   0.0 / 1024.0); // Shading
        shadowOffset     = Vector2DMake(655.0 / 1024.0,   0.0 / 1024.0); // Shadow

        stackVectors = malloc( 8 * (100 + 1) * sizeof(Vector3D));
        stackTexture = malloc( 8 * (100 + 1) * sizeof(Vector2D));
        stackMesh    = malloc(12 * (100 + 1) * sizeof(GLushort));
        stackColors  = malloc( 8 * (100 + 1) * sizeof(Color3D));
        
        // TODO: Make these numbers more reasonable:
        
        shadowVectors = malloc( 8 * (100 + 1) * sizeof(Vector3D));
        shadowTexture = malloc( 8 * (100 + 1) * sizeof(Vector2D));
        shadowMesh    = malloc(12 * (100 + 1) * sizeof(GLushort));
        shadowColors  = malloc( 8 * (100 + 1) * sizeof(Color3D));
        
        self.count = [AnimatedFloat withValue:0];
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
    
    Vector3D rotateAxis = Vector3DMake(0, 1, 0);
    
    int offsetVector  = 0;
    int offsetTexture = 0;
    int offsetColors  = 0;
    int offsetMesh    = 0;
    int offsetSprite  = 0;
    
    GLfloat distance = sqrt(self.location.x * self.location.x + self.location.z * self.location.z);
    
    GLfloat lightness = clipFloat(1.0 - 0.06 * distance, 0.3, 1.0) * self.chipGroup.renderer.lightness.value;
        
    for(int chipCounter = 0; chipCounter <= stackCount; chipCounter++) 
    {
        GLfloat displacement = -0.15 * (chipCounter + 1);
        
        Vector3D locationJitter = randomVector3D(self.location.x, self.location.y + displacement, self.location.z, 0.1, 0.0, 0.1);
        
        GLfloat angleJitter = randomFloat(-30, 30);
        
        stackVectors[offsetVector++] = Vector3DMake(locationJitter.x - 1.0, locationJitter.y, locationJitter.z - 1.0);
        stackVectors[offsetVector++] = Vector3DMake(locationJitter.x + 1.0, locationJitter.y, locationJitter.z - 1.0);
        stackVectors[offsetVector++] = Vector3DMake(locationJitter.x - 1.0, locationJitter.y, locationJitter.z + 1.0);
        stackVectors[offsetVector++] = Vector3DMake(locationJitter.x + 1.0, locationJitter.y, locationJitter.z + 1.0);
        
        rotateVectors(stackVectors + offsetVector - 4, 4, angleJitter, locationJitter, rotateAxis);
        
        stackTexture[offsetTexture++] = Vector2DMake(1.0 * chipSize.u + chipOffsets[self.chipNumber].u, 0.0 * chipSize.v + chipOffsets[self.chipNumber].v);
        stackTexture[offsetTexture++] = Vector2DMake(0.0 * chipSize.u + chipOffsets[self.chipNumber].u, 0.0 * chipSize.v + chipOffsets[self.chipNumber].v);
        stackTexture[offsetTexture++] = Vector2DMake(1.0 * chipSize.u + chipOffsets[self.chipNumber].u, 1.0 * chipSize.v + chipOffsets[self.chipNumber].v);
        stackTexture[offsetTexture++] = Vector2DMake(0.0 * chipSize.u + chipOffsets[self.chipNumber].u, 1.0 * chipSize.v + chipOffsets[self.chipNumber].v);
        
        stackColors[offsetColors++] = Color3DMake(lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, self.chipGroup.opacity);
        stackColors[offsetColors++] = Color3DMake(lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, self.chipGroup.opacity);
        stackColors[offsetColors++] = Color3DMake(lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, self.chipGroup.opacity);
        stackColors[offsetColors++] = Color3DMake(lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, lightness * self.chipGroup.opacity, self.chipGroup.opacity);
        
        stackMesh[offsetMesh++] = offsetSprite * 4 + 0;
        stackMesh[offsetMesh++] = offsetSprite * 4 + 1;
        stackMesh[offsetMesh++] = offsetSprite * 4 + 2;
        stackMesh[offsetMesh++] = offsetSprite * 4 + 2;
        stackMesh[offsetMesh++] = offsetSprite * 4 + 1;
        stackMesh[offsetMesh++] = offsetSprite * 4 + 3;
        
        offsetSprite++;
        
        if(chipCounter >= stackCount - 2)
        {
            stackVectors[offsetVector++] = Vector3DMake(locationJitter.x - 1.0, locationJitter.y, locationJitter.z - 1.0);
            stackVectors[offsetVector++] = Vector3DMake(locationJitter.x + 1.0, locationJitter.y, locationJitter.z - 1.0);
            stackVectors[offsetVector++] = Vector3DMake(locationJitter.x - 1.0, locationJitter.y, locationJitter.z + 1.0);
            stackVectors[offsetVector++] = Vector3DMake(locationJitter.x + 1.0, locationJitter.y, locationJitter.z + 1.0);
            
            stackTexture[offsetTexture++] = Vector2DMake(1.0 * chipSize.u + shadingOffset.u, 0.0 * chipSize.v + shadingOffset.v);
            stackTexture[offsetTexture++] = Vector2DMake(0.0 * chipSize.u + shadingOffset.u, 0.0 * chipSize.v + shadingOffset.v);
            stackTexture[offsetTexture++] = Vector2DMake(1.0 * chipSize.u + shadingOffset.u, 1.0 * chipSize.v + shadingOffset.v);
            stackTexture[offsetTexture++] = Vector2DMake(0.0 * chipSize.u + shadingOffset.u, 1.0 * chipSize.v + shadingOffset.v);
            
            stackColors[offsetColors++] = Color3DMake(self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness);
            stackColors[offsetColors++] = Color3DMake(self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness);
            stackColors[offsetColors++] = Color3DMake(self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness);
            stackColors[offsetColors++] = Color3DMake(self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness, self.chipGroup.opacity * lightness);
                        
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
        
    stackColors[offsetColors - 8] = Color3DMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity,             fade * self.chipGroup.opacity);
    stackColors[offsetColors - 7] = Color3DMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity,             fade * self.chipGroup.opacity);
    stackColors[offsetColors - 6] = Color3DMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity,             fade * self.chipGroup.opacity);
    stackColors[offsetColors - 5] = Color3DMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity,             fade * self.chipGroup.opacity);
    stackColors[offsetColors - 4] = Color3DMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity);
    stackColors[offsetColors - 3] = Color3DMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity);
    stackColors[offsetColors - 2] = Color3DMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity);
    stackColors[offsetColors - 1] = Color3DMake(lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity, lightness * fade * self.chipGroup.opacity);
    
    _meshSize = offsetMesh;

    srand48(seed);
}

-(void)draw
{
    if(self.chipGroup.opacity < 0.0001) { return; }
        
    glDisableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"chips"]);
    
    glNormal3f(0.0, -1.0, 0.0);

    if(!self.count.hasEnded)
    {
        [self generateMesh];
    }
    
    glTexCoordPointer(2, GL_FLOAT, 0, stackTexture);            
    glColorPointer   (4, GL_FLOAT, 0, stackColors);                                    
    glVertexPointer  (3, GL_FLOAT, 0, stackVectors);
    
    glDrawElements(GL_TRIANGLES, _meshSize, GL_UNSIGNED_SHORT, stackMesh);    
        
    glEnableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
}

-(void)drawMarker
{
//    int stackCount = self.count.value;
//    
//    if(stackCount < 0) { return; }
//    
//    return;
//    
//    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
//    
//    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"chip"]);
//    
//    Vector3D vertexArray[] = 
//    {
//        Vector3DMake(-1,  0.0, -1),        
//        Vector3DMake( 1,  0.0, -1),        
//        Vector3DMake(-1,  0.0,  1),        
//        Vector3DMake( 1,  0.0,  1),
//    };
//        
//    Vector2D textureArrayShadow[] = 
//    {
//        Vector2DMake(1.0 * chipSize.u + markerOffsets[self.chipNumber].u, 0.0 * chipSize.v + markerOffsets[self.chipNumber].v),
//        Vector2DMake(0.0 * chipSize.u + markerOffsets[self.chipNumber].u, 0.0 * chipSize.v + markerOffsets[self.chipNumber].v),
//        Vector2DMake(1.0 * chipSize.u + markerOffsets[self.chipNumber].u, 1.0 * chipSize.v + markerOffsets[self.chipNumber].v),
//        Vector2DMake(0.0 * chipSize.u + markerOffsets[self.chipNumber].u, 1.0 * chipSize.v + markerOffsets[self.chipNumber].v),
//    };
//    
//    GLushort meshArray[6];
//    
//    GenerateBezierMesh(meshArray, 2, 2);
//    
//    glNormal3f(0.0, -1.0, 0.0);
//    
//    glDisableClientState(GL_NORMAL_ARRAY);
//    
//    glVertexPointer(3, GL_FLOAT, 0, vertexArray);
//        
//    GLfloat fade = self.count.value - stackCount;
//    
//    glTexCoordPointer(2, GL_FLOAT, 0, textureArrayShadow);            
//
//    glColor4f(self.markerOpacity, self.markerOpacity, self.markerOpacity, self.markerOpacity);
//
//    if(stackCount == 0)
//    {
//        TRANSACTION_BEGIN
//        {
//            glTranslatef(self.location.x, self.location.y, self.location.z);
//            
//            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, meshArray);    
//        }
//        TRANSACTION_END
//    }
//    
//    glEnableClientState(GL_NORMAL_ARRAY);
}

-(void)drawShadow
{
    float countValue = self.count.value;
    
    int stackCount = countValue;
    
    if(stackCount < 0) { return; }
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"chips"]);
    
    glColor4f(1,1,1,1);
    
    Vector3D vertexArray[4];
    
    Vector2D textureArrayShadow[] = 
    {
        Vector2DMake(1.0 * chipSize.u + shadowOffset.u, 0.0 * chipSize.v + shadowOffset.v),
        Vector2DMake(0.0 * chipSize.u + shadowOffset.u, 0.0 * chipSize.v + shadowOffset.v),
        Vector2DMake(1.0 * chipSize.u + shadowOffset.u, 1.0 * chipSize.v + shadowOffset.v),
        Vector2DMake(0.0 * chipSize.u + shadowOffset.u, 1.0 * chipSize.v + shadowOffset.v),
    };
    
    GLushort meshArray[6];
    
    GenerateBezierMesh(meshArray, 2, 2);
    
    glNormal3f(0.0, -1.0, 0.0);
    
    glDisableClientState(GL_NORMAL_ARRAY);
    
    glTexCoordPointer(2, GL_FLOAT, 0, textureArrayShadow);            
    
    Vector3D light = Vector3DMake(0, -10, 0);
    
    for(int i = 0; i < stackCount; i += 10)
    {        
        GLfloat displacement = -0.15 * (i + 1);
        
        vertexArray[0] = Vector3DProjectShadow(light, Vector3DMake(self.location.x - 1.2, self.location.y + displacement, self.location.z - 1.2));        
        vertexArray[1] = Vector3DProjectShadow(light, Vector3DMake(self.location.x + 1.2, self.location.y + displacement, self.location.z - 1.2));        
        vertexArray[2] = Vector3DProjectShadow(light, Vector3DMake(self.location.x - 1.2, self.location.y + displacement, self.location.z + 1.2));        
        vertexArray[3] = Vector3DProjectShadow(light, Vector3DMake(self.location.x + 1.2, self.location.y + displacement, self.location.z + 1.2));
        
        glVertexPointer(3, GL_FLOAT, 0, vertexArray);

        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, meshArray);    
    }

    GLfloat opacity = clipFloat(countValue, 0, 1);
    
    GLfloat displacement = -0.15 * (countValue + 1);
    
    vertexArray[0] = Vector3DProjectShadow(light, Vector3DMake(self.location.x - 1.2, self.location.y + displacement, self.location.z - 1.2));        
    vertexArray[1] = Vector3DProjectShadow(light, Vector3DMake(self.location.x + 1.2, self.location.y + displacement, self.location.z - 1.2));        
    vertexArray[2] = Vector3DProjectShadow(light, Vector3DMake(self.location.x - 1.2, self.location.y + displacement, self.location.z + 1.2));        
    vertexArray[3] = Vector3DProjectShadow(light, Vector3DMake(self.location.x + 1.2, self.location.y + displacement, self.location.z + 1.2));

    glColor4f(opacity, opacity, opacity, opacity);
    
    glVertexPointer(3, GL_FLOAT, 0, vertexArray);
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, meshArray);   
    
    glEnableClientState(GL_NORMAL_ARRAY);
}

@end

@implementation GLChip (Touchable)

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
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
	
    Vector3D vertexArrayPattern[] = 
    {
        Vector3DMake( 1.0,  0.0, -1.0),        
        Vector3DMake(-1.0,  0.0, -1.0),        
        Vector3DMake( 1.0,  0.0,  1.0),        
        Vector3DMake(-1.0,  0.0,  1.0),
    };
    
    Vector2D points[16];
    ProjectVectors(vertexArrayPattern, points, 4, model_view, projection, viewport);
    
    GLushort triangles[6];
    GenerateBezierMesh(triangles, 2, 2);
    
    CGPoint touchPoint = [touch locationInView:touch.view];
    
    Vector2D touchLocation = Vector2DMake(touchPoint.x, 480 - touchPoint.y);
    
    return TestTriangles(touchLocation, points, triangles, 2) ? self : object;
}

-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point
{    
    self.initialCount = self.count.value;
}

-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    LOG_NS("foo");

    float newCount = self.initialCount - clipFloat(pointTo.x - pointFrom.x, -100, 100) / 100;
    
    /*if(newCount <= self.maxCount)*/ { [self.count setValue:newCount forTime:0.1 andThen:nil]; }
}

-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    GLfloat deltaX = pointTo.x - pointFrom.x;
    
    if(deltaX > 0) 
    { 
        if(self.chipNumber == 0) { [self.chipGroup.renderer.gameController chipTouchedUpWithKey:@"1"]; }
        if(self.chipNumber == 1) { [self.chipGroup.renderer.gameController chipTouchedUpWithKey:@"5"]; }
        if(self.chipNumber == 2) { [self.chipGroup.renderer.gameController chipTouchedUpWithKey:@"10"]; }
        if(self.chipNumber == 3) { [self.chipGroup.renderer.gameController chipTouchedUpWithKey:@"25"]; }
        if(self.chipNumber == 4) { [self.chipGroup.renderer.gameController chipTouchedUpWithKey:@"100"]; }
        if(self.chipNumber == 5) { [self.chipGroup.renderer.gameController chipTouchedUpWithKey:@"500"]; }
        if(self.chipNumber == 6) { [self.chipGroup.renderer.gameController chipTouchedUpWithKey:@"1000"]; }
        if(self.chipNumber == 7) { [self.chipGroup.renderer.gameController chipTouchedUpWithKey:@"2500"]; }
        if(self.chipNumber == 8) { [self.chipGroup.renderer.gameController chipTouchedUpWithKey:@"10000"]; }
    }
    else if(deltaX <= 0) 
    { 
        if(self.chipNumber == 0) { [self.chipGroup.renderer.gameController chipTouchedDownWithKey:@"1"]; }
        if(self.chipNumber == 1) { [self.chipGroup.renderer.gameController chipTouchedDownWithKey:@"5"]; }
        if(self.chipNumber == 2) { [self.chipGroup.renderer.gameController chipTouchedDownWithKey:@"10"]; }
        if(self.chipNumber == 3) { [self.chipGroup.renderer.gameController chipTouchedDownWithKey:@"25"]; }
        if(self.chipNumber == 4) { [self.chipGroup.renderer.gameController chipTouchedDownWithKey:@"100"]; }
        if(self.chipNumber == 5) { [self.chipGroup.renderer.gameController chipTouchedDownWithKey:@"500"]; }
        if(self.chipNumber == 6) { [self.chipGroup.renderer.gameController chipTouchedDownWithKey:@"1000"]; }
        if(self.chipNumber == 7) { [self.chipGroup.renderer.gameController chipTouchedDownWithKey:@"2500"]; }
        if(self.chipNumber == 8) { [self.chipGroup.renderer.gameController chipTouchedDownWithKey:@"10000"]; }
    }
}

@end

@implementation GLChip (Killable)

@dynamic isDead;
@dynamic isAlive;

-(BOOL)isAlive { return YES; }
-(BOOL)isDead  { return NO; }

-(void)killWithDisplayContainer:(DisplayContainer*)container key:(id)key andThen:(simpleBlock)work
{
    return;
}

@end