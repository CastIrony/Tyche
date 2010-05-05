@interface TextureController : NSObject { }

+(void)setTexture:(GLTexture*)texture forKey:(NSString*)key;
+(BOOL)textureExistsForKey:(NSString*)key
+(int)nameForKey:(NSString*)key;

@end
