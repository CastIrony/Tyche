@class DisplayContainer

@protocol Killable

@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) BOOL isAlive;

-(void)killWithDisplayContainer:(DisplayContainer*)container andKey:(id)key;

@end
