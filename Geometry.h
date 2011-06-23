#import "Constants.h"
#import "Common.h"
#import "MC3DVector.h"

static inline vec3 vec3ProjectShadow(vec3 light, vec3 point)
{
    return vec3Make((light.y * point.x - point.y * light.x) / (light.y - point.y), 
                    0, 
                    (light.y * point.z - point.y * light.z) / (light.y - point.y));   
}


// This is a modified version of the function of the same name from 
// the Mesa3D project ( http://mesa3d.org/ ), which is  licensed
// under the MIT license, which allows use, modification, and 
// redistribution
static inline void gluLookAt(GLfloat eyex, GLfloat eyey, GLfloat eyez, GLfloat centerx, GLfloat centery, GLfloat centerz, GLfloat upx, GLfloat upy, GLfloat upz)
{
	GLfloat m[16];
	GLfloat x[3], y[3], z[3];
	GLfloat mag;
	
	/* Make rotation matrix */
	
	/* Z vector */
	z[0] = eyex - centerx;
	z[1] = eyey - centery;
	z[2] = eyez - centerz;
	mag = sqrtf(z[0] * z[0] + z[1] * z[1] + z[2] * z[2]);
	if (mag) {			/* mpichler, 19950515 */
		z[0] /= mag;
		z[1] /= mag;
		z[2] /= mag;
	}
	
	/* Y vector */
	y[0] = upx;
	y[1] = upy;
	y[2] = upz;
	
	/* X vector = Y cross Z */
	x[0] = y[1] * z[2] - y[2] * z[1];
	x[1] = -y[0] * z[2] + y[2] * z[0];
	x[2] = y[0] * z[1] - y[1] * z[0];
	
	/* Recompute Y = Z cross X */
	y[0] = z[1] * x[2] - z[2] * x[1];
	y[1] = -z[0] * x[2] + z[2] * x[0];
	y[2] = z[0] * x[1] - z[1] * x[0];
	
	/* mpichler, 19950515 */
	/* cross product gives area of parallelogram, which is < 1.0 for
	 * non-perpendicular unit-length vectors; so normalize x, y here
	 */
	
	mag = sqrtf(x[0] * x[0] + x[1] * x[1] + x[2] * x[2]);
	if (mag) {
		x[0] /= mag;
		x[1] /= mag;
		x[2] /= mag;
	}
	
	mag = sqrtf(y[0] * y[0] + y[1] * y[1] + y[2] * y[2]);
	if (mag) {
		y[0] /= mag;
		y[1] /= mag;
		y[2] /= mag;
	}
	
#define M(row,col)  m[col*4+row]
	M(0, 0) = x[0];
	M(0, 1) = x[1];
	M(0, 2) = x[2];
	M(0, 3) = 0.0;
	M(1, 0) = y[0];
	M(1, 1) = y[1];
	M(1, 2) = y[2];
	M(1, 3) = 0.0;
	M(2, 0) = z[0];
	M(2, 1) = z[1];
	M(2, 2) = z[2];
	M(2, 3) = 0.0;
	M(3, 0) = 0.0;
	M(3, 1) = 0.0;
	M(3, 2) = 0.0;
	M(3, 3) = 1.0;
#undef M
    
	glMultMatrixf(m);
	
	/* Translate Eye to Origin */
	glTranslatef(-eyex, -eyey, -eyez);
}

static BOOL TestTriangle(vec2 P, vec2 A, vec2 B, vec2 C)
{
    // Compute vectors
    vec2 v0 = vec2Subtract(C, A);
    vec2 v1 = vec2Subtract(B, A);
    vec2 v2 = vec2Subtract(P, A);
    
    // Compute dot products
    GLfloat dot00 = vec2DotProduct(v0, v0);
    GLfloat dot01 = vec2DotProduct(v0, v1);
    GLfloat dot02 = vec2DotProduct(v0, v2);
    GLfloat dot11 = vec2DotProduct(v1, v1);
    GLfloat dot12 = vec2DotProduct(v1, v2);
     
    // Compute barycentric coordinates
    GLfloat invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
    GLfloat u = (dot11 * dot02 - dot01 * dot12) * invDenom;
    GLfloat v = (dot00 * dot12 - dot01 * dot02) * invDenom;
    
    // Check if point is in triangle
    return (u > 0) && (v > 0) && (u + v < 1);
}

static BOOL TestTriangles(vec2 touchLocation, vec2* points, GLushort* triangles, int triangleCount)
{
    for(int triangleCounter = 0; triangleCounter < triangleCount; triangleCounter++)
    {
        vec2 point1 = points[triangles[3 * triangleCounter + 0]];
        vec2 point2 = points[triangles[3 * triangleCounter + 1]];
        vec2 point3 = points[triangles[3 * triangleCounter + 2]];
        
        if(TestTriangle(touchLocation, point1, point2, point3))
        {
            return YES;
        }
    }
    
    return NO;
}

static vec3 randomvec3(GLfloat originX, GLfloat originY, GLfloat originZ, GLfloat distanceX, GLfloat distanceY, GLfloat distanceZ )
{
    vec3 randomVector = vec3Make(randomFloat(-0.5, 0.5), 
                                 randomFloat(-0.5, 0.5),
                                 randomFloat(-0.5, 0.5));

    vec3Normalize(&randomVector);

    return vec3Make(originX + randomVector.x * distanceX,
                    originY + randomVector.y * distanceY,
                    originZ + randomVector.z * distanceZ);
}

static void rotateVectors(vec3* points, int count, GLfloat angle, vec3 origin, vec3 axis)
{    
    GLfloat sinT = sin(DEGREES_TO_RADIANS(angle));
    GLfloat cosT = cos(DEGREES_TO_RADIANS(angle));
    
    GLfloat ox  = origin.x;
    GLfloat oy  = origin.y;
    GLfloat oz  = origin.z;
    
    GLfloat ax  = axis.x;
    GLfloat ay  = axis.y;
    GLfloat az  = axis.z;
    
    GLfloat ax2 = ax * ax;
    GLfloat ay2 = ay * ay;
    GLfloat az2 = az * az;
    
    GLfloat l2 = ax2 + ay2 + az2;
    GLfloat l  = sqrt(l2);
    
    GLfloat m21 = (ax * ay * (1 - cosT) + az * l * sinT) / l2;
    GLfloat m31 = (ax * az * (1 - cosT) - ay * l * sinT) / l2;
    
    GLfloat m12 = (ax * ay * (1 - cosT) - az * l * sinT) / l2;
    GLfloat m32 = (ay * az * (1 - cosT) + ax * l * sinT) / l2;
    
    GLfloat m13 = (ax * az * (1 - cosT) + ay * l * sinT) / l2;
    GLfloat m23 = (ay * az * (1 - cosT) - ax * l * sinT) / l2;

    GLfloat m22 = (ay2 + (ax2 + az2) * cosT) / l2;
    GLfloat m11 = (ax2 + (ay2 + az2) * cosT) / l2;
    GLfloat m33 = (az2 + (ax2 + ay2) * cosT) / l2;
    
    GLfloat m14 = (ox * (ay2 + az2) - ax * (oy * ay + oz * az) + (ax * (oy * ay + oz * az) - ox * (ay2 + az2)) * cosT + (oy * az - oz * ay) * l * sinT) / l2;
    GLfloat m24 = (oy * (ax2 + az2) - ay * (ox * ax + oz * az) + (ay * (ox * ax + oz * az) - oy * (ax2 + az2)) * cosT + (oz * ax - ox * az) * l * sinT) / l2;
    GLfloat m34 = (oz * (ax2 + ay2) - az * (ox * ax + oy * ay) + (az * (ox * ax + oy * ay) - oz * (ax2 + ay2)) * cosT + (ox * ay - oy * ax) * l * sinT) / l2;
    
    GLfloat m41 = 0;
    GLfloat m42 = 0;
    GLfloat m43 = 0;
    GLfloat m44 = 1;
    
    vec3 point;
    vec3 newPoint;
    
    for(int i = 0; i < count; i++)
    {
        point = points[i];
        
        newPoint.x = m11 * point.x + m12 * point.y + m13 * point.z + m14;
        newPoint.y = m21 * point.x + m22 * point.y + m23 * point.z + m24;
        newPoint.z = m31 * point.x + m32 * point.y + m33 * point.z + m34;
        
        points[i] = newPoint;
    }
}