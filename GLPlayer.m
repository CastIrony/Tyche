
//  GLPlayer.m
//  Studly
//
//  Created by Joel Bernstein on 2/16/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.

#import "GLChipGroup.h"
#import "GLCardGroup.h"
#import "GLFlatCardGroup.h"
#import "GLCamera.h"
#import "GLTextControllerActions.h"
#import "GLTextControllerCredits.h"
#import "GLTextControllerStatusBar.h"

#import "GLPlayer.h"

@implementation GLPlayer

+(GLPlayer*)player
{
    return [[[GLPlayer alloc] init] autorelease];
}

@synthesize chipGroup        = _chipGroup;
@synthesize cardGroup        = _cardGroup;
@synthesize flatCardGroup    = _flatCardGroup;
@synthesize textControllers  = _textControllers;
@synthesize displayContainer = _displayContainer;
@synthesize cameraStatus     = _cameraStatus;
@synthesize renderer         = _renderer;
@synthesize key              = _key;
@synthesize offset           = _offset;

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object { return nil; }

-(void)handleTouchDown: (UITouch*)touch fromPoint:(CGPoint)point {}
-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo {}
-(void)handleTouchUp:   (UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo {}

-(BOOL)isAlive { return YES; }
-(BOOL)isDead  { return NO; }

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.chipGroup        = [GLChipGroup         chipGroup];
        self.cardGroup        = [GLCardGroup         cardGroup]; 
        self.flatCardGroup    = [GLFlatCardGroup     flatCardGroup]; 
        self.textControllers  = [NSMutableDictionary dictionary];
        self.cameraStatus     = CameraStatusNormal;
        
        self.chipGroup.player = self;
        self.cardGroup.player = self;
        self.flatCardGroup.player = self;
    }
    
    return self;
}

-(void)appearAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work;
{
    {
        GLTextControllerCredits* textController = [[[GLTextControllerCredits alloc] init] autorelease];
        
        textController.renderer = self.renderer;
        
        textController.location = vec3Make(5.25, 0, 0);
        
        textController.creditTotal = 0;
        textController.betTotal = 0;
        
        [textController update];
        
        [self.textControllers setObject:textController forKey:@"credits"];
    }
    
    {
        GLTextControllerActions* textController = [[[GLTextControllerActions alloc] init] autorelease];
        
        textController.renderer = self.renderer;
        
        textController.location = vec3Make(0, 0, 0);
        
        [self.textControllers setObject:textController forKey:@"gameOver"];
    }
    
    {
        GLTextControllerActions* textController = [[[GLTextControllerActions alloc] init] autorelease];
        
        textController.renderer = self.renderer;
        
        textController.location = vec3Make(-5.25, 0, 0);
        
        [self.textControllers setObject:textController forKey:@"actions"];
    }
    
    {
        GLTextControllerStatusBar* textController = [[[GLTextControllerStatusBar alloc] init] autorelease];
        
        textController.renderer = self.renderer;
        
        textController.location = vec3Make(0, 0, -6.6);
        
        [self.textControllers setObject:textController forKey:@"messageDown"];
    }
    
    {
        GLTextControllerStatusBar* textController = [[[GLTextControllerStatusBar alloc] init] autorelease];
        
        textController.renderer = self.renderer;
        
        textController.location = vec3Make(0, 0, -5.2);
        
        textController.anglePitch = -90;
        
        [self.textControllers setObject:textController forKey:@"messageUp"];
    }

    RunAfterDelay(delay, work);
}

-(void)dieAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work
{
    RunAfterDelay(delay, work);
}

-(BOOL)isEqual:(id)object
{
    if(![object isKindOfClass:[GLPlayer class]]) { return NO; }
    
    GLPlayer* player = (GLPlayer*)object;
    
    return player.key == self.key;
}

@end