@class GameRenderer;

@interface GLSplash : NSObject 
{
}

@property (nonatomic, assign) GameRenderer* renderer;
@property (nonatomic, retain) AnimatedFloat* opacity;

-(void)draw;

@end
