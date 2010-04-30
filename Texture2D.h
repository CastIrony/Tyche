typedef enum 
{
	kTexture2DPixelFormat_Automatic = 0,
	kTexture2DPixelFormat_RGBA8888,
	kTexture2DPixelFormat_RGB565,
	kTexture2DPixelFormat_A8,
	kTexture2DPixelFormat_L8,
	kTexture2DPixelFormat_RGBA4444,
	kTexture2DPixelFormat_RGB5A1,
} Texture2DPixelFormat;

#define kTexture2DPixelFormat_Default kTexture2DPixelFormat_RGBA8888

@interface Texture2D : NSObject
{
	GLuint						_name;
	CGSize						_size;
	NSUInteger					_width,
								_height;
	Texture2DPixelFormat		_format;
	GLfloat						_maxS,
								_maxT;
	BOOL						_hasPremultipliedAlpha;
}

- (id) initWithData:(const void*)data pixelFormat:(Texture2DPixelFormat)pixelFormat pixelsWide:(NSUInteger)width pixelsHigh:(NSUInteger)height contentSize:(CGSize)size;

@property(assign, nonatomic) Texture2DPixelFormat pixelFormat;
@property(assign, nonatomic) NSUInteger pixelsWide;
@property(assign, nonatomic) NSUInteger pixelsHigh;
@property(assign, nonatomic) GLuint name;
@property(assign, nonatomic) CGSize contentSize;
@property(assign, nonatomic) GLfloat maxS;
@property(assign, nonatomic) GLfloat maxT;
@property(assign, nonatomic) BOOL hasPremultipliedAlpha;

@end

@interface Texture2D (Drawing)

- (void) drawAtPoint:(CGPoint)point;
- (void) drawInRect:(CGRect)rect;

@end

@interface Texture2D (Image)

- (id) initWithImageFile:(NSString*)path;
- (id) initWithImage:(UIImage *)uiImage;

@end

@interface Texture2D (Text)

- (id) initWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(UITextAlignment)alignment font:(UIFont*)font;

@end

@interface Texture2D (Button)

- (id)initWithButtonOpacity:(GLfloat)opacity;

@end

@interface Texture2D (Dots)

-(id)initWithDots:(int)dots current:(int)current;

@end

@interface Texture2D (PVRTC)

-(id) initWithPVRTCFile: (NSString*) file;

@end

typedef struct _ccTexParams 
{
	GLuint	minFilter;
	GLuint	magFilter;
	GLuint	wrapS;
	GLuint	wrapT;
} ccTexParams;

@interface Texture2D (GLFilter)

-(void) setTexParameters: (ccTexParams*) texParams;

-(void) setAntiAliasTexParameters;

-(void) setAliasTexParameters;

@end

@interface Texture2D (PixelFormat)

+(void) setDefaultAlphaPixelFormat:(Texture2DPixelFormat)format;

+(Texture2DPixelFormat) defaultAlphaPixelFormat;

@end