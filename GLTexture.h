typedef enum 
{
	kGLTexturePixelFormat_Automatic = 0,
	kGLTexturePixelFormat_RGBA8888,
	kGLTexturePixelFormat_A8,
	kGLTexturePixelFormat_L8
} GLTexturePixelFormat;

#define kGLTexturePixelFormat_Default kGLTexturePixelFormat_RGBA8888

@interface GLTexture : NSObject
{
//	GLuint						_name;
//	CGSize						_size;
//	NSUInteger					_width,
//								_height;
//	GLTexturePixelFormat		_format;
//	GLfloat						_maxS,
//								_maxT;
//	BOOL						_hasPremultipliedAlpha;
}

- (id) initWithData:(const void*)data pixelFormat:(GLTexturePixelFormat)pixelFormat pixelsWide:(NSUInteger)width pixelsHigh:(NSUInteger)height contentSize:(CGSize)size;

@property(assign, nonatomic) GLTexturePixelFormat pixelFormat;
@property(assign, nonatomic) NSUInteger pixelsWide;
@property(assign, nonatomic) NSUInteger pixelsHigh;
@property(assign, nonatomic) GLuint name;
@property(assign, nonatomic) CGSize contentSize;
@property(assign, nonatomic) GLfloat maxS;
@property(assign, nonatomic) GLfloat maxT;
@property(assign, nonatomic) BOOL hasPremultipliedAlpha;

@end

@interface GLTexture (Drawing)

- (void) drawAtPoint:(CGPoint)point;
- (void) drawInRect:(CGRect)rect;

@end

@interface GLTexture (Image)

- (id) initWithImageFile:(NSString*)path;
- (id) initWithImage:(UIImage *)uiImage;

@end

@interface GLTexture (Text)

- (id) initWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(UITextAlignment)alignment font:(UIFont*)font;

@end

@interface GLTexture (Button)

- (id)initWithButtonOpacity:(GLfloat)opacity;

@end

@interface GLTexture (Dots)

-(id)initWithDots:(int)dots current:(int)current;

@end

@interface GLTexture (PVRTC)

-(id) initWithPVRTCFile: (NSString*) file;

@end

typedef struct _ccTexParams 
{
	GLuint	minFilter;
	GLuint	magFilter;
	GLuint	wrapS;
	GLuint	wrapT;
} ccTexParams;

@interface GLTexture (GLFilter)

-(void) setTexParameters: (ccTexParams*) texParams;

-(void) setAntiAliasTexParameters;

-(void) setAliasTexParameters;

@end

@interface GLTexture (PixelFormat)

+(void) setDefaultAlphaPixelFormat:(GLTexturePixelFormat)format;

+(GLTexturePixelFormat) defaultAlphaPixelFormat;

@end