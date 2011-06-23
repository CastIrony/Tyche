//
//  GameRenderer.m
//  Studly
//
//  Created by Joel Bernstein on 9/24/09.
//  Copyright Joel Bernstein 2009. All rights reserved.
//

#import "Geometry.h"
#import "AnimatedFloat.h"
#import "AnimatedVec3.h"
#import "GLTextController.h"
#import "GLMenu.h"
#import "GLCard.h"
#import "GLPlayer.h"
#import "GLTable.h"
#import "GLSplash.h"
#import "GLMenuController.h"
#import "GLMenuLayerController.h"
#import "GLFlatCardGroup.h"
#import "GLCardGroup.h"
#import "GLChipGroup.h"
#import "GLChip.h"
#import "GLText.h"
#import "AppController.h"
#import "SoundController.h"
#import "GameController.h"
#import "GLTexture.h"
#import "GLCamera.h"
#import "GLTextControllerMainMenu.h"
#import "GLTextControllerCredits.h"
#import "GLTextControllerStatusBar.h"
#import "GLTextControllerServerInfo.h"
#import "TextureController.h"
#import "GLMenuControllerJoinGame.h"
#import "GLMenuControllerMain.h"
#import "DisplayContainer.h"
#import "NSArray+JBCommon.h"
#import "GLView.h"
#import "GLRenderer.h"

@implementation GLRenderer

@synthesize appController       = _appController;
@synthesize touchedObjects      = _touchedObjects;
@synthesize touchedLocations    = _touchedLocations;
@synthesize players             = _players;
@synthesize table               = _table;
@synthesize camera              = _camera;
@synthesize splash              = _splash;
@synthesize menuLayerController = _menuLayerController;
@synthesize currentOffset       = _offset;
@synthesize initialOffset       = _initialOffset;
@synthesize lightness           = _lightness;
@synthesize currentPlayer       = _currentPlayer;

@dynamic glView;
@dynamic mainPlayer;
@dynamic gameController;
@dynamic soundController;

-(GLView*)glView
{
    return (GLView*)self.view;
}

-(GameController*)gameController
{
    return self.appController.gameController;
}

-(SoundController*)soundController
{
    return nil;
}

-(id)init
{
    self = [super init];
    
	if(self)
	{
        self.lightness = [AnimatedFloat floatWithValue:1];
        self.currentOffset    = [AnimatedFloat floatWithValue:0];
        
        GLView* glView = [[[GLView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
        
        glView.renderer = self;
        
        self.view = glView;
        
        [self load];
    }
	
	return self;
}

-(void)load
{
    //setup code:
        
    self.camera = [[[GLCamera alloc] init] autorelease];
    
    self.camera.renderer = self;
    
    glDisable(GL_DEPTH_TEST);
    
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_CULL_FACE);
    glEnable(GL_COLOR_MATERIAL);
    glEnable(GL_BLEND);                            

    glActiveTexture(GL_TEXTURE0);
	glEnable(GL_TEXTURE_2D);

	glActiveTexture(GL_TEXTURE1);
	glEnable(GL_TEXTURE_2D);

    glActiveTexture(GL_TEXTURE0);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    GLfloat light0diffuse[] = {0.80, 0.80, 0.80, 1.0}; 
    
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light0diffuse);
    
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST); 
    
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    self.players          = [DisplayContainer container];
    self.splash           = [[[GLSplash            alloc] init] autorelease]; 
    self.table            = [[[GLTable             alloc] init] autorelease]; 
    self.touchedObjects   = [NSMutableDictionary dictionary];
    self.touchedLocations = [NSMutableDictionary dictionary];
    
    self.menuLayerController = [[[GLMenuLayerController alloc] init] autorelease];
    
    self.menuLayerController.renderer = self;
    
    [TextureController setTexture:[[[GLTexture alloc] initWithImageFile:@"lightmap.png" ] autorelease] forKey:@"lightmap"];
    [TextureController setTexture:[[[GLTexture alloc] initWithImageFile:@"chips3.png"   ] autorelease] forKey:@"chips"];
    [TextureController setTexture:[[[GLTexture alloc] initWithImageFile:@"cards2.png"   ] autorelease] forKey:@"cards"];
    [TextureController setTexture:[[[GLTexture alloc] initWithImageFile:@"shadow.png"   ] autorelease] forKey:@"shadow"];
    [TextureController setTexture:[[[GLTexture alloc] initWithPVRTCFile:@"felt3.pvr4"   ] autorelease] forKey:@"table"];
    [TextureController setTexture:[[[GLTexture alloc] initWithImageFile:@"Default.png"  ] autorelease] forKey:@"splash"];
    [TextureController setTexture:[[[GLTexture alloc] initWithPVRTCFile:@"heartsflat.pvr4"  ] autorelease] forKey:@"suit0"];
    [TextureController setTexture:[[[GLTexture alloc] initWithPVRTCFile:@"diamondsflat.pvr4"] autorelease] forKey:@"suit1"];
    [TextureController setTexture:[[[GLTexture alloc] initWithPVRTCFile:@"clubsflat.pvr4"   ] autorelease] forKey:@"suit2"];
    [TextureController setTexture:[[[GLTexture alloc] initWithPVRTCFile:@"spadesflat.pvr4"  ] autorelease] forKey:@"suit3"];
    
    UIFont* font = [UIFont fontWithName:@"Futura-Medium" size:15.0];
    
    [TextureController setTexture:[[[GLTexture alloc] initWithString:@" " font:font] autorelease] forKey:@"hold"];
    [TextureController setTexture:[[[GLTexture alloc] initWithString:@"DRAW" font:font] autorelease] forKey:@"draw"];
    [TextureController setTexture:[[[GLTexture alloc] initWithButtonOpacity:0.25] autorelease] forKey:@"borderNormal"];
    [TextureController setTexture:[[[GLTexture alloc] initWithButtonOpacity:0.70] autorelease] forKey:@"borderTouched"];
    
    self.splash.renderer = self;
    self.table.renderer = self;
        
    NSMutableArray* servers = [NSMutableArray array];
                                
    [servers addObject:@"☃Joel's iPhone"];                           
    [servers addObject:@"☝Rachel's iPod"];                           
    [servers addObject:@"♜Carolyn's iPhone"];                           
    [servers addObject:@"☠John's iPod"];                           
    [servers addObject:@"Sarah's iPhone"];                           
    [servers addObject:@"♘Michele's iPod"];                           
    [servers addObject:@"☂Bonnie's iPhone"];                           
    [servers addObject:@"♂Charles's iPod"];    
    
    srand48(time(NULL));
    
    [self.menuLayerController pushMenuLayer:[GLMenuControllerMain withRenderer:self] forKey:@"main"];
    
    GLfloat zNear       =   0.001;
    GLfloat zFar        = 500.00;
    GLfloat fieldOfView =  30.00; 
    GLfloat size        = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0);
        
    CGRect viewport = self.glView.viewport;
    
    glMatrixMode(GL_PROJECTION); 
    
    glFrustumf(-size, size, -size / (viewport.size.width / viewport.size.height), size / (viewport.size.width / viewport.size.height), zNear, zFar); 
    
    glViewport(0, 0, viewport.size.width, viewport.size.height);  
    
    glMatrixMode(GL_MODELVIEW);
        
    glLoadIdentity();
                
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30.0)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    [self.splash.opacity setValue:0 forTime:2 andThen:nil];
        
    if(!self.gameController) { [self.menuLayerController showMenus]; }
}

-(void)draw
{
    static BOOL hasRendered = NO;
    
    TRANSACTION_BEGIN
    {
        //TODO: move this calculation to the Camera Controller class so it can be animated
        GLfloat cameraPitch = self.camera.pitchAngle.value * self.camera.pitchFactor.value * (1.0 - self.currentPlayer.cardGroup.angleFlip / 180.0);
        
        glClear(GL_COLOR_BUFFER_BIT);
        
        glRotatef(self.camera.rollAngle.value, 0.0f, 0.0f, 1.0f);   
        
        gluLookAt(self.camera.position.value.x, self.camera.position.value.y, self.camera.position.value.z, self.camera.lookAt.value.x, self.camera.lookAt.value.y, self.camera.lookAt.value.z, 0.0, 1.0, 0.0);
        
        glRotatef(cameraPitch + 90, 1.0f, 0.0f, 0.0f);            
                        
        glTranslatef(0, 0, 3.0 * cameraPitch / 90.0);

        self.table.drawStatus = GLTableDrawStatusDiffuse; [self.table draw];                                            
        
        TRANSACTION_BEGIN
        {
            glTranslatef(self.currentOffset.value, 0, 0);

            self.currentPlayer.cardGroup.bendFactor = cameraPitch / 90.0;
            
            [self.currentPlayer.cardGroup makeControlPoints];
            [self.currentPlayer.cardGroup drawShadows];
            [self.currentPlayer.chipGroup drawShadows];
        }
        TRANSACTION_END
        
        self.table.drawStatus = GLTableDrawStatusAmbient; [self.table draw];                                              
    
        TRANSACTION_BEGIN
        {
            glTranslatef(self.currentOffset.value, 0, 0);
            
            { GLTextController* textController = [self.currentPlayer.textControllers objectForKey:@"credits"];     [textController draw]; }
            { GLTextController* textController = [self.currentPlayer.textControllers objectForKey:@"actions"];     [textController draw]; }
            { GLTextController* textController = [self.currentPlayer.textControllers objectForKey:@"gameOver"];    [textController draw]; }
            { GLTextController* textController = [self.currentPlayer.textControllers objectForKey:@"messageDown"]; [textController draw]; }
            
            self.currentPlayer.chipGroup.opacity = 1.0; //clipFloat(-0.04 * cameraPitch + 3.4, 0, 1);

            self.currentPlayer.flatCardGroup.bendFactor = cameraPitch / 90.0;
            [self.currentPlayer.flatCardGroup draw];
            
            [self.currentPlayer.chipGroup drawMarkers];
            [self.currentPlayer.chipGroup drawChips];
            
            [self.currentPlayer.cardGroup drawBacks]; 
            
            if(cameraPitch > 45 || self.currentPlayer.cardGroup.angleFlip > 1) { [self.currentPlayer.cardGroup drawFronts]; }
            
            [self.currentPlayer.cardGroup drawLabels];
            
            { GLTextController* textController = [self.currentPlayer.textControllers objectForKey:@"messageUp"]; [textController.opacity setValue:cameraPitch / 45.0 - 1.0]; [textController draw]; }
        }
        TRANSACTION_END
                
        [self.menuLayerController draw];
        
    }
    TRANSACTION_END;
    
    [self.splash draw];
       
    hasRendered = YES;

    [self.glView presentRenderbuffer];
    
    for(NSValue* key in self.touchedLocations.allKeys) 
    {
        UITouch* touch = [key pointerValue];
        
        id<Touchable> object = [self.touchedObjects objectForKey:key];

        NSValue* location = [self.touchedLocations objectForKey:key];
        
        CGPoint pointFrom = [location CGPointValue];
        CGPoint pointTo   = [touch locationInView:touch.view];

        if(object)
        {
            [object handleTouchMoved:touch fromPoint:pointFrom toPoint:pointTo];
        }
        else
        {
            [self handleEmptyTouchMoved:touch fromPoint:pointFrom toPoint:pointTo];
        }
    }   
}

-(void)labelTouchedWithKey:(NSString*)key
{
    [self.appController  labelTouchedWithKey:key];
    [self.gameController labelTouchedWithKey:key];
}

-(void)updatePlayersWithKeys:(NSArray*)keys andThen:(SimpleBlock)work
{
    NSMutableDictionary* newDictionary = [NSMutableDictionary dictionary];
    
    for(NSString* key in keys)
    {
        GLPlayer* player = [GLPlayer player];
        
        player.renderer = self;
    
        if(!self.currentPlayer && [key isEqualToString:self.appController.mainPlayerKey])
        {
            self.currentPlayer = player;
        }
        
        [newDictionary setObject:player forKey:key];
    }
        
    [self.players setLiveKeys:keys liveDictionary:newDictionary andThen:work];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{        
    static BOOL isUpright = NO;
    
    if(acceleration.x > -0.4 && acceleration.x <  0.4 && acceleration.y > -1.4 && acceleration.y < -0.6)
    {
        if(!isUpright)
        {
            isUpright = YES;
                        
            [self.menuLayerController showMenus];
        }
    }
    else if(acceleration.x > -0.6 && acceleration.x < 0.6 && acceleration.y > -1.6 && acceleration.y < -0.4)
    {
        // DO NOTHING
    }
    else
    {
        if(isUpright)
        {
            isUpright = NO;
                        
            if(self.gameController) { [self.menuLayerController hideMenus]; }
        }
        
        if(self.camera.isAutomatic)
        {
            GLfloat rawAngle = atan2f(-acceleration.x, -acceleration.z);
            GLfloat angle;
            
            GLfloat clampLow  = 0.5 / 8.0 * M_PI; 
            GLfloat clampHigh = 2.5 / 8.0 * M_PI;
            
            if(rawAngle < clampLow)
            {
                angle = 0;
            }
            else if(rawAngle > clampHigh)
            {
                angle = 90;
            }
            else
            {
                angle = (rawAngle - clampLow) / (clampHigh - clampLow) * 90.0;
            }
            
            self.camera.pitchAngle = [AnimatedFloat floatWithValue:angle * 0.10 + self.camera.pitchAngle.value * 0.90];
        }
    }
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{   
    TRANSACTION_BEGIN
    {
        GLPlayer* player = (GLPlayer*)[self.players liveObjectForKey:self.appController.mainPlayerKey];
        
        glRotatef(self.camera.rollAngle.value, 0.0f, 0.0f, 1.0f);   
        
        gluLookAt(self.camera.position.value.x, self.camera.position.value.y, self.camera.position.value.z, 
                  self.camera.lookAt.value.x,   self.camera.lookAt.value.y,   self.camera.lookAt.value.z, 
                  0.0,                          1.0,                          0.0);
        
        glTranslatef(self.currentOffset.value, 0, 0);
        
        GLfloat angle = self.camera.pitchAngle.value * self.camera.pitchFactor.value;
        
        glRotatef(90,    1, 0, 0);  
        glRotatef(angle, 1, 0, 0);         
        
        for(UITouch* touch in touches) 
        {
            id<Touchable> object = nil;
            
            if(angle < 60)
            {
                for(GLTextController* textController in player.textControllers.objectEnumerator) 
                { 
                    object = [textController testTouch:touch withPreviousObject:object]; 
                }

                for(GLChip* chip in player.chipGroup.chips.liveObjects) 
                { 
                    object = [chip testTouch:touch withPreviousObject:object]; 
                }

                for(GLCard* card in player.cardGroup.cards.liveObjects) 
                {
                    object = [card testTouch:touch withPreviousObject:object];
                }
                
                object = [self.menuLayerController testTouch:touch withPreviousObject:object]; 
            }
            else
            {
                for(GLCard* card in player.cardGroup.cards.liveObjects.reverseObjectEnumerator) 
                {                 
                    object = [card testTouch:touch withPreviousObject:object];
                }
            }
            
            NSValue* key = [NSValue valueWithPointer:touch];
            [self.touchedLocations setObject:[NSValue valueWithCGPoint:[touch locationInView:touch.view]] forKey:[NSValue valueWithPointer:touch]];
            
            if(object)
            {            
                [object handleTouchDown:touch fromPoint:[touch locationInView:touch.view]];
                
                [self.touchedObjects setObject:object forKey:key];
            }
            else
            {    
                [self handleEmptyTouchDown:touch fromPoint:[touch locationInView:touch.view]];
            }
        }
    }
    TRANSACTION_END
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{           
    for(UITouch* touch in touches) 
    {
        NSValue* key = [NSValue valueWithPointer:touch];
        
        NSValue* location = [self.touchedLocations objectForKey:key];
        
        id<Touchable> object = [self.touchedObjects objectForKey:key];
        
        CGPoint pointFrom = [location CGPointValue];
        CGPoint pointTo   = [touch locationInView:touch.view];

        [self.touchedLocations removeObjectForKey:key];        

        if(object)
        {
            [object handleTouchUp:touch fromPoint:pointFrom toPoint:pointTo];
            
            [self.touchedObjects removeObjectForKey:key];
        }
        else
        {
            [self handleEmptyTouchUp:touch fromPoint:pointFrom toPoint:pointTo];
        }
    }
}

-(void)handleEmptyTouchDown:(UITouch*)touch fromPoint:(CGPoint)point
{    
    self.initialOffset = self.currentOffset.value;
    
    for(GLPlayer* player in self.players.liveObjects)
    {
        if(player == self.currentPlayer)
        {
            player.offset = self.currentPlayer.offset;
        }
        else if(player == [self.players.liveObjects objectBefore:self.currentPlayer])
        {
            player.offset = self.currentPlayer.offset + 30;
        }
        else if(player == [self.players.liveObjects objectAfter:self.currentPlayer])
        {
            player.offset = self.currentPlayer.offset - 30;
        }
        else
        {
            player.offset = NAN;
        }
    }
}

-(void)handleEmptyTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    [self.currentOffset setValue:(pointTo.y - pointFrom.y) / -30.0 + self.initialOffset];
}

-(void)handleEmptyTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{    
    if(pointTo.y - pointFrom.y > 20.0)
    {
        self.currentPlayer = [self.players.liveObjects objectBefore:self.currentPlayer];
    }
    else if(pointTo.y - pointFrom.y < -20.0)
    {
        self.currentPlayer = [self.players.liveObjects objectAfter:self.currentPlayer];
    }
    else
    {
        [self emptySpaceTouched];
    }
    
    LOG_NS(@"Renderer Offset %f -> %f", self.currentOffset.value, self.currentPlayer.offset);

    [self.currentOffset setValue:self.currentPlayer.offset withSpeed:30];
}

-(void)emptySpaceTouched 
{
    if(!self.camera.isAutomatic)
    {
        if(self.camera.pitchAngle.value > 60)
        {
            [self.camera.pitchAngle setValue:0 forTime:1.0 andThen:nil];
        }
        else 
        {
            if(self.camera.menuVisible) 
            {
                [self.menuLayerController hideMenus];
            }
            else 
            {
                [self.menuLayerController showMenus];
            }
        }
    }
}

@end
