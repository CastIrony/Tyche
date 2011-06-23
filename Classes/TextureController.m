#import "GLTexture.h"

#import "TextureController.h"

static NSMutableDictionary* textures;

@implementation TextureController

+(void)initialize
{
    if(!textures) { textures = [[NSMutableDictionary alloc] init]; }
}

+(void)setTexture:(GLTexture*)texture forKey:(NSString*)key
{
    [textures setObject:texture forKey:key];
}

+(BOOL)textureExistsForKey:(NSString*)key
{
    return [textures objectForKey:key] != nil;
}

+(int)nameForKey:(NSString*)key
{
    GLTexture* texture = [textures objectForKey:key];
        
    return texture.name;
}

+(void)addTextureWithFileName:(NSString*)fileName forKey:(NSString*)key tiled:(BOOL)tiled
{
//    if([fileName hasSuffix:@"pvr4"])
//    {
//        if(!file.isAbsolutePath) { file = [[NSBundle mainBundle] pathForResource:file ofType:nil]; }
//        
//        NSData* data = [[[NSData alloc] initWithContentsOfFile:file] autorelease];
//        
//        if((self = [super init])) 
//        {
//            GLint saveName;
//            
//            glGenTextures(1, &_name);
//            glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
//            glBindTexture(GL_TEXTURE_2D, _name);
//            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//            
//            glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG, 1024, 1024, 0, (1024 * 1024) / 2, data.bytes);
//            
//            glBindTexture(GL_TEXTURE_2D, saveName);
//        }
//        
//        return self;
//    }
//    else 
//    {
//        if(!path.isAbsolutePath) { path = [[NSBundle mainBundle] pathForResource:path ofType:nil]; }
//        
//        UIImage* uiImage = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
//    }
}

//[TextureController setTexture:[[[GLTexture alloc] initWithImageFile:@"chips3.png"   ] autorelease] forKey:@"chips"];
//[TextureController setTexture:[[[GLTexture alloc] initWithPVRTCFile:@"felt3.pvr4"   ] autorelease] forKey:@"table"];
//[TextureController setTexture:[[[GLTexture alloc] initWithImageFile:@"Default.png"  ] autorelease] forKey:@"splash"];
//[TextureController setTexture:[[[GLTexture alloc] initWithPVRTCFile:@"hearts.pvr4"  ] autorelease] forKey:@"suit0"];
//[TextureController setTexture:[[[GLTexture alloc] initWithPVRTCFile:@"diamonds.pvr4"] autorelease] forKey:@"suit1"];
//[TextureController setTexture:[[[GLTexture alloc] initWithPVRTCFile:@"clubs.pvr4"   ] autorelease] forKey:@"suit2"];
//[TextureController setTexture:[[[GLTexture alloc] initWithPVRTCFile:@"spades.pvr4"  ] autorelease] forKey:@"suit3"];

@end
