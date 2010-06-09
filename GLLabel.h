#import "Constants.h"
#import "Common.h"
#import "Geometry.h"
#import "Touchable.h"

@class AnimatedFloat;
@class AnimatedVector3D;
@class GLTexture;
@class TextController;
@class GameRenderer;

typedef enum 
{
    LabelStatusNothingSelected,
    LabelStatusTextSelected,
    LabelStatusBulletLeftSelected,    
    LabelStatusBulletRightSelected
} 
LabelStatus;

@interface GLLabel : NSObject
{   
    LabelStatus       _labelStatus;
    
    TextController*   _textController;
    
    GLTexture*        _textureText;
    GLTexture*        _textureBulletLeft;
    GLTexture*        _textureBulletRight;
    
    NSString*         _key;
    
    GLfloat           _lightness;
    
    AnimatedVector3D* _layoutLocation;
    AnimatedFloat*    _layoutOpacity;
    
    NSString*         _textString;
    NSString*         _bulletLeftString;
    NSString*         _bulletRightString;
    UIFont*           _font;
    CGSize            _labelSize;
    GLfloat           _fadeMargin;
    Color3D           _colorNormal;
    Color3D           _colorTouched;
    UITextAlignment   _textAlignment;
    
    CGSize            _textSize;
    CGSize            _bulletLeftSize;
    CGSize            _bulletRightSize;
    
    GLfloat           _scrollBase;
    GLfloat           _scrollAmplitude;
    
    BOOL              _isLabelTouched;
    BOOL              _hasBorder;
    BOOL              _hasShadow;
    
    Vector3D* arrayTextVertex;
    Vector3D* arrayBorderVertex;
    Vector3D* arrayBulletRightVertex;
    Vector3D* arrayBulletLeftVertex;
    Vector2D* arrayTextTexture;
    Vector2D* arrayBorderTexture;
    Vector2D* arrayBulletTexture;
    GLushort* arrayTextMesh;
    GLushort* arrayBorderMesh;
    GLushort* arrayBulletMesh;
    
    id _owner;
}

@property (nonatomic, assign)   TextController*   textController;
@property (nonatomic, assign)   LabelStatus   labelStatus;

@property (nonatomic, retain)   GLTexture*        textureText;
@property (nonatomic, retain)   GLTexture*        textureBulletLeft;
@property (nonatomic, retain)   GLTexture*        textureBulletRight;

@property (nonatomic, copy)     NSString*         key;

@property (nonatomic, assign)   GLfloat           lightness;

@property (nonatomic, retain)   AnimatedVector3D* layoutLocation;
@property (nonatomic, retain)   AnimatedFloat*    layoutOpacity;

@property (nonatomic, retain)   NSString*         textString;
@property (nonatomic, retain)   NSString*         bulletLeftString;
@property (nonatomic, retain)   NSString*         bulletRightString;
@property (nonatomic, retain)   UIFont*           font;
@property (nonatomic, assign)   CGSize            labelSize;
@property (nonatomic, assign)   GLfloat           fadeMargin;
@property (nonatomic, assign)   Color3D           colorNormal;
@property (nonatomic, assign)   Color3D           colorTouched;
@property (nonatomic, assign)   UITextAlignment   textAlignment;

@property (nonatomic, assign)   GLfloat           scrollBase;
@property (nonatomic, assign)   GLfloat           scrollAmplitude;

@property (nonatomic, assign)   BOOL              isLabelTouched;

@property (nonatomic, assign)   BOOL              hasBorder;
@property (nonatomic, assign)   BOOL              hasShadow;

@property (nonatomic, assign)   CGSize            textSize;
@property (nonatomic, assign)   CGSize            bulletLeftSize;
@property (nonatomic, assign)   CGSize            bulletRightSize;
@property (nonatomic, readonly) CGSize            layoutSize;
@property (nonatomic, readonly) CGSize            borderSize;
       
@property (nonatomic, assign) id owner;

+(GLLabel*)emptyLabel;
+(GLLabel*)withDictionaries:(NSArray*)dictionaries;
-(void)makeMeshes;
-(void)draw;

@end

@interface GLLabel (Touchable) <Touchable>

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;
-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end