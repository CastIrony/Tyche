#import "Constants.h"
#import "Common.h"

typedef struct 
{
    GLfloat	red;
    GLfloat	green;
    GLfloat	blue;
    GLfloat alpha;
} Color3D;

static inline Color3D Color3DMake(CGFloat inRed, CGFloat inGreen, CGFloat inBlue, CGFloat inAlpha)
{
    Color3D ret;
	ret.red = inRed;
	ret.green = inGreen;
	ret.blue = inBlue;
	ret.alpha = inAlpha;
    return ret;
}

typedef struct 
{
    GLfloat	u;
    GLfloat v;
} Vector2D;

static inline Vector2D Vector2DMake(CGFloat inU, CGFloat inV)
{
	Vector2D ret;
	ret.u = inU;
	ret.v = inV;
	return ret;
}

typedef struct 
{
    GLfloat	x;
    GLfloat y;
    GLfloat z;
} Vector3D;

static inline Vector3D Vector3DMake(GLfloat inX, GLfloat inY, GLfloat inZ)
{
	Vector3D ret;
	ret.x = inX;
	ret.y = inY;
	ret.z = inZ;
	return ret;
}

static inline Vector3D Vector3DProjectShadow(Vector3D light, Vector3D point)
{
    return Vector3DMake((light.y * point.x - point.y * light.x) / (light.y - point.y), 
                        0, 
                        (light.y * point.z - point.y * light.z) / (light.y - point.y));   
}

static inline Vector3D Vector3DInterpolate(Vector3D startValue, Vector3D endValue, GLfloat proportion)
{
    return Vector3DMake((1.0 - proportion) * startValue.x + (proportion) * endValue.x,
                        (1.0 - proportion) * startValue.y + (proportion) * endValue.y,
                        (1.0 - proportion) * startValue.z + (proportion) * endValue.z);
}

static inline GLfloat Vector3DMagnitude(Vector3D vector)
{
	return sqrtf((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z)); 
}

static inline void Vector3DNormalize(Vector3D *vector)
{
	GLfloat vecMag = Vector3DMagnitude(*vector);
	
    if(vecMag == 0.0)
	{
		vector->x /= 1.0;
		vector->y /= 0.0;
		vector->z /= 0.0;
	}
    
	vector->x /= vecMag;
	vector->y /= vecMag;
	vector->z /= vecMag;
}

static inline GLfloat Vector3DDotProduct(Vector3D vector1, Vector3D vector2)
{		
	return vector1.x * vector2.x + vector1.y * vector2.y + vector1.z * vector2.z;
}

static inline GLfloat Vector2DDotProduct(Vector2D vector1, Vector2D vector2)
{		
	return vector1.u * vector2.u + vector1.v * vector2.v;
}

static inline Vector3D Vector3DCrossProduct(Vector3D vector1, Vector3D vector2)
{
	Vector3D ret;
	ret.x = (vector1.y * vector2.z) - (vector1.z * vector2.y);
	ret.y = (vector1.z * vector2.x) - (vector1.x * vector2.z);
	ret.z = (vector1.x * vector2.y) - (vector1.y * vector2.x);
	return ret;
}

static inline Vector3D Vector3DMakeWithStartAndEndPoints(Vector3D start, Vector3D end)
{
	Vector3D ret;
	ret.x = end.x - start.x;
	ret.y = end.y - start.y;
	ret.z = end.z - start.z;
	return ret;
}

static inline Vector2D Vector2DMakeWithStartAndEndPoints(Vector2D start, Vector2D end)
{
	Vector2D ret;
	ret.u = end.u - start.u;
	ret.v = end.v - start.v;
	return ret;
}

static inline Vector3D Vector3DAdd(Vector3D vector1, Vector3D vector2)
{
	Vector3D ret;
	ret.x = vector1.x + vector2.x;
	ret.y = vector1.y + vector2.y;
	ret.z = vector1.z + vector2.z;
	return ret;
}

static inline void Vector3DFlip (Vector3D *vector)
{
	vector->x = -vector->x;
	vector->y = -vector->y;
	vector->z = -vector->z;
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

static BOOL TestTriangle(Vector2D P, Vector2D A, Vector2D B, Vector2D C)
{
    // Compute vectors        
    Vector2D v0 = Vector2DMakeWithStartAndEndPoints(A, C);
    Vector2D v1 = Vector2DMakeWithStartAndEndPoints(A, B);
    Vector2D v2 = Vector2DMakeWithStartAndEndPoints(A, P);
    
    // Compute dot products
    GLfloat dot00 = Vector2DDotProduct(v0, v0);
    GLfloat dot01 = Vector2DDotProduct(v0, v1);
    GLfloat dot02 = Vector2DDotProduct(v0, v2);
    GLfloat dot11 = Vector2DDotProduct(v1, v1);
    GLfloat dot12 = Vector2DDotProduct(v1, v2);
     
    // Compute barycentric coordinates
    GLfloat invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
    GLfloat u = (dot11 * dot02 - dot01 * dot12) * invDenom;
    GLfloat v = (dot00 * dot12 - dot01 * dot02) * invDenom;
     
    // Check if point is in triangle
    return (u > 0) && (v > 0) && (u + v < 1);
}

static BOOL TestTriangles(Vector2D touchLocation, Vector2D* points, GLushort* triangles, int triangleCount)
{
    for(int triangleCounter = 0; triangleCounter < triangleCount; triangleCounter++)
    {
        Vector2D point1 = points[triangles[3 * triangleCounter + 0]];
        Vector2D point2 = points[triangles[3 * triangleCounter + 1]];
        Vector2D point3 = points[triangles[3 * triangleCounter + 2]];
        
        if(TestTriangle(touchLocation, point1, point2, point3))
        {
            return YES;
        }
    }
    
    return NO;
}

static Vector3D randomVector3D(GLfloat originX, GLfloat originY, GLfloat originZ, GLfloat distanceX, GLfloat distanceY, GLfloat distanceZ )
{
    Vector3D randomVector = Vector3DMake(randomFloat(-0.5, 0.5), 
                                         randomFloat(-0.5, 0.5),
                                         randomFloat(-0.5, 0.5));

    Vector3DNormalize(&randomVector);

    return Vector3DMake(originX + randomVector.x * distanceX,
                        originY + randomVector.y * distanceY,
                        originZ + randomVector.z * distanceZ);
}

static void rotateVectors(Vector3D* points, int count, GLfloat angle, Vector3D origin, Vector3D axis)
{    
    GLfloat sinT = sin(DEGREES_TO_RADIANS(angle));
    GLfloat cosT = cos(DEGREES_TO_RADIANS(angle));
    
    GLfloat a  = origin.x;
    GLfloat b  = origin.y;
    GLfloat c  = origin.z;
    
    GLfloat u  = axis.x;
    GLfloat v  = axis.y;
    GLfloat w  = axis.z;
    
    GLfloat u2 = u * u;
    GLfloat v2 = v * v;
    GLfloat w2 = w * w;
    
    GLfloat l2 = u2 + v2 + w2;
    GLfloat l  = sqrt(l2);
    
    GLfloat m11 = (u2 + (v2 + w2) * cosT) / l2;
    GLfloat m22 = (v2 + (u2 + w2) * cosT) / l2;
    GLfloat m33 = (w2 + (u2 + v2) * cosT) / l2;
    
    GLfloat m12 = (u * v * (1 - cosT) - w * l * sinT) / l2;
    GLfloat m13 = (u * w * (1 - cosT) + v * l * sinT) / l2;
    GLfloat m21 = (u * v * (1 - cosT) + w * l * sinT) / l2;
    GLfloat m23 = (v * w * (1 - cosT) - u * l * sinT) / l2;
    GLfloat m31 = (u * w * (1 - cosT) - v * l * sinT) / l2;
    GLfloat m32 = (v * w * (1 - cosT) + u * l * sinT) / l2;
    
    GLfloat m14 = (a * (v2 + w2) - u * (b * v + c * w) + (u * (b * v + c * w) - a * (v2 + w2)) * cosT + (b * w - c * v) * l * sinT) / l2;
    GLfloat m24 = (b * (u2 + w2) - v * (a * u + c * w) + (v * (a * u + c * w) - b * (u2 + w2)) * cosT + (c * u - a * w) * l * sinT) / l2;
    GLfloat m34 = (c * (u2 + v2) - w * (a * u + b * v) + (w * (a * u + b * v) - c * (u2 + v2)) * cosT + (a * v - b * u) * l * sinT) / l2;
    
    Vector3D point;
    Vector3D newPoint;
    
    for(int i = 0; i < count; i++)
    {
        point = points[i];
        
        newPoint.x = m11 * point.x + m12 * point.y + m13 * point.z + m14;
        newPoint.y = m21 * point.x + m22 * point.y + m23 * point.z + m24;
        newPoint.z = m31 * point.x + m32 * point.y + m33 * point.z + m34;
        
        points[i] = newPoint;
    }
}