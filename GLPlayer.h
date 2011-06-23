
//  GLPlayer.h
//  Studly
//
//  Created by Joel Bernstein on 2/16/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.

#import "DisplayContainer.h"
#import "Touchable.h"
#import "GLCamera.h"

@class GLRenderer;
@class GLCamera;
@class GLChipGroup;
@class GLCardGroup;
@class GLFlatCardGroup;

@interface GLPlayer : NSObject <Touchable, Displayable>

+(GLPlayer*)player;

@property (nonatomic, retain) GLChipGroup*         chipGroup;
@property (nonatomic, retain) GLCardGroup*         cardGroup;
@property (nonatomic, retain) GLFlatCardGroup*     flatCardGroup;
@property (nonatomic, retain) NSMutableDictionary* textControllers;
@property (nonatomic, assign) GLCameraStatus       cameraStatus;
@property (nonatomic, assign) GLRenderer*          renderer;
@property (nonatomic, copy)   NSString*            key;
@property (nonatomic, assign) GLfloat              offset;

@end
