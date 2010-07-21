#import "Constants.h"
#import "Geometry.h"
#import "Bezier.h"
#import "GLTexture.h"
#import "Projection.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "AppController.h"
#import "GameController.h"
#import "TextController.h"
#import "TextureController.h"
#import "GameRenderer.h"
#import "DisplayContainer.h"

#import "GLLabel.h"

@implementation GLLabel

@synthesize textController       = _textController;

@synthesize labelStatus          = _labelStatus;

@synthesize textureText          = _textureText;
@synthesize textureBulletLeft    = _textureBulletLeft;
@synthesize textureBulletRight   = _textureBulletRight;

@synthesize key                  = _key;

@synthesize lightness            = _lightness;

@synthesize layoutLocation       = _layoutLocation;
@synthesize layoutOpacity        = _layoutOpacity;
@synthesize death                = _death;

@synthesize textString           = _textString;
@synthesize bulletLeftString     = _bulletLeftString;
@synthesize bulletRightString    = _bulletRightString;
@synthesize font                 = _font;
@synthesize labelSize            = _labelSize;
@synthesize fadeMargin           = _fadeMargin;
@synthesize colorNormal          = _colorNormal;
@synthesize colorTouched         = _colorTouched;
@synthesize textAlignment        = _textAlignment;

@synthesize isLabelTouched       = _isLabelTouched;

@synthesize scrollBase           = _scrollBase;
@synthesize scrollAmplitude      = _scrollAmplitude;

@synthesize hasBorder            = _hasBorder;
@synthesize hasShadow            = _hasShadow;

@synthesize textSize             = _textSize;
@synthesize bulletLeftSize       = _bulletLeftSize;
@synthesize bulletRightSize      = _bulletRightSize;

@synthesize owner                = _owner;

@dynamic layoutSize;
@dynamic borderSize;

-(CGSize)layoutSize { return self.hasBorder ? CGSizeMake(self.labelSize.width + 1, self.labelSize.height + 2) : self.labelSize; }
-(CGSize)borderSize { return self.hasBorder ? CGSizeMake(self.labelSize.width + 1, self.labelSize.height + 1) : self.labelSize; }

-(BOOL)isEqual:(id)object
{
    GLLabel* label = (GLLabel*)object;
    
    if(label.key               != self.key               && ![label.key               isEqual:self.key])               { return NO; }
    if(label.textString        != self.textString        && ![label.textString        isEqual:self.textString])        { return NO; }
    if(label.font              != self.font              && ![label.font              isEqual:self.font])              { return NO; }
    if(label.bulletLeftString  != self.bulletLeftString  && ![label.bulletLeftString  isEqual:self.bulletLeftString])  { return NO; }
    if(label.bulletRightString != self.bulletRightString && ![label.bulletRightString isEqual:self.bulletRightString]) { return NO; }
    
    if(label.fadeMargin         != self.fadeMargin)         { return NO; }
    if(label.textAlignment      != self.textAlignment)      { return NO; }
    if(label.hasBorder          != self.hasBorder)          { return NO; }
    if(label.hasShadow          != self.hasShadow)          { return NO; }
    if(label.labelSize.width    != self.labelSize.width)    { return NO; }
    if(label.labelSize.height   != self.labelSize.height)   { return NO; }
    if(label.colorNormal.red    != self.colorNormal.red)    { return NO; }
    if(label.colorNormal.green  != self.colorNormal.green)  { return NO; }
    if(label.colorNormal.blue   != self.colorNormal.blue)   { return NO; }
    if(label.colorNormal.alpha  != self.colorNormal.alpha)  { return NO; }
    if(label.colorTouched.red   != self.colorTouched.red)   { return NO; }
    if(label.colorTouched.green != self.colorTouched.green) { return NO; }
    if(label.colorTouched.blue  != self.colorTouched.blue)  { return NO; }
    if(label.colorTouched.alpha != self.colorTouched.alpha) { return NO; }
        
    return YES;
}

+(GLLabel*)withDictionaries:(NSArray*)dictionaries
{
    GLLabel* label = [[[GLLabel alloc] init] autorelease];
    
    NSMutableDictionary* styles = [[[NSMutableDictionary alloc] init] autorelease];
    
    for(NSDictionary* dictionary in dictionaries) 
    {     
        [styles addEntriesFromDictionary:dictionary]; 
    }
    
    [label setValuesForKeysWithDictionary:styles];
 
    [label makeMeshes];

    return label;
}

-(void)makeTextures
{
    if(!self.font) { return; }
    
    if(self.textString) 
    { 
        self.textSize = [self.textString sizeWithFont:self.font];
        
        self.textureText = [[[GLTexture alloc] initWithString:self.textString dimensions:self.textSize alignment:UITextAlignmentCenter font:self.font] autorelease];
    }
    
    if(self.bulletLeftString) 
    { 
        self.bulletLeftSize = [self.bulletLeftString  sizeWithFont:self.font];
        
        self.textureBulletLeft = [[[GLTexture alloc] initWithString:self.bulletLeftString dimensions:self.bulletLeftSize alignment:UITextAlignmentCenter font:self.font] autorelease];
    }
    
    if(self.bulletRightString) 
    { 
        self.bulletRightSize = [self.bulletRightString sizeWithFont:self.font];
        
        self.textureBulletRight = [[[GLTexture alloc] initWithString:self.bulletRightString dimensions:self.bulletRightSize alignment:UITextAlignmentCenter font:self.font] autorelease];
    }
}

-(id)init
{
    self = [super init];
    
    if(self) 
    {   
        _colorNormal   = Color3DMake(1, 1, 1, 1);
        _colorTouched  = Color3DMake(1, 1, 1, 1);
        _textAlignment = UITextAlignmentCenter;
        _hasShadow = NO;
        
        self.layoutOpacity = [AnimatedFloat withValue:0.0];
        self.death         = [AnimatedFloat withValue:0.0];
        self.fadeMargin    = 0;
        
        arrayTextVertex          = malloc( 8 * sizeof(Vector3D));
        arrayBulletRightVertex   = malloc( 4 * sizeof(Vector3D));
        arrayBulletLeftVertex    = malloc( 4 * sizeof(Vector3D));
        arrayBorderVertex        = malloc(16 * sizeof(Vector3D));
        arrayTextTextureBase     = malloc( 8 * sizeof(Vector2D));
        arrayTextTextureScrolled = malloc( 8 * sizeof(Vector2D));
        arrayBulletTexture       = malloc( 4 * sizeof(Vector2D));
        arrayBorderTexture       = malloc(16 * sizeof(Vector2D));
        arrayTextMesh            = malloc(18 * sizeof(GLushort));
        arrayBulletMesh          = malloc( 6 * sizeof(GLushort));
        arrayBorderMesh          = malloc(54 * sizeof(GLushort));
    }
    
    return self;
}

+(GLLabel*)emptyLabel
{
    GLLabel* label = [[[GLLabel alloc] init] autorelease];
    
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    label.labelSize = CGSizeMake(0, 1);
    
    return label;
}

-(void)makeMeshes
{
    if(!self.textureText) { [self makeTextures]; }
    
    GLfloat textWidth    = self.textSize.width;
    GLfloat textHeight   = self.textSize.height;
    GLfloat borderWidth  = self.borderSize.width;
    GLfloat borderHeight = self.borderSize.height;
    
    GLfloat bulletRightWidth  = self.textureBulletRight ? self.bulletRightSize.width / self.bulletRightSize.height * self.labelSize.height : 0;
    GLfloat bulletLeftWidth   = self.textureBulletLeft ? self.bulletLeftSize.width / self.bulletLeftSize.height * self.labelSize.height : 0;
    
    GLfloat labelRight  = -(self.labelSize.width  / 2.0) + bulletRightWidth;
    GLfloat labelLeft   =  (self.labelSize.width  / 2.0) - bulletLeftWidth;
    GLfloat labelTop    = -(self.labelSize.height / 2.0);
    GLfloat labelBottom =  (self.labelSize.height / 2.0);
    
    GLfloat labelWidth  = labelLeft - labelRight;
    GLfloat labelHeight = self.labelSize.height;
    
    GLfloat labelRightFade = labelRight  + self.fadeMargin;
    GLfloat labelLeftFade  = labelLeft - self.fadeMargin;
    
    GLfloat labelViewportWidth = (labelWidth) / (labelHeight * (textWidth / textHeight));
    
    self.scrollAmplitude = textWidth / textHeight > labelWidth / labelHeight ? (1.0 - labelViewportWidth + self.fadeMargin / labelWidth) / 2.0 : 0;
        
    GLfloat borderRight  = -(borderWidth  / 2.0);
    GLfloat borderLeft   =  (borderWidth  / 2.0);
    GLfloat borderTop    = -(borderHeight / 2.0);
    GLfloat borderBottom =  (borderHeight / 2.0);
    
    GLfloat borderRightMargin  = borderRight  + self.fadeMargin;
    GLfloat borderLeftMargin   = borderLeft   - self.fadeMargin;    
    GLfloat borderTopMargin    = borderTop    + self.fadeMargin;
    GLfloat borderBottomMargin = borderBottom - self.fadeMargin;
    
    arrayBorderVertex[ 0] = Vector3DMake(borderRight,       0.0, borderTop);  
    arrayBorderVertex[ 1] = Vector3DMake(borderRightMargin, 0.0, borderTop);  
    arrayBorderVertex[ 2] = Vector3DMake(borderLeftMargin,  0.0, borderTop);  
    arrayBorderVertex[ 3] = Vector3DMake(borderLeft,        0.0, borderTop);
    arrayBorderVertex[ 4] = Vector3DMake(borderRight,       0.0, borderTopMargin);  
    arrayBorderVertex[ 5] = Vector3DMake(borderRightMargin, 0.0, borderTopMargin);  
    arrayBorderVertex[ 6] = Vector3DMake(borderLeftMargin,  0.0, borderTopMargin);  
    arrayBorderVertex[ 7] = Vector3DMake(borderLeft,        0.0, borderTopMargin);  
    arrayBorderVertex[ 8] = Vector3DMake(borderRight,       0.0, borderBottomMargin);  
    arrayBorderVertex[ 9] = Vector3DMake(borderRightMargin, 0.0, borderBottomMargin);  
    arrayBorderVertex[10] = Vector3DMake(borderLeftMargin,  0.0, borderBottomMargin);  
    arrayBorderVertex[11] = Vector3DMake(borderLeft,        0.0, borderBottomMargin);  
    arrayBorderVertex[12] = Vector3DMake(borderRight,       0.0, borderBottom);  
    arrayBorderVertex[13] = Vector3DMake(borderRightMargin, 0.0, borderBottom);  
    arrayBorderVertex[14] = Vector3DMake(borderLeftMargin,  0.0, borderBottom);  
    arrayBorderVertex[15] = Vector3DMake(borderLeft,        0.0, borderBottom);  
    
    arrayBorderTexture[ 0] = Vector2DMake(0.0, 0.0);  
    arrayBorderTexture[ 1] = Vector2DMake(0.5, 0.0);  
    arrayBorderTexture[ 2] = Vector2DMake(0.5, 0.0);  
    arrayBorderTexture[ 3] = Vector2DMake(1.0, 0.0);
    arrayBorderTexture[ 4] = Vector2DMake(0.0, 0.5);
    arrayBorderTexture[ 5] = Vector2DMake(0.5, 0.5);  
    arrayBorderTexture[ 6] = Vector2DMake(0.5, 0.5);  
    arrayBorderTexture[ 7] = Vector2DMake(1.0, 0.5);  
    arrayBorderTexture[ 8] = Vector2DMake(0.0, 0.5);  
    arrayBorderTexture[ 9] = Vector2DMake(0.5, 0.5);  
    arrayBorderTexture[10] = Vector2DMake(0.5, 0.5);  
    arrayBorderTexture[11] = Vector2DMake(1.0, 0.5);  
    arrayBorderTexture[12] = Vector2DMake(0.0, 1.0);  
    arrayBorderTexture[13] = Vector2DMake(0.5, 1.0);  
    arrayBorderTexture[14] = Vector2DMake(0.5, 1.0);  
    arrayBorderTexture[15] = Vector2DMake(1.0, 1.0);  
    
    GenerateBezierMesh(arrayBorderMesh, 4, 4);
    
    if(((textWidth / textHeight) * labelHeight) < (labelWidth - 2.0 * self.fadeMargin))
    {
        if(self.textAlignment == UITextAlignmentCenter)
        {
            self.scrollBase = 0;
        }
        else if(self.textAlignment == UITextAlignmentLeft)
        {
            self.scrollBase = -(1.0 - labelViewportWidth + self.fadeMargin / labelWidth) / 2.0;        
        }
        else if(self.textAlignment == UITextAlignmentRight)
        {
            self.scrollBase =  (1.0 - labelViewportWidth + self.fadeMargin / labelWidth) / 2.0;        
        }
    }
    
    
    arrayTextVertex[0] = Vector3DMake(labelRight,      0.0, labelTop);  
    arrayTextVertex[1] = Vector3DMake(labelRightFade,  0.0, labelTop);  
    arrayTextVertex[2] = Vector3DMake(labelLeftFade,   0.0, labelTop);  
    arrayTextVertex[3] = Vector3DMake(labelLeft,       0.0, labelTop);  
    arrayTextVertex[4] = Vector3DMake(labelRight,      0.0, labelBottom);  
    arrayTextVertex[5] = Vector3DMake(labelRightFade,  0.0, labelBottom);  
    arrayTextVertex[6] = Vector3DMake(labelLeftFade,   0.0, labelBottom);  
    arrayTextVertex[7] = Vector3DMake(labelLeft,       0.0, labelBottom);  
        
    arrayTextMesh[ 0] = 0;
    arrayTextMesh[ 1] = 1;
    arrayTextMesh[ 2] = 4;
    arrayTextMesh[ 3] = 4;
    arrayTextMesh[ 4] = 1;
    arrayTextMesh[ 5] = 5;
    arrayTextMesh[ 6] = 1;
    arrayTextMesh[ 7] = 2;
    arrayTextMesh[ 8] = 5;
    arrayTextMesh[ 9] = 5;
    arrayTextMesh[10] = 2;
    arrayTextMesh[11] = 6;
    arrayTextMesh[12] = 2;
    arrayTextMesh[13] = 3;
    arrayTextMesh[14] = 6;
    arrayTextMesh[15] = 6;
    arrayTextMesh[16] = 3;
    arrayTextMesh[17] = 7;
         
    arrayBulletRightVertex[0] = Vector3DMake(labelRight - bulletRightWidth, 0.0, labelTop);  
    arrayBulletRightVertex[1] = Vector3DMake(labelRight,                    0.0, labelTop);  
    arrayBulletRightVertex[2] = Vector3DMake(labelRight - bulletRightWidth, 0.0, labelBottom);  
    arrayBulletRightVertex[3] = Vector3DMake(labelRight,                    0.0, labelBottom);  
    
    arrayBulletLeftVertex[0] = Vector3DMake(labelLeft,                   0.0, labelTop);  
    arrayBulletLeftVertex[1] = Vector3DMake(labelLeft + bulletLeftWidth, 0.0, labelTop);  
    arrayBulletLeftVertex[2] = Vector3DMake(labelLeft,                   0.0, labelBottom);  
    arrayBulletLeftVertex[3] = Vector3DMake(labelLeft + bulletLeftWidth, 0.0, labelBottom);  
    
    arrayBulletTexture[0] = Vector2DMake(1, 0);
    arrayBulletTexture[1] = Vector2DMake(0, 0);
    arrayBulletTexture[2] = Vector2DMake(1, 1);
    arrayBulletTexture[3] = Vector2DMake(0, 1);
    
    arrayBulletMesh[ 0] = 0;
    arrayBulletMesh[ 1] = 1;
    arrayBulletMesh[ 2] = 2;
    arrayBulletMesh[ 3] = 2;
    arrayBulletMesh[ 4] = 1;
    arrayBulletMesh[ 5] = 3;
    
    GLfloat textureStringRight  = self.scrollBase + (1.0 + labelViewportWidth) / 2.0;
    GLfloat textureStringLeft   = self.scrollBase + (1.0 - labelViewportWidth) / 2.0;
    GLfloat textureStringTop    = 0.0;
    GLfloat textureStringBottom = 1.0;
    
    GLfloat textureStringRightMargin = textureStringRight  - (self.fadeMargin / labelWidth * labelViewportWidth);
    GLfloat textureStringLeftMargin  = textureStringLeft   + (self.fadeMargin / labelWidth * labelViewportWidth);
    
    arrayTextTextureBase[0] = Vector2DMake(textureStringRight,        textureStringTop);
    arrayTextTextureBase[1] = Vector2DMake(textureStringRightMargin,  textureStringTop);
    arrayTextTextureBase[2] = Vector2DMake(textureStringLeftMargin,   textureStringTop);
    arrayTextTextureBase[3] = Vector2DMake(textureStringLeft,         textureStringTop);
    arrayTextTextureBase[4] = Vector2DMake(textureStringRight,        textureStringBottom);
    arrayTextTextureBase[5] = Vector2DMake(textureStringRightMargin,  textureStringBottom);
    arrayTextTextureBase[6] = Vector2DMake(textureStringLeftMargin,   textureStringBottom);
    arrayTextTextureBase[7] = Vector2DMake(textureStringLeft,         textureStringBottom);
}

-(void)draw
{    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            
    Color3D arrayTextColor[8];
    
    Color3D colorLabelOpaque;
    Color3D colorLabelTransparent;
    
    glDisableClientState(GL_NORMAL_ARRAY);

    glNormal3f(0.0, -1.0, 0.0);
    
    GLfloat lightness = self.lightness * self.textController.lightness;
        
    TRANSACTION_BEGIN
    {
        glTranslatef(self.layoutLocation.value.x, self.layoutLocation.value.y, self.layoutLocation.value.z);
        
        if(self.hasBorder)
        {        
            if(self.isLabelTouched && self.labelStatus == LabelStatusTextSelected)
            {
                colorLabelOpaque      = Color3DMake(lightness * self.colorTouched.red, lightness * self.colorTouched.green, lightness * self.colorTouched.blue,  self.colorTouched.alpha * self.textController.opacity);
                colorLabelTransparent = Color3DMake(lightness * self.colorTouched.red, lightness * self.colorTouched.green, lightness * self.colorTouched.blue, 0);
            }
            else 
            {
                colorLabelOpaque       = Color3DMake(lightness * self.colorNormal.red, lightness * self.colorNormal.green, lightness * self.colorNormal.blue, self.colorNormal.alpha * (1 - self.death.value) * self.layoutOpacity.value * self.textController.opacity);
                colorLabelTransparent  = Color3DMake(lightness * self.colorNormal.red, lightness * self.colorNormal.green, lightness * self.colorNormal.blue, 0);    
            }
                    
            glBindTexture(GL_TEXTURE_2D, self.isLabelTouched && self.labelStatus == LabelStatusTextSelected ? [TextureController nameForKey:@"borderTouched"] : [TextureController nameForKey:@"borderNormal"]);
                    
            glVertexPointer  (3, GL_FLOAT, 0, arrayBorderVertex);
            glTexCoordPointer(2, GL_FLOAT, 0, arrayBorderTexture);            

            glColor4f(colorLabelOpaque.red, colorLabelOpaque.green, colorLabelOpaque.blue, colorLabelOpaque.alpha);
            
            glDrawElements(GL_TRIANGLES, 54, GL_UNSIGNED_SHORT, arrayBorderMesh);    
        }
        
        if(self.textureText)
        {   
            glEnableClientState(GL_COLOR_ARRAY);
                        
            if(self.isLabelTouched && self.labelStatus == LabelStatusTextSelected)
            {
                colorLabelOpaque      = Color3DMake(lightness * self.colorTouched.red, lightness * self.colorTouched.green, lightness * self.colorTouched.blue,  self.colorTouched.alpha * self.textController.opacity);
                colorLabelTransparent = Color3DMake(lightness * self.colorTouched.red, lightness * self.colorTouched.green, lightness * self.colorTouched.blue, 0);
            }
            else 
            {
                colorLabelOpaque       = Color3DMake(lightness * self.colorNormal.red, lightness * self.colorNormal.green, lightness * self.colorNormal.blue, self.colorNormal.alpha * (1 - self.death.value) * self.layoutOpacity.value * self.textController.opacity);
                colorLabelTransparent  = Color3DMake(lightness * self.colorNormal.red, lightness * self.colorNormal.green, lightness * self.colorNormal.blue, 0);    
            }
                    
            glBindTexture(GL_TEXTURE_2D, self.textureText.name);
            
            arrayTextColor[0] = colorLabelTransparent;
            arrayTextColor[1] = colorLabelOpaque;
            arrayTextColor[2] = colorLabelOpaque;
            arrayTextColor[3] = colorLabelTransparent;
            arrayTextColor[4] = colorLabelTransparent;
            arrayTextColor[5] = colorLabelOpaque;
            arrayTextColor[6] = colorLabelOpaque;
            arrayTextColor[7] = colorLabelTransparent;

            if(within(self.scrollAmplitude, 0, 0.01))
            {
                glTexCoordPointer(2, GL_FLOAT, 0, arrayTextTextureBase);
            }
            else 
            {
                float scroll = self.scrollAmplitude * sin(CFAbsoluteTimeGetCurrent());
                
                memcpy(arrayTextTextureScrolled, arrayTextTextureBase, sizeof(Vector2D) * 8);
                
                arrayTextTextureScrolled[0].u = arrayTextTextureScrolled[0].u + scroll;
                arrayTextTextureScrolled[1].u = arrayTextTextureScrolled[1].u + scroll;
                arrayTextTextureScrolled[2].u = arrayTextTextureScrolled[2].u + scroll;
                arrayTextTextureScrolled[3].u = arrayTextTextureScrolled[3].u + scroll;
                arrayTextTextureScrolled[4].u = arrayTextTextureScrolled[4].u + scroll;
                arrayTextTextureScrolled[5].u = arrayTextTextureScrolled[5].u + scroll;
                arrayTextTextureScrolled[6].u = arrayTextTextureScrolled[6].u + scroll;
                arrayTextTextureScrolled[7].u = arrayTextTextureScrolled[7].u + scroll;
                
                glTexCoordPointer(2, GL_FLOAT, 0, arrayTextTextureScrolled);
            }
                    
            glVertexPointer  (3, GL_FLOAT, 0, arrayTextVertex);
            glColorPointer   (4, GL_FLOAT, 0, arrayTextColor);
            
            glDrawElements(GL_TRIANGLES, 18, GL_UNSIGNED_SHORT, arrayTextMesh);    
            
            glDisableClientState(GL_COLOR_ARRAY);
        }
        
        if(self.textureBulletRight)
        {
            if(self.isLabelTouched && self.labelStatus == LabelStatusBulletRightSelected)
            {
                colorLabelOpaque = Color3DMake(lightness * self.colorTouched.red, lightness * self.colorTouched.green, lightness * self.colorTouched.blue,  self.colorTouched.alpha * self.textController.opacity);
            }
            else 
            {
                colorLabelOpaque = Color3DMake(lightness * self.colorNormal.red, lightness * self.colorNormal.green, lightness * self.colorNormal.blue, self.colorNormal.alpha * (1 - self.death.value) * self.layoutOpacity.value * self.textController.opacity);
            }
            
            glBindTexture(GL_TEXTURE_2D, self.textureBulletRight.name);
            
            glDisableClientState(GL_NORMAL_ARRAY);
            
            glVertexPointer  (3, GL_FLOAT, 0, arrayBulletRightVertex);
            glTexCoordPointer(2, GL_FLOAT, 0, arrayBulletTexture);            
            
            glColor4f(colorLabelOpaque.red, colorLabelOpaque.green, colorLabelOpaque.blue, colorLabelOpaque.alpha);
                    
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, arrayBulletMesh);    
        }
        
        if(self.textureBulletLeft)
        {
            if(self.isLabelTouched && self.labelStatus == LabelStatusBulletLeftSelected)
            {
                colorLabelOpaque = Color3DMake(lightness * self.colorTouched.red, lightness * self.colorTouched.green, lightness * self.colorTouched.blue,  self.colorTouched.alpha * self.textController.opacity);
            }
            else 
            {
                colorLabelOpaque = Color3DMake(lightness * self.colorNormal.red, lightness * self.colorNormal.green, lightness * self.colorNormal.blue, self.colorNormal.alpha * (1 - self.death.value) * self.layoutOpacity.value * self.textController.opacity);
            }
                    
            glBindTexture(GL_TEXTURE_2D, self.textureBulletLeft.name);
                    
            glVertexPointer  (3, GL_FLOAT, 0, arrayBulletLeftVertex);
            glTexCoordPointer(2, GL_FLOAT, 0, arrayBulletTexture);           
            
            glColor4f(colorLabelOpaque.red, colorLabelOpaque.green, colorLabelOpaque.blue, colorLabelOpaque.alpha);
                    
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, arrayBulletMesh);    
        }
    }
    TRANSACTION_END    
        
    glEnableClientState(GL_NORMAL_ARRAY);
}


@end

@implementation GLLabel (Touchable)

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    GLfloat model_view[16];
    GLfloat projection[16];
    GLint viewport[4];

    Vector2D pointsText[16];
    Vector2D pointsBulletRight[4];
    Vector2D pointsBulletLeft[4];
    
    TRANSACTION_BEGIN
    {    
        glTranslatef(self.layoutLocation.value.x, self.layoutLocation.value.y, self.layoutLocation.value.z);
        
        glGetFloatv(GL_MODELVIEW_MATRIX, model_view);
        glGetFloatv(GL_PROJECTION_MATRIX, projection);
        
        glGetIntegerv(GL_VIEWPORT, viewport);
    }
    TRANSACTION_END
    
    ProjectVectors(arrayBorderVertex,      pointsText,        16, model_view, projection, viewport);
    ProjectVectors(arrayBulletRightVertex, pointsBulletRight,  4, model_view, projection, viewport);
    ProjectVectors(arrayBulletLeftVertex,  pointsBulletLeft,   4, model_view, projection, viewport);
    
    CGPoint touchPoint = [touch locationInView:touch.view];
    
    Vector2D touchLocation = Vector2DMake(touchPoint.x, 480 - touchPoint.y);
    
    if(TestTriangles(touchLocation, pointsText,        arrayBorderMesh, 18)) { self.labelStatus = LabelStatusTextSelected;        return self; }
    if(TestTriangles(touchLocation, pointsBulletRight, arrayBulletMesh,  2)) { self.labelStatus = LabelStatusBulletRightSelected; return self; }
    if(TestTriangles(touchLocation, pointsBulletLeft,  arrayBulletMesh,  2)) { self.labelStatus = LabelStatusBulletLeftSelected;  return self; }
    
    return object;
}

-(void)handleTouchDown:(UITouch*)touch fromPoint:(CGPoint)point
{    
    self.isLabelTouched = YES;
    
    [self.owner handleTouchDown:touch fromPoint:point];
}

-(void)handleTouchMoved:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    [self.owner handleTouchMoved:touch fromPoint:pointFrom toPoint:pointTo];

    GLfloat deltaX = pointTo.x - pointFrom.x;
    GLfloat deltaY = pointTo.y - pointFrom.y;
        
    if(deltaX * deltaX + deltaY * deltaY > 100)
    {        
        self.isLabelTouched = NO;

        self.labelStatus = LabelStatusNothingSelected;
    }
}

-(void)handleTouchUp:(UITouch*)touch fromPoint:(CGPoint)pointFrom toPoint:(CGPoint)pointTo
{
    [self.owner handleTouchUp:touch fromPoint:pointFrom toPoint:pointTo];
    
    if(self.isLabelTouched)
    {
        if(self.labelStatus == LabelStatusTextSelected)
        {        
            if(self.key) { [self.owner labelTouchedWithKey:self.key]; }
        }
        
        if(self.labelStatus == LabelStatusBulletRightSelected)
        {        
        }
        
        if(self.labelStatus == LabelStatusBulletLeftSelected)
        {        
        }
    }

    self.isLabelTouched = NO;
    
    self.labelStatus = LabelStatusNothingSelected;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"Label with key: '%@', text:'%@'", self.key, self.textString];
}

@end

@implementation GLLabel (Killable)

@dynamic isDead;
@dynamic isAlive;

-(BOOL)isAlive { return (self.death.endTime < CFAbsoluteTimeGetCurrent()) && within(self.death.value, 0, 0.001); }
-(BOOL)isDead  { return (self.death.endTime < CFAbsoluteTimeGetCurrent()) && within(self.death.value, 1, 0.001); }

-(void)killWithDisplayContainer:(DisplayContainer*)container andKey:(id)key
{
    [self.death setValue:1 forTime:1 andThen:^{ [container pruneDeadForKey:key]; [self.owner layoutItems]; }];
    
    [container pruneLiveForKey:key];
}

@end