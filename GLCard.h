//
//  GLCard.h
//  Tyche
//
//  Created by Joel Bernstein on 6/28/09.
//  Copyright 2009 Joel Bernstein. All rights reserved.
//

#import "Touchable.h"
#import "GameController.h"

@class GLCardGroup;
@class AnimatedFloat;
@class AnimatedVector3D;

@interface GLCard : NSObject
{
    GameRenderer* _renderer;

    GLCardGroup* _cardGroup;
    
    Vector3D   _controlPointsBase[16]; 
    Vector3D   _controlPointsFront[16];
    Vector3D   _controlPointsBack[16];
    Vector3D   _controlPointsLabel[16];
    Vector3D   _controlPointsShadow[16];
    
    Vector2D   textureOffsetCard[15];
    Vector2D   textureSizeCard;
    Vector2D   textureSizeLabel;
    
    Vector3D*  arrayVertex;
    Vector3D*  arrayNormal;
    Vector2D*  arrayTexture0;
    Vector2D*  arrayTexture1;
    GLushort*  arrayMesh;
    
    GLfloat    _angleJitter;
    int        _suit;
    int        _numeral;
    int        _position;
    BOOL       _isDead;
    
    AnimatedFloat*     _isHeld;
    AnimatedFloat*     _isSelected;
    AnimatedFloat*     _angleFlip;
    AnimatedFloat*     _angleFan;
    AnimatedVector3D*  _location;
}

@property (nonatomic, assign)   GameRenderer*       renderer;
@property (nonatomic, assign)   GLCardGroup*        cardGroup;
@property (nonatomic, assign)   int                 suit;
@property (nonatomic, assign)   int                 numeral;
@property (nonatomic, assign)   int                 position;
@property (nonatomic, assign)   GLfloat             angleJitter;
@property (nonatomic, assign)   BOOL                isDead;
@property (nonatomic, retain)   AnimatedFloat*      isHeld;
@property (nonatomic, retain)   AnimatedFloat*      isSelected;
@property (nonatomic, retain)   AnimatedFloat*      angleFlip;
@property (nonatomic, retain)   AnimatedFloat*      angleFan;
@property (nonatomic, retain)   AnimatedVector3D*   location;

-(id)initWithSuit:(int)suit numeral:(int)numeral;

-(void)drawFront;
-(void)drawBack;
-(void)drawShadow;
-(void)drawLabel;

-(void)generateWithBendFactor:(GLfloat)bendFactor;
-(void)rotateWithAngle:(GLfloat)angle aroundPoint:(Vector3D)point andAxis:(Vector3D)axis;
-(void)bendWithAngle:(GLfloat)angle aroundPoint:(Vector3D)point andAxis:(Vector3D)axis;
-(void)scaleWithFactor:(Vector3D)factor fromPoint:(Vector3D)point;
-(void)scaleShadowWithFactor:(Vector3D)factor fromPoint:(Vector3D)point;
-(void)translateWithVector:(Vector3D)vector;
-(void)flattenShadow;

@end

@interface GLCard (Touchable) <Touchable>

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object;
-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point;
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;
-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo;

@end