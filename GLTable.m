//
//  GLTable.m
//  Studly
//
//  Created by Joel Bernstein on 6/28/09.
//  Copyright 2009 Joel Bernstein. All rights reserved.
//

#import "Constants.h"
#import "Bezier.h"
#import "GLTexture.h"
#import "MC3DVector.h"
#import "AnimatedFloat.h"
#import "TextureController.h"
#import "GLRenderer.h"

#import "GLTable.h"

@implementation GLTable

@synthesize renderer   = _renderer;
@synthesize drawStatus = _drawStatus;


-(id)init
{
    self = [super init];
    
    if(self)
    {   
        [self generate];
        //self.shadingOpacity = [AnimatedVec3 vec3WithValue:0.0];
    }
    
    return self;
}

-(void)generate
{
//    vec3 frontCorners[4];
//    
//    frontCorners[ 0] = vec3Make(-5, 0, -5);
//    frontCorners[ 1] = vec3Make(-5, 0, 5);
//    frontCorners[ 2] = vec3Make( 5, 0, -5);
//    frontCorners[ 3] = vec3Make( 5, 0, 5);
//    
//    GenerateBezierControlPoints(frontControlPoints, frontCorners);

    
    frontControlPoints[ 0] = vec3Make(-20.0, 1.0, 3.25);
    frontControlPoints[ 1] = vec3Make( -6.7, 1.0, 3.25);
    frontControlPoints[ 2] = vec3Make(  6.7, 1.0, 3.25);
    frontControlPoints[ 3] = vec3Make( 20.0, 1.0, 3.25);
    
    frontControlPoints[ 4] = vec3Make(-20.0, 1.0, 4.25);
    frontControlPoints[ 5] = vec3Make( -6.7, 1.0, 4.25);
    frontControlPoints[ 6] = vec3Make(  6.7, 1.0, 4.25);
    frontControlPoints[ 7] = vec3Make( 20.0, 1.0, 4.25);
    
    frontControlPoints[ 8] = vec3Make(-20.0, 0.0, 4.25);
    frontControlPoints[ 9] = vec3Make( -6.7, 0.0, 4.25);
    frontControlPoints[10] = vec3Make(  6.7, 0.0, 4.25);
    frontControlPoints[11] = vec3Make( 20.0, 0.0, 4.25);
    
    frontControlPoints[12] = vec3Make(-20.0, 0.0, 3.25);
    frontControlPoints[13] = vec3Make( -6.7, 0.0, 3.25);
    frontControlPoints[14] = vec3Make(  6.7, 0.0, 3.25);
    frontControlPoints[15] = vec3Make( 20.0, 0.0, 3.25);
}

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    return object;
}

-(void)handleTouchDown:(UITouch*)touch Point:(CGPoint)point
{
    
}

-(void)handleTouchUp:(UITouch*)touch FromPoint:(CGPoint)pointFrom ToPoint:(CGPoint)pointTo
{
    
}

- (void)draw
{
    // TOP
    
    glDisableClientState(GL_NORMAL_ARRAY);
    
    glNormal3f(0.0, -1.0, 0.0);
    
    vec3 topVertexArray[] = 
    {
        vec3Make(-20.0, 0.0, -16.75),       
        vec3Make( 20.0, 0.0, -16.75),        
        vec3Make(-20.0, 0.0,   3.25),        
        vec3Make( 20.0, 0.0,   3.25),
    };
    
    GLushort topMeshArray[] =
    {
        0,1,2,
        2,1,3,
    };  
    
    vec2 topTextureArray0[] =
    {
        vec2Make(-1, -2 - self.renderer.currentOffset.value * 0.1),        
        vec2Make(-1,  2 - self.renderer.currentOffset.value * 0.1),        
        vec2Make( 1, -2 - self.renderer.currentOffset.value * 0.1),        
        vec2Make( 1,  2 - self.renderer.currentOffset.value * 0.1),
    };

    vec2 topTextureArray1[4];
    
    topTextureArray1[0] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(0, 0) : vec2Make(0.225, 0.289);      
    topTextureArray1[1] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(1, 0) : vec2Make(0.777, 0.289);        
    topTextureArray1[2] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(0, 1) : vec2Make(0.225, 1);        
    topTextureArray1[3] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(1, 1) : vec2Make(0.777, 1);
        
    GLfloat lightness = self.renderer.lightness.value;
    
    glColor4f(lightness, lightness, lightness, self.drawStatus == GLTableDrawStatusDiffuse ? 0.55 : 0.45);
    
    glVertexPointer  (3, GL_FLOAT, 0, topVertexArray);
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glClientActiveTexture(GL_TEXTURE0); 
    glActiveTexture(GL_TEXTURE0); 
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"table"]);
    glTexCoordPointer(2, GL_FLOAT, 0, topTextureArray0);      
    
    glClientActiveTexture(GL_TEXTURE1); 
    glActiveTexture(GL_TEXTURE1); 
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"lightmap"]);
    glTexCoordPointer(2, GL_FLOAT, 0, topTextureArray1);      
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, topMeshArray);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    glClientActiveTexture(GL_TEXTURE0); 
    glActiveTexture(GL_TEXTURE0); 
    
    glEnableClientState(GL_NORMAL_ARRAY);
    
    // FRONT
    
    vec3 frontVertexArray [12];
    vec3 frontNormalArray [12];
    vec2 frontTextureArray0[12];
    vec2 frontTextureArray1[12];
    
    GLushort meshArray[30];  
    
    int vertexWidth  = 6;
    int vertexHeight = 2;            
    
    GenerateBezierMesh(meshArray, vertexWidth, vertexHeight);
    
    GenerateBezierVertices(frontVertexArray,  vertexWidth, vertexHeight, frontControlPoints);
    GenerateBezierNormals (frontNormalArray,  vertexWidth, vertexHeight, frontControlPoints);
        
    GenerateBezierTextures(frontTextureArray0, vertexWidth, vertexHeight, vec2Make(-4.0, 1.0 / 5.0), vec2Make(-self.renderer.currentOffset.value * 0.1, 0));
        
    frontTextureArray1[ 0] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(1, 1) : vec2Make(0.777, 1);
    frontTextureArray1[ 1] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(1, 1) : vec2Make(0.777, 1);
    frontTextureArray1[ 2] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(1, 1) : vec2Make(0.777, 1);
    frontTextureArray1[ 3] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(1, 1) : vec2Make(0.777, 1);
    frontTextureArray1[ 4] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(1, 1) : vec2Make(0.777, 1);
    frontTextureArray1[ 5] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(1, 1) : vec2Make(0.777, 1);
    frontTextureArray1[ 6] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(0, 1) : vec2Make(0.225, 1);
    frontTextureArray1[ 7] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(0, 1) : vec2Make(0.225, 1);
    frontTextureArray1[ 8] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(0, 1) : vec2Make(0.225, 1);
    frontTextureArray1[ 9] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(0, 1) : vec2Make(0.225, 1);
    frontTextureArray1[10] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(0, 1) : vec2Make(0.225, 1);
    frontTextureArray1[11] = self.drawStatus == GLTableDrawStatusDiffuse ? vec2Make(0, 1) : vec2Make(0.225, 1);
    
    
    glVertexPointer  (3, GL_FLOAT, 0, frontVertexArray);
    glNormalPointer  (   GL_FLOAT, 0, frontNormalArray);
        
    
    
    glClientActiveTexture(GL_TEXTURE0); 
    glActiveTexture(GL_TEXTURE0); 
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"table"]);
    glTexCoordPointer(2, GL_FLOAT, 0, frontTextureArray0);      
    
    glClientActiveTexture(GL_TEXTURE1); 
    glActiveTexture(GL_TEXTURE1); 
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"lightmap"]);
    glTexCoordPointer(2, GL_FLOAT, 0, frontTextureArray1);      
    
    glDrawElements(GL_TRIANGLES, 30, GL_UNSIGNED_SHORT, meshArray);
    
    glClientActiveTexture(GL_TEXTURE1); 
    glActiveTexture(GL_TEXTURE1); 
    glBindTexture(GL_TEXTURE_2D, 0);
    glClientActiveTexture(GL_TEXTURE0); 
    glActiveTexture(GL_TEXTURE0); 
    
}

- (void)drawShading
{
//    if(self.shadingOpacity.value < 0.00001) { return; }
//    
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//    
//    glBindTexture(GL_TEXTURE_2D, 0);
//    
//    // TOP
//
//    glDisableClientState(GL_COLOR_ARRAY);
//    glDisableClientState(GL_NORMAL_ARRAY);
//    
//    glNormal3f(0.0, -1.0, 0.0);
//    
//    vec3 topVertexArray[] = 
//    {
//        vec3Make(-20.0, 0.0, -16.75),
//        vec3Make( 20.0, 0.0, -16.75),
//        vec3Make(-20.0, 0.0,   3.25),
//        vec3Make( 20.0, 0.0,   3.25),
//    };
//    
//    GLushort topMeshArray[] = { 0, 1, 2, 2, 1, 3 };  
//    
//    glColor4f(0,0,0, self.shadingOpacity.value);
//
//    glVertexPointer(3, GL_FLOAT, 0, topVertexArray);
//    
//    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, topMeshArray);
//    
//    // FRONT
//        
//    vec3 frontVertexArray [12];
//    vec3 frontNormalArray [12];
//    
//    GLushort meshArray[30];  
//    
//    int vertexWidth  = 6;
//    int vertexHeight = 2;            
//    
//    GenerateBezierMesh(meshArray, vertexWidth, vertexHeight);
//    
//    GenerateBezierVertices(frontVertexArray, vertexWidth, vertexHeight, frontControlPoints);
//    
//    glVertexPointer(3, GL_FLOAT, 0, frontVertexArray);
//    
//    glDrawElements(GL_TRIANGLES, 30, GL_UNSIGNED_SHORT, meshArray);
//    
//    glEnableClientState(GL_NORMAL_ARRAY);

}

@end