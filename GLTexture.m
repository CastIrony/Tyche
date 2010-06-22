#import "Common.h"

#import "GLTexture.h"

#define kMaxTextureSize	1024

static GLTexturePixelFormat defaultAlphaPixelFormat = kGLTexturePixelFormat_Default;

@implementation GLTexture

@synthesize contentSize           = _size;
@synthesize pixelFormat           = _format; 
@synthesize pixelsWide            = _width; 
@synthesize pixelsHigh            = _height; 
@synthesize name                  = _name; 
@synthesize maxS                  = _maxS; 
@synthesize maxT                  = _maxT;
@synthesize hasPremultipliedAlpha = _hasPremultipliedAlpha;

-(id)initWithData:(const void*)data pixelFormat:(GLTexturePixelFormat)pixelFormat pixelsWide:(NSUInteger)width pixelsHigh:(NSUInteger)height contentSize:(CGSize)size
{
	GLint saveName;
	
    self = [super init];
    
    if(self) 
    {
        glActiveTexture(GL_TEXTURE0);
        
		glGenTextures(1, &_name);
		glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
		glBindTexture(GL_TEXTURE_2D, _name);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S,     GL_CLAMP_TO_EDGE );
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T,     GL_CLAMP_TO_EDGE );
		
		// Specify OpenGL texture image
		
        if(pixelFormat == kGLTexturePixelFormat_RGBA8888) { glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  width, height, 0, GL_RGBA,  GL_UNSIGNED_BYTE, data); } 
        if(pixelFormat == kGLTexturePixelFormat_A8)       { glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, width, height, 0, GL_ALPHA, GL_UNSIGNED_BYTE, data); } 
        		
		glBindTexture(GL_TEXTURE_2D, saveName);

        glActiveTexture(GL_TEXTURE1);
        
        glGenTextures(1, &_name);
		glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
		glBindTexture(GL_TEXTURE_2D, _name);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S,     GL_CLAMP_TO_EDGE );
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T,     GL_CLAMP_TO_EDGE );
		
		// Specify OpenGL texture image
		
        if(pixelFormat == kGLTexturePixelFormat_RGBA8888) { glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  width, height, 0, GL_RGBA,  GL_UNSIGNED_BYTE, data); } 
        if(pixelFormat == kGLTexturePixelFormat_A8)       { glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, width, height, 0, GL_ALPHA, GL_UNSIGNED_BYTE, data); } 
        
		glBindTexture(GL_TEXTURE_2D, saveName);
        
        glActiveTexture(GL_TEXTURE0);
        
		_size   = size;
		_width  = width;
		_height = height;
		_format = pixelFormat;
		_maxS   = size.width  / (float)width;
		_maxT   = size.height / (float)height;

		_hasPremultipliedAlpha = NO;
	}
    
	return self;
}

-(void)dealloc
{
	if(_name) { glDeleteTextures(1, &_name); }
	
	[super dealloc];
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"<%@ = %08X | Name = %i | Dimensions = %ix%i | Coordinates = (%.2f, %.2f)>", [self class], self, _name, _width, _height, _maxS, _maxT];
}

@end

@implementation GLTexture (Image)

-(id)initWithImageFile:(NSString*)path
{
    if(!path.isAbsolutePath) { path = [[NSBundle mainBundle] pathForResource:path ofType:nil]; }
    
    UIImage* uiImage = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
	
    self = [self initWithImage:uiImage];
			
	return self;
}

-(id)initWithImage:(UIImage *)uiImage
{
	NSUInteger				width;
	NSUInteger				height;
	//NSUInteger				i;
	CGContextRef			context = nil;
	void*					data = nil;;
	CGColorSpaceRef			colorSpace;
	CGImageAlphaInfo		info;
	CGAffineTransform		transform;
	CGSize					imageSize;
	GLTexturePixelFormat    pixelFormat;
	CGImageRef				image;
	//BOOL					sizeToFit = NO;
		
	image = [uiImage CGImage];
	
	if(image == NULL) 
    {
		[self release];
		NSLog(@"Image is Null");
		return nil;
	}
	
	info = CGImageGetAlphaInfo(image);
	
	if(CGImageGetColorSpace(image)) 
    {
        pixelFormat = defaultAlphaPixelFormat;
	} 
    else  //NOTE: No colorspace means a mask image
	{
        pixelFormat = kGLTexturePixelFormat_A8;
	}
    
	imageSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
	transform = CGAffineTransformIdentity;

	width  = roundPowerTwo(imageSize.width);
	height = roundPowerTwo(imageSize.height);

    if(pixelFormat == kGLTexturePixelFormat_RGBA8888)
    {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        data = malloc(height * width * 4);
        context = CGBitmapContextCreate(data, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
    }
    
    if(pixelFormat == kGLTexturePixelFormat_A8)
    {
        data = malloc(height * width);
        context = CGBitmapContextCreate(data, width, height, 8, width, NULL, kCGImageAlphaOnly);
    }

	CGContextClearRect(context, CGRectMake(0, 0, width, height));
	
	if(!CGAffineTransformIsIdentity(transform)) { CGContextConcatCTM(context, transform); }
    
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);

	self = [self initWithData:data pixelFormat:pixelFormat pixelsWide:width pixelsHigh:height contentSize:CGSizeMake(width, height)];

	// should be after calling super init
	_hasPremultipliedAlpha = (info == kCGImageAlphaPremultipliedLast || info == kCGImageAlphaPremultipliedFirst);
	
	CGContextRelease(context);
	free(data);
	
	return self;
}

@end

@implementation GLTexture (Text)

-(id)initWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(UITextAlignment)alignment font:(UIFont*)font
{
	NSUInteger		width;
	NSUInteger		height;
	//NSUInteger		i;
	CGContextRef	context;
	void*			data;
	CGColorSpaceRef	colorSpace;
	    
    width  = roundPowerTwo(dimensions.width);
	height = roundPowerTwo(dimensions.height);

	colorSpace = CGColorSpaceCreateDeviceGray();
	data = calloc(height, width);
	context = CGBitmapContextCreate(data, width, height, 8, width, colorSpace, kCGImageAlphaNone);
	
    CGColorSpaceRelease(colorSpace);
	CGContextSetGrayFillColor(context, 1.0f, 1.0f);
	CGContextTranslateCTM(context, 0.0f, height);
    CGContextScaleCTM(context, width / (dimensions.width + 2.0), height / (dimensions.height + 2.0));
    CGContextScaleCTM(context, 1.0f, -1.0f); //NOTE: NSString draws in UIKit referential i.e. renders upside-down compared to CGBitmapContext referential
	CGContextTranslateCTM(context, 1.0, 1.0);
    
    UIGraphicsPushContext(context);
		
    [string drawInRect:CGRectMake(0, 0, dimensions.width, dimensions.height) withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
	
    UIGraphicsPopContext();
	
	self = [self initWithData:data pixelFormat:kGLTexturePixelFormat_A8 pixelsWide:width pixelsHigh:height contentSize:dimensions];
	
	CGContextRelease(context);
	free(data);
	
	return self;
}

@end

@implementation GLTexture (Button)

- (id)initWithButtonOpacity:(GLfloat)opacity
{
	NSUInteger				width;
    NSUInteger              height;
    CGContextRef			context;
	void*					data;
	CGColorSpaceRef			colorSpace;
	    
	width = 32;
	height = 32;
	
	colorSpace = CGColorSpaceCreateDeviceGray();
	data = calloc(height, width);
	context = CGBitmapContextCreate(data, width, height, 8, width, colorSpace, kCGImageAlphaNone);
	CGColorSpaceRelease(colorSpace);
	
    UIGraphicsPushContext(context);
        
    CGContextSetLineWidth(context, 4.0);
	
    CGContextSetGrayFillColor(context, 1.0f, opacity);
    CGContextAddEllipseInRect(context, CGRectMake(3, 3, 26, 26));
    CGContextFillPath(context);
    
    CGContextSetGrayStrokeColor(context, 1.0f, 1.0f);
    CGContextAddEllipseInRect(context, CGRectMake(3, 3, 26, 26));
    CGContextStrokePath(context);
        
    UIGraphicsPopContext();
	
	self = [self initWithData:data pixelFormat:kGLTexturePixelFormat_A8 pixelsWide:width pixelsHigh:height contentSize:CGSizeMake(width/2, height/2)];
	
	CGContextRelease(context);
	free(data);
	
	return self;
}

@end

@implementation GLTexture (Dots)

-(id)initWithDots:(int)dots current:(int)current
{    
    dots = 10;
    current = 4;
    
    int spacing = 16;
    int radius =  4;
    int perRow = 8;
    
    int width = spacing * 2 * (dots > perRow ? perRow : dots);
    int height = spacing * 2 * ((dots - 1) / perRow + 1);
    
	int textureWidth  = roundPowerTwo(width);
	int textureHeight = roundPowerTwo(height);
	
    NSLog(@"%d, %d, %d, %d, %d, %d", spacing, dots, width, textureWidth, height, textureHeight);
    
    void* data = calloc(textureHeight, textureWidth);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
    CGContextRef context = CGBitmapContextCreate(data, textureWidth, textureHeight, 8, textureWidth, colorSpace, kCGImageAlphaNone);
	
    CGColorSpaceRelease(colorSpace);
	
    CGContextScaleCTM(context, textureWidth / (width + 2.0), textureHeight / (height + 2.0));
    CGContextTranslateCTM(context, 1.0, 1.0);
    
    UIGraphicsPushContext(context);
    {
        //  xx    xx    xx    xx    xx
        //  xx    xx    xx    xx    xx
        //  xx    xx    xx    xx    xx
        //           **    xx
        
        CGContextSetLineWidth(context, 4.0);
        
        for(int i = 0; i < (dots / perRow); i++)
        {
            for(int j = 0; j < perRow; j++)
            {
                int dot = i * perRow + j;
                
                CGContextSetGrayFillColor(context, 1.0, dot == current ? 1.0 : 0.2);
                
                GLfloat x = 2 * spacing * j;
                GLfloat y = 2 * spacing * i;
                
                CGRect position = CGRectMake(x + spacing - radius, y + spacing - radius, x + spacing + radius, y + spacing + radius);
                
                CGContextAddEllipseInRect(context, position);
                
                CGContextFillPath(context);
            }
        }
        
        int bottomDots = dots % perRow;
        
        GLfloat offset = -1.0 * spacing * bottomDots;
        
        for(int i = 0; i < bottomDots; i++)
        {
            int dot = (dots / perRow * perRow) + j;
            
            CGContextSetGrayFillColor(context, 1.0, dot == current ? 1.0 : 0.2);
            
            GLfloat x = offset + i * spacing * 2;
            GLfloat y = (dots / perRow) + 1;
            
            CGRect position = CGRectMake(x + spacing - radius, y + spacing - radius, x + spacing + radius, y + spacing + radius);
            
            CGContextAddEllipseInRect(context, position);

            CGContextFillPath(context);
        }
    }
    UIGraphicsPopContext();
	
	self = [self initWithData:data pixelFormat:kGLTexturePixelFormat_A8 pixelsWide:textureWidth pixelsHigh:textureHeight contentSize:CGSizeMake(textureWidth, textureHeight)];
	
	CGContextRelease(context);
	free(data);
	
	return self;
}

@end

@implementation GLTexture (PVRTC)

-(id)initWithPVRTCFile:(NSString*)file
{
    if(!file.isAbsolutePath) { file = [[NSBundle mainBundle] pathForResource:file ofType:nil]; }

    NSData* data = [[[NSData alloc] initWithContentsOfFile:file] autorelease];
    
    if((self = [super init])) 
    {
        GLint saveName;
    
        glActiveTexture(GL_TEXTURE1);
        
        glGenTextures(1, &_name);
		glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
		glBindTexture(GL_TEXTURE_2D, _name);
	  	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S,     GL_CLAMP_TO_EDGE );
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T,     GL_CLAMP_TO_EDGE );
//        
        glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG, 1024, 1024, 0, (1024 * 1024) / 2, data.bytes);

        glBindTexture(GL_TEXTURE_2D, saveName);
        
        glActiveTexture(GL_TEXTURE0);
        
        glGenTextures(1, &_name);
		glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
		glBindTexture(GL_TEXTURE_2D, _name);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S,     GL_CLAMP_TO_EDGE );
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T,     GL_CLAMP_TO_EDGE );
//        
        glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG, 1024, 1024, 0, (1024 * 1024) / 2, data.bytes);
        
        glBindTexture(GL_TEXTURE_2D, saveName);
    }
    
    return self;
}

@end

@implementation GLTexture (PixelFormat)

+(void)setDefaultAlphaPixelFormat:(GLTexturePixelFormat)format
{
	defaultAlphaPixelFormat = format;
}

+(GLTexturePixelFormat) defaultAlphaPixelFormat
{
	return defaultAlphaPixelFormat;
}

@end