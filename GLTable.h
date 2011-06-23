//
//  GLTable.h
//  Studly
//
//  Created by Joel Bernstein on 6/28/09.
//  Copyright 2009 Joel Bernstein. All rights reserved.
//

#import "Touchable.h"

@class AnimatedFloat;
@class AnimatedVec3;
@class GLRenderer;

typedef enum 
{
    GLTableDrawStatusDiffuse,
    GLTableDrawStatusAmbient
} 
GLTableDrawStatus;

@interface GLTable : NSObject
{
    vec3 topCorners[4];
    vec3 frontControlPoints[16]; 
}

@property (nonatomic, assign) GLRenderer*   renderer;
@property (nonatomic, assign) GLTableDrawStatus drawStatus;

-(void)draw;
-(void)generate;

@end
