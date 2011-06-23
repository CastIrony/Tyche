typedef enum 
{
	kGLTexturePixelFormat_RGBA8888,
	kGLTexturePixelFormat_A8,
	kGLTexturePixelFormat_L8
} GLTexturePixelFormat;

@interface GLTexture : NSObject

@property(nonatomic, assign) GLTexturePixelFormat pixelFormat;
@property(nonatomic, assign) GLuint name;
@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, assign) CGSize contentSize;
@property(nonatomic, assign) BOOL hasPremultipliedAlpha;

-(id)initWithData:(const void*)data pixelFormat:(GLTexturePixelFormat)pixelFormat imageSize:(CGSize)imageSize contentSize:(CGSize)contentSize;

@end

@interface GLTexture (Image)

-(id)initWithImageFile:(NSString*)path;
-(id)initWithImage:(UIImage*)uiImage;

@end

@interface GLTexture (Text)

-(id)initWithString:(NSString*)string font:(UIFont*)font;

@end

@interface GLTexture (Button)

-(id)initWithButtonOpacity:(GLfloat)opacity;

@end

@interface GLTexture (Dots)

-(id)initWithDots:(int)dots current:(int)current;

@end

@interface GLTexture (PVRTC)

-(id)initWithPVRTCFile:(NSString*) file;

@end