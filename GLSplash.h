@class GameRenderer;

@interface GLSplash : NSObject 
{
    GameRenderer* _renderer;
    AnimatedFloat* _opacity;
}

@property (nonatomic, assign) GameRenderer* renderer;
@property (nonatomic, retain) AnimatedFloat* opacity;

-(void)draw;

@end
