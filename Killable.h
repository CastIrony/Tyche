@class DisplayContainer;

@protocol Killable

@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) BOOL isAlive;

-(void)killWithDisplayContainer:(DisplayContainer*)container key:(id)key andThen:(simpleBlock)work;

@end
