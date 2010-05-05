@interface TextureController : NSObject { }

+(void)setTexture:(GLTexture*)texture forKey:(NSString*)key;
+(BOOL)textureExsistsForKey:(NSString*)key;
+(int)nameForKey:(NSString*)key;

@end
