#import "Constants.h"
#import "Common.h"
#import "Geometry.h"

typedef enum 
{
    BezierLookup_5_3,
    BezierLookup_6_2,
    BezierLookup_2_2,
    BezierLookup_9_3,
    BezierLookup_5_3,
    BezierLookup_5_3,
} 
BezierLookup;

static void GenerateBezierControlPoints(Vector3D* arrayControl, Vector3D* arrayCorner)
{
    for(int controlRow = 0; controlRow < 4; controlRow++)
    {
        for(int controlCol = 0; controlCol < 4; controlCol++)
        {
            GLfloat u = (GLfloat)controlCol / 3.0;
            GLfloat v = (GLfloat)controlRow / 3.0;
            
            GLfloat weightRow[2];
            GLfloat weightCol[2];
            
            weightRow[0] = 1.0 - u;
            weightRow[1] = u;
            weightCol[0] = 1.0 - v;
            weightCol[1] = v;
            
            arrayControl[controlRow * 4 + controlCol] = Vector3DMake(0.0, 0.0, 0.0);
            
            for(int cornerRow = 0; cornerRow < 2; cornerRow++)
            {
                for(int cornerCol = 0; cornerCol < 2; cornerCol++)
                {
                    GLfloat weight = weightRow[cornerRow] * weightCol[cornerCol];
                    
                    arrayControl[controlRow * 4 + controlCol].x += arrayCorner[cornerRow * 2 + cornerCol].x * weight;
                    arrayControl[controlRow * 4 + controlCol].y += arrayCorner[cornerRow * 2 + cornerCol].y * weight;
                    arrayControl[controlRow * 4 + controlCol].z += arrayCorner[cornerRow * 2 + cornerCol].z * weight;
                }
            }        
        }
    }
}

static void GenerateBezierVertices(Vector3D* arrayVertex, int vertexWidth, int vertexHeight, Vector3D* arrayControl)
{
    for(int vertexRow = 0; vertexRow < vertexHeight; vertexRow++)
    {
        for(int vertexCol = 0; vertexCol < vertexWidth; vertexCol++)
        {
            GLfloat u = (GLfloat)vertexCol / (GLfloat)(vertexWidth  - 1);
            GLfloat v = (GLfloat)vertexRow / (GLfloat)(vertexHeight - 1);
            
            GLfloat nu = 1.0f - u;
            GLfloat nv = 1.0f - v;
            
            GLfloat weightRow[4];
            GLfloat weightCol[4];
            
            weightRow[0] =        nu * nu * nu;
            weightRow[1] = 3.0f * nu * nu *  u;
            weightRow[2] = 3.0f * nu *  u *  u;
            weightRow[3] =         u *  u *  u;
            
            weightCol[0] =        nv * nv * nv;
            weightCol[1] = 3.0f * nv * nv *  v;
            weightCol[2] = 3.0f * nv *  v *  v;
            weightCol[3] =         v *  v *  v;
            
            arrayVertex[vertexRow * vertexWidth + vertexCol] = Vector3DMake(0.0, 0.0, 0.0);
            
            for(int controlRow = 0; controlRow < 4; controlRow++)
            {
                for(int controlCol = 0; controlCol < 4; controlCol++)
                {
                    GLfloat weight = weightRow[controlRow] * weightCol[controlCol];
                    
                    arrayVertex[vertexRow * vertexWidth + vertexCol].x += arrayControl[controlRow * 4 + controlCol].x * weight;
                    arrayVertex[vertexRow * vertexWidth + vertexCol].y += arrayControl[controlRow * 4 + controlCol].y * weight;
                    arrayVertex[vertexRow * vertexWidth + vertexCol].z += arrayControl[controlRow * 4 + controlCol].z * weight;
                }
            }
        }
    }
}

static void GenerateBezierNormals(Vector3D* arrayNormal, int vertexWidth, int vertexHeight, Vector3D* arrayControl)
{
    for(int vertexRow = 0; vertexRow < vertexHeight; vertexRow++)
    {
        for(int vertexCol = 0; vertexCol < vertexWidth; vertexCol++)
        {
            GLfloat u = (GLfloat)vertexCol / (GLfloat)(vertexWidth  - 1);
            GLfloat v = (GLfloat)vertexRow / (GLfloat)(vertexHeight - 1);
            
            GLfloat nu = 1.0f - u;
            GLfloat nv = 1.0f - v;
            
            GLfloat weightRow[4];
            GLfloat weightCol[4];
            GLfloat derivativeRow[4];
            GLfloat derivativeCol[4];
            
            weightRow[0]     =        nu * nu * nu;
            weightRow[1]     = 3.0f * nu * nu *  u;
            weightRow[2]     = 3.0f * nu *  u *  u;
            weightRow[3]     =         u *  u *  u;
            
            weightCol[0]     =        nv * nv * nv;
            weightCol[1]     = 3.0f * nv * nv *  v;
            weightCol[2]     = 3.0f * nv *  v *  v;
            weightCol[3]     =         v *  v *  v;
            
            derivativeRow[0] =        nu * nu;
            derivativeRow[1] = 2.0f * nu *  u;
            derivativeRow[2] =         u *  u;
            
            derivativeCol[0] =        nv * nv;
            derivativeCol[1] = 2.0f * nv *  v;
            derivativeCol[2] =         v *  v;
            
            Vector3D tangentU = Vector3DMake(0.0, 0.0, 0.0);
            
            for(int controlRow = 0; controlRow < 3; controlRow++)
            {
                for(int controlCol = 0; controlCol < 4; controlCol++)
                {
                    GLfloat weight = derivativeRow[controlRow] * weightCol[controlCol];
                    
                    tangentU.x += (arrayControl[(controlRow + 1) * 4 + controlCol].x - arrayControl[controlRow * 4 + controlCol].x) * weight;
                    tangentU.y += (arrayControl[(controlRow + 1) * 4 + controlCol].y - arrayControl[controlRow * 4 + controlCol].y) * weight;
                    tangentU.z += (arrayControl[(controlRow + 1) * 4 + controlCol].z - arrayControl[controlRow * 4 + controlCol].z) * weight;
                }
            }
            
            Vector3D tangentV = Vector3DMake(0.0, 0.0, 0.0);
            
            for(int controlRow = 0; controlRow < 4; controlRow++)
            {
                for(int controlCol = 0; controlCol < 3 ; controlCol++)
                {
                    GLfloat weight = weightRow[controlRow] * derivativeCol[controlCol];
                    
                    tangentV.x += (arrayControl[controlRow * 4 + (controlCol + 1)].x - arrayControl[controlRow * 4 + controlCol].x) * weight;
                    tangentV.y += (arrayControl[controlRow * 4 + (controlCol + 1)].y - arrayControl[controlRow * 4 + controlCol].y) * weight;
                    tangentV.z += (arrayControl[controlRow * 4 + (controlCol + 1)].z - arrayControl[controlRow * 4 + controlCol].z) * weight;
                }
            }
            
            arrayNormal[vertexRow * vertexWidth + vertexCol] = Vector3DCrossProduct(tangentU, tangentV);
            
            Vector3DNormalize(&arrayNormal[vertexRow * vertexWidth + vertexCol]); 
        }
    }
}

static void GenerateBezierColors(Color3D* arrayColors, int vertexWidth, int vertexHeight, Color3D color1, Color3D color2, Color3D color3, Color3D color4)
{
    for(int vertexRow = 0; vertexRow < vertexHeight; vertexRow++)
    {
        for(int vertexCol = 0; vertexCol < vertexWidth; vertexCol++)
        {
            GLfloat u = (GLfloat)vertexRow / (GLfloat)(vertexHeight - 1);
            GLfloat v = (GLfloat)vertexCol / (GLfloat)(vertexWidth  - 1);
            
            Color3D colorTop = Color3DMake((1 - u) * color1.red   + u * color2.red, 
                                           (1 - u) * color1.green + u * color2.green, 
                                           (1 - u) * color1.blue  + u * color2.blue, 
                                           (1 - u) * color1.alpha + u * color2.alpha);
            
            Color3D colorBottom = Color3DMake((1 - u) * color3.red   + u * color4.red, 
                                              (1 - u) * color3.green + u * color4.green, 
                                              (1 - u) * color3.blue  + u * color4.blue, 
                                              (1 - u) * color3.alpha + u * color4.alpha);
            
            Color3D colorFinal = Color3DMake((1 - v) * colorTop.red   + v * colorBottom.red, 
                                             (1 - v) * colorTop.green + v * colorBottom.green, 
                                             (1 - v) * colorTop.blue  + v * colorBottom.blue, 
                                             (1 - v) * colorTop.alpha + v * colorBottom.alpha);
            
            arrayColors[vertexRow * vertexWidth + vertexCol] = colorFinal;
        }
    }    
}

static void GenerateBezierTextures(Vector2D* arrayTexture, int vertexWidth, int vertexHeight, Vector2D fragmentSize, Vector2D fragmentOffset)
{
    for(int vertexRow = 0; vertexRow < vertexHeight; vertexRow++)
    {
        for(int vertexCol = 0; vertexCol < vertexWidth; vertexCol++)
        {
            GLfloat u = 1 - ((GLfloat)vertexRow / (GLfloat)(vertexHeight - 1));
            GLfloat v = 1 - ((GLfloat)vertexCol / (GLfloat)(vertexWidth  - 1));
            
            arrayTexture[vertexRow * vertexWidth + vertexCol] = Vector2DMake(u * fragmentSize.u + fragmentOffset.u, v * fragmentSize.v + fragmentOffset.v);
        }
    }    
}

static void GenerateBezierMesh(GLushort* arrayMesh, int vertexWidth, int vertexHeight)
{
    int meshWidth  = vertexWidth  - 1;
    int meshHeight = vertexHeight - 1;
    
    for(int meshRow = 0; meshRow < meshHeight; meshRow++)
    {
        for(int meshCol = 0; meshCol < meshWidth; meshCol++)
        {
            int offset = 6 * (meshRow * meshWidth + meshCol);
            
            arrayMesh[offset + 0] = (meshRow + 0) * vertexWidth + (meshCol + 0); 
            arrayMesh[offset + 1] = (meshRow + 0) * vertexWidth + (meshCol + 1);
            arrayMesh[offset + 2] = (meshRow + 1) * vertexWidth + (meshCol + 0);
            
            arrayMesh[offset + 3] = (meshRow + 1) * vertexWidth + (meshCol + 0);
            arrayMesh[offset + 4] = (meshRow + 0) * vertexWidth + (meshCol + 1);
            arrayMesh[offset + 5] = (meshRow + 1) * vertexWidth + (meshCol + 1);
        }
    }   
}