@class GLRenderer;

@interface GLSplash : NSObject

@property (nonatomic, assign) GLRenderer* renderer;
@property (nonatomic, retain) AnimatedFloat* opacity;

-(void)draw;

@end
