//
//  GLTable.m
//  Tyche
//
//  Created by Joel Bernstein on 6/28/09.
//  Copyright 2009 Joel Bernstein. All rights reserved.
//

#import "Constants.h"
#import "Bezier.h"
#import "GLTexture.h"
#import "Geometry.h"
#import "AnimatedFloat.h"
#import "TextureController.h"
#import "GameRenderer.h"

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
        //self.shadingOpacity = [AnimatedFloat withValue:0.0];
    }
    
    return self;
}

-(void)generate
{
//    Vector3D frontCorners[4];
//    
//    frontCorners[ 0] = Vector3DMake(-5, 0, -5);
//    frontCorners[ 1] = Vector3DMake(-5, 0, 5);
//    frontCorners[ 2] = Vector3DMake( 5, 0, -5);
//    frontCorners[ 3] = Vector3DMake( 5, 0, 5);
//    
//    GenerateBezierControlPoints(frontControlPoints, frontCorners);

    
    frontControlPoints[ 0] = Vector3DMake(-20.0, 1.0, 3.25);
    frontControlPoints[ 1] = Vector3DMake(-10.0, 1.0, 3.25);
    frontControlPoints[ 2] = Vector3DMake( 10.0, 1.0, 3.25);
    frontControlPoints[ 3] = Vector3DMake( 20.0, 1.0, 3.25);
    
    frontControlPoints[ 4] = Vector3DMake(-20.0, 1.0, 4.25);
    frontControlPoints[ 5] = Vector3DMake(-10.0, 1.0, 4.25);
    frontControlPoints[ 6] = Vector3DMake( 10.0, 1.0, 4.25);
    frontControlPoints[ 7] = Vector3DMake( 20.0, 1.0, 4.25);
    
    frontControlPoints[ 8] = Vector3DMake(-20.0, 0.0, 4.25);
    frontControlPoints[ 9] = Vector3DMake(-10.0, 0.0, 4.25);
    frontControlPoints[10] = Vector3DMake( 10.0, 0.0, 4.25);
    frontControlPoints[11] = Vector3DMake( 20.0, 0.0, 4.25);
    
    frontControlPoints[12] = Vector3DMake(-20.0, 0.0, 3.25);
    frontControlPoints[13] = Vector3DMake(-10.0, 0.0, 3.25);
    frontControlPoints[14] = Vector3DMake( 10.0, 0.0, 3.25);
    frontControlPoints[15] = Vector3DMake( 20.0, 0.0, 3.25);
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
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//    
//    glBindTexture(GL_TEXTURE_2D, [TextureController nameForKey:@"table"]);
    
    // TOP
    
    //glEnableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    
    glNormal3f(0.0, -1.0, 0.0);
    
//    Vector3D topVertexArray[] = 
//    {
//        Vector3DMake(-8.45, 0.0, -7.25),       
//        Vector3DMake( 8.45, 0.0, -7.25),        
//        Vector3DMake(-8.45, 0.0,  3.25),        
//        Vector3DMake( 8.45, 0.0,  3.25),
//    };

    Vector3D topVertexArray[] = 
    {
        Vector3DMake(-20.0, 0.0, -16.75),       
        Vector3DMake( 20.0, 0.0, -16.75),        
        Vector3DMake(-20.0, 0.0,   3.25),        
        Vector3DMake( 20.0, 0.0,   3.25),
    };
    
    GLushort topMeshArray[] =
    {
        0,
        1,
        2,
        2,
        1,
        3,
    };  
    
    Vector2D topTextureArray0[] =
    {
        Vector2DMake(-1, -2),        
        Vector2DMake(-1,  2),        
        Vector2DMake( 1, -2),        
        Vector2DMake( 1,  2),
    };

    Vector2D topTextureArray1[4];
    
    topTextureArray1[0] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(0, 0) : Vector2DMake(0.225, 0.289);      
    topTextureArray1[1] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(1, 0) : Vector2DMake(0.777, 0.289);        
    topTextureArray1[2] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(0, 1) : Vector2DMake(0.225, 1);        
    topTextureArray1[3] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(1, 1) : Vector2DMake(0.777, 1);
        
    GLfloat lightness = self.renderer.lightness.value;
    
    glColor4f(lightness, lightness, lightness, 0.45);
    
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
    
    Vector3D frontVertexArray [12];
    Vector3D frontNormalArray [12];
    Vector2D frontTextureArray0[12];
    Vector2D frontTextureArray1[12];
    
    GLushort meshArray[30];  
    
    int vertexWidth  = 6;
    int vertexHeight = 2;            
    
    GenerateBezierMesh(meshArray, vertexWidth, vertexHeight);
    
    GenerateBezierVertices(frontVertexArray,  vertexWidth, vertexHeight, frontControlPoints);
    GenerateBezierNormals (frontNormalArray,  vertexWidth, vertexHeight, frontControlPoints);
    GenerateBezierTextures(frontTextureArray0, vertexWidth, vertexHeight, Vector2DMake(4.0, 1.0 / 5.0), Vector2DMake(0, 0));
    
    frontTextureArray1[ 0] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(1, 1) : Vector2DMake(0.777, 1);
    frontTextureArray1[ 1] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(1, 1) : Vector2DMake(0.777, 1);
    frontTextureArray1[ 2] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(1, 1) : Vector2DMake(0.777, 1);
    frontTextureArray1[ 3] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(1, 1) : Vector2DMake(0.777, 1);
    frontTextureArray1[ 4] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(1, 1) : Vector2DMake(0.777, 1);
    frontTextureArray1[ 5] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(1, 1) : Vector2DMake(0.777, 1);
    frontTextureArray1[ 6] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(0, 1) : Vector2DMake(0.225, 1);
    frontTextureArray1[ 7] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(0, 1) : Vector2DMake(0.225, 1);
    frontTextureArray1[ 8] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(0, 1) : Vector2DMake(0.225, 1);
    frontTextureArray1[ 9] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(0, 1) : Vector2DMake(0.225, 1);
    frontTextureArray1[10] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(0, 1) : Vector2DMake(0.225, 1);
    frontTextureArray1[11] = self.drawStatus == GLTableDrawStatusDiffuse ? Vector2DMake(0, 1) : Vector2DMake(0.225, 1);
    
    
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
//    Vector3D topVertexArray[] = 
//    {
//        Vector3DMake(-20.0, 0.0, -16.75),
//        Vector3DMake( 20.0, 0.0, -16.75),
//        Vector3DMake(-20.0, 0.0,   3.25),
//        Vector3DMake( 20.0, 0.0,   3.25),
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
//    Vector3D frontVertexArray [12];
//    Vector3D frontNormalArray [12];
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