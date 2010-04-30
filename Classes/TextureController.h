@interface TextureController : NSObject { }

+(void)setTexture:(Texture2D*)texture forKey:(NSString*)key;
+(BOOL)textureExistsForKey:(NSString*)key;
+(int)nameForKey:(NSString*)key;

@end
