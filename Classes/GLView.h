#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GLRenderer.h"

@interface GLView : UIView

@property (nonatomic, assign)   GLRenderer* renderer;

@property (nonatomic, readonly) CAEAGLLayer* eaglLayer;
@property (nonatomic, retain)   EAGLContext* eaglContext;
@property (nonatomic, assign)   GLuint       framebuffer;
@property (nonatomic, assign)   GLuint       renderbuffer;

@property (nonatomic, readonly) CGRect viewport;

-(void)presentRenderbuffer;

@end
