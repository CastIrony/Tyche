#import "Constants.h"
#import "Common.h"
#import "MC3DVector.h"
#import "Touchable.h"
#import "DisplayContainer.h"

@class AnimatedFloat;
@class AnimatedVec3;
@class GLTexture;
@class GLTextController;
@class GLRenderer;

typedef enum 
{
    LabelStatusNothingSelected,
    LabelStatusTextSelected,
    LabelStatusBulletLeftSelected,    
    LabelStatusBulletRightSelected
} 
LabelStatus;

@interface GLText : NSObject
{   
    vec3* arrayTextVertex;
    vec3* arrayBorderVertex;
    vec3* arrayBulletRightVertex;
    vec3* arrayBulletLeftVertex;
    vec2* arrayTextTextureBase;
    vec2* arrayTextTextureScrolled;
    vec2* arrayBorderTexture;
    vec2* arrayBulletTexture;
    GLushort* arrayTextMesh;
    GLushort* arrayBorderMesh;
    GLushort* arrayBulletMesh;
}

@property (nonatomic, assign)   GLTextController*   textController;
@property (nonatomic, assign)   LabelStatus   labelStatus;

@property (nonatomic, retain)   GLTexture*        textureText;
@property (nonatomic, retain)   GLTexture*        textureBulletLeft;
@property (nonatomic, retain)   GLTexture*        textureBulletRight;

@property (nonatomic, copy)     NSString*         key;

@property (nonatomic, assign)   GLfloat           lightness;

@property (nonatomic, retain)   AnimatedVec3* layoutLocation;
@property (nonatomic, retain)   AnimatedFloat*    layoutOpacity;
@property (nonatomic, retain)   AnimatedFloat*    death;

@property (nonatomic, copy)     NSString*         textString;
@property (nonatomic, copy)     NSString*         bulletLeftString;
@property (nonatomic, copy)     NSString*         bulletRightString;
@property (nonatomic, retain)   UIFont*           font;

@property (nonatomic, assign)   CGSize            labelSize;

@property (nonatomic, assign)   GLfloat           fadeMargin;
@property (nonatomic, assign)   GLfloat           topMargin;
@property (nonatomic, assign)   GLfloat           bottomMargin;
@property (nonatomic, assign)   GLfloat           topPadding;
@property (nonatomic, assign)   GLfloat           bottomPadding;

@property (nonatomic, assign)   color           colorNormal;
@property (nonatomic, assign)   color           colorTouched;
@property (nonatomic, assign)   UITextAlignment   textAlignment;

@property (nonatomic, assign)   GLfloat           scrollBase;
@property (nonatomic, assign)   GLfloat           scrollAmplitude;

@property (nonatomic, assign)   BOOL              isLabelTouched;

@property (nonatomic, assign)   BOOL              hasBorder;
@property (nonatomic, assign)   BOOL              hasShadow;

@property (nonatomic, readonly) CGSize            layoutSize;
@property (nonatomic, readonly) CGSize            borderSize;
       
@property (nonatomic, assign) id owner;

+(GLText*)emptyLabel;
+(GLText*)withDictionaries:(NSArray*)dictionaries;
-(void)makeMeshes;
-(void)draw;

@end

@interface GLText (Touchable) <Touchable>

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;
-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end

@interface GLText (Displayable) <Displayable>

@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) BOOL isAlive;

-(void)killWithDisplayContainer:(DisplayContainer*)container key:(id)key andThen:(SimpleBlock)work;
@end