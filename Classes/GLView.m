//
//  EAGLView.m
//  Studly
//
//  Created by Joel Bernstein on 9/24/09.
//  Copyright Joel Bernstein 2009. All rights reserved.
//

#import "GLView.h"
#import "GameController.h"
#import "AppController.h"
#import "GLRenderer.h"
#import "GLSplash.h"
#import "AnimatedFloat.h"
@implementation GLView

+(Class)layerClass { return [CAEAGLLayer class]; }

@synthesize renderer     = _renderer;
@synthesize eaglContext  = _eaglContext;
@synthesize framebuffer  = _framebuffer;
@synthesize renderbuffer = _renderbuffer;

@dynamic eaglLayer;
@dynamic viewport;

-(CAEAGLLayer*)eaglLayer { return (CAEAGLLayer*)self.layer; }

-(CGRect)viewport { return CGRectMake(0, 0, self.bounds.size.width * self.contentScaleFactor, self.bounds.size.height * self.contentScaleFactor);  }

-(id)initWithFrame:(CGRect)aRect
{    
    self = [super initWithFrame:aRect];
    
    if(self)
	{
        self.eaglContext = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1] autorelease];
        
        if(!self.eaglContext || ![EAGLContext setCurrentContext:self.eaglContext]) 
        { 
            [self release]; 
            return nil;
        }
		
		glGenFramebuffersOES (1, &_framebuffer);
		glGenRenderbuffersOES(1, &_renderbuffer);
        
		glBindFramebufferOES (GL_FRAMEBUFFER_OES, self.framebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.renderbuffer);

		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, self.renderbuffer);
        
        self.eaglLayer.opaque = TRUE;
        self.eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, nil]; 
                		                
        if(UIScreen.mainScreen.currentMode.size.width == 640) 
        { 
            self.contentScaleFactor = 2.0; 
        }
    }
	
    return self;
}

-(BOOL)resize
{	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.renderbuffer);
    
    [self.eaglContext renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:self.eaglLayer];
    
    return glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) == GL_FRAMEBUFFER_COMPLETE_OES;
}

-(void)presentRenderbuffer
{
    [self.eaglContext presentRenderbuffer:GL_RENDERBUFFER_OES];
}

-(void)layoutSubviews
{    
    [self resize];
    [self.renderer draw];
}

-(void)dealloc
{
	if(self.framebuffer)
	{
		glDeleteFramebuffersOES(1, &_framebuffer);
		self.framebuffer = 0;
	}
    
	if(self.renderbuffer)
	{
		glDeleteRenderbuffersOES(1, &_renderbuffer);
		self.renderbuffer = 0;
	}
	
	if([EAGLContext currentContext] == self.eaglContext) { [EAGLContext setCurrentContext:nil]; }
	
	self.eaglContext = nil;
	
	[super dealloc];
}


@end
