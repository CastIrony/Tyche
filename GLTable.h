//
//  GLTable.h
//  Tyche
//
//  Created by Joel Bernstein on 6/28/09.
//  Copyright 2009 Joel Bernstein. All rights reserved.
//

#import "Touchable.h"

@class AnimatedFloat;
@class AnimatedVector3D;
@class GameRenderer;

typedef enum 
{
    GLTableDrawStatusDiffuse,
    GLTableDrawStatusAmbient
} 
GLTableDrawStatus;

@interface GLTable : NSObject
{
    GameRenderer* _renderer;
    
    GLTableDrawStatus _drawStatus;
    Vector3D topCorners[4];
    Vector3D frontControlPoints[16]; 
}

@property (nonatomic, assign) GameRenderer*   renderer;
@property (nonatomic, assign) GLTableDrawStatus drawStatus;

-(void)draw;
-(void)generate;

@end
