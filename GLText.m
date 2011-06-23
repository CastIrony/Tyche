#import "Geometry.h"
#import "MC3DVector.h"
#import "Bezier.h"
#import "GLTexture.h"
#import "Projection.h"
#import "AnimatedFloat.h"
#import "AnimatedVec3.h"
#import "AppController.h"
#import "GameController.h"
#import "GLTextController.h"
#import "TextureController.h"
#import "GLRenderer.h"
#import "DisplayContainer.h"

#import "GLText.h"

@implementation GLText

@synthesize textController       = _textController;

@synthesize labelStatus          = _labelStatus;

@synthesize textureText          = _textureText;
@synthesize textureBulletLeft    = _textureBulletLeft;
@synthesize textureBulletRight   = _textureBulletRight;

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
@synthesize topMargin            = _topMargin;
@synthesize bottomMargin         = _bottomMargin;
@synthesize topPadding           = _topPadding;
@synthesize bottomPadding        = _bottomPadding;

@synthesize colorNormal          = _colorNormal;
@synthesize colorTouched         = _colorTouched;
@synthesize textAlignment        = _textAlignment;

@synthesize isLabelTouched       = _isLabelTouched;

@synthesize scrollBase           = _scrollBase;
@synthesize scrollAmplitude      = _scrollAmplitude;

@synthesize hasBorder            = _hasBorder;
@synthesize hasShadow            = _hasShadow;

@synthesize owner                = _owner;

@synthesize key                  = _key;
@synthesize displayContainer     = _displayContainer;

@dynamic layoutSize;
@dynamic borderSize;

-(CGSize)layoutSize { return self.hasBorder ? CGSizeMake(self.labelSize.width + 0.75, self.labelSize.height + 1.5) : self.labelSize; }
-(CGSize)borderSize { return self.hasBorder ? CGSizeMake(self.labelSize.width + 0.75, self.labelSize.height + 0.75) : self.labelSize; }

-(BOOL)isEqual:(id)object
{
    GLText* label = (GLText*)object;
    
    if(label.key               != self.key               && ![label.key               isEqual:self.key])               { return NO; }
    if(label.textString        != self.textString        && ![label.textString        isEqual:self.textString])        { return NO; }
    if(label.font              != self.font              && ![label.font              isEqual:self.font])              { return NO; }
    if(label.bulletLeftString  != self.bulletLeftString  && ![label.bulletLeftString  isEqual:self.bulletLeftString])  { return NO; }
    if(label.bulletRightString != self.bulletRightString && ![label.bulletRightString isEqual:self.bulletRightString]) { return NO; }
    
    if(label.fadeMargin         != self.fadeMargin)         { return NO; }
    if(label.topMargin          != self.topMargin)          { return NO; }
    if(label.bottomMargin       != self.bottomMargin)       { return NO; }
    if(label.topPadding         != self.topPadding)         { return NO; }
    if(label.bottomPadding      != self.bottomPadding)      { return NO; }
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

+(GLText*)withDictionaries:(NSArray*)dictionaries
{
    GLText* label = [[[GLText alloc] init] autorelease];
    
    NSMutableDictionary* styles = [NSMutableDictionary dictionary];
    
    for(NSDictionary* dictionary in dictionaries) 
    {     
        [styles addEntriesFromDictionary:dictionary]; 
    }
        
    color colorNormal;
    color colorTouched;
    
    [[styles objectForKey:@"colorNormal"] getValue:&colorNormal];
    [[styles objectForKey:@"colorTouched"] getValue:&colorTouched];
        
    [label setValuesForKeysWithDictionary:styles];

    [label makeMeshes];
    
    return label;
}

-(void)makeTextures
{
    if(!self.font) { return; }
    
    if(self.textString) 
    { 
        self.textureText = [[[GLTexture alloc] initWithString:self.textString font:self.font] autorelease];
    }
    
    if(self.bulletLeftString) 
    { 
        self.textureBulletLeft = [[[GLTexture alloc] initWithString:self.bulletLeftString font:self.font] autorelease];
    }
    
    if(self.bulletRightString) 
    { 
        self.textureBulletRight = [[[GLTexture alloc] initWithString:self.bulletRightString font:self.font] autorelease];
    }
}

-(id)init
{
    self = [super init];
    
    if(self) 
    {   
        _colorNormal   = colorMake(1, 1, 1, 1);
        _colorTouched  = colorMake(1, 1, 1, 1);
        _textAlignment = UITextAlignmentCenter;
        _hasShadow = NO;
        
        self.layoutLocation = [AnimatedVec3 vec3WithValue:vec3Make(0, 0, 0)];
        self.layoutOpacity  = [AnimatedFloat floatWithValue:0.0];
        self.death          = [AnimatedFloat floatWithValue:0.0];
        self.fadeMargin     = 0;
        
        arrayTextVertex          = malloc( 8 * sizeof(vec3));
        arrayBulletRightVertex   = malloc( 4 * sizeof(vec3));
        arrayBulletLeftVertex    = malloc( 4 * sizeof(vec3));
        arrayBorderVertex        = malloc(16 * sizeof(vec3));
        arrayTextTextureBase     = malloc( 8 * sizeof(vec2));
        arrayTextTextureScrolled = malloc( 8 * sizeof(vec2));
        arrayBulletTexture       = malloc( 4 * sizeof(vec2));
        arrayBorderTexture       = malloc(16 * sizeof(vec2));
        arrayTextMesh            = malloc(18 * sizeof(GLushort));
        arrayBulletMesh          = malloc( 6 * sizeof(GLushort));
        arrayBorderMesh          = malloc(54 * sizeof(GLushort));
    }
    
    return self;
}

+(GLText*)emptyLabel
{
    GLText* label = [[[GLText alloc] init] autorelease];
    
    label.font = [UIFont fontWithName:@"Futura-Medium" size:10];
    label.labelSize = CGSizeMake(0, 1);
    
    return label;
}

-(void)makeMeshes
{
    if(!self.textureText) { [self makeTextures]; }
    
    GLfloat textWidth    = self.textureText.contentSize.width;
    GLfloat textHeight   = self.textureText.contentSize.height;
    GLfloat borderWidth  = self.borderSize.width;
    GLfloat borderHeight = self.borderSize.height;
    
    GLfloat bulletRightWidth  = self.textureBulletRight ? self.textureBulletRight.contentSize.width / self.textureBulletRight.contentSize.height * self.labelSize.height : 0;
    GLfloat bulletLeftWidth   = self.textureBulletLeft ? self.textureBulletLeft.contentSize.width / self.textureBulletLeft.contentSize.height * self.labelSize.height : 0;
    
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
    
    arrayBorderVertex[ 0] = vec3Make(borderRight,       0.0, borderTop);  
    arrayBorderVertex[ 1] = vec3Make(borderRightMargin, 0.0, borderTop);  
    arrayBorderVertex[ 2] = vec3Make(borderLeftMargin,  0.0, borderTop);  
    arrayBorderVertex[ 3] = vec3Make(borderLeft,        0.0, borderTop);
    arrayBorderVertex[ 4] = vec3Make(borderRight,       0.0, borderTopMargin);  
    arrayBorderVertex[ 5] = vec3Make(borderRightMargin, 0.0, borderTopMargin);  
    arrayBorderVertex[ 6] = vec3Make(borderLeftMargin,  0.0, borderTopMargin);  
    arrayBorderVertex[ 7] = vec3Make(borderLeft,        0.0, borderTopMargin);  
    arrayBorderVertex[ 8] = vec3Make(borderRight,       0.0, borderBottomMargin);  
    arrayBorderVertex[ 9] = vec3Make(borderRightMargin, 0.0, borderBottomMargin);  
    arrayBorderVertex[10] = vec3Make(borderLeftMargin,  0.0, borderBottomMargin);  
    arrayBorderVertex[11] = vec3Make(borderLeft,        0.0, borderBottomMargin);  
    arrayBorderVertex[12] = vec3Make(borderRight,       0.0, borderBottom);  
    arrayBorderVertex[13] = vec3Make(borderRightMargin, 0.0, borderBottom);  
    arrayBorderVertex[14] = vec3Make(borderLeftMargin,  0.0, borderBottom);  
    arrayBorderVertex[15] = vec3Make(borderLeft,        0.0, borderBottom);  
    
    arrayBorderTexture[ 0] = vec2Make(0.0, 0.0);  
    arrayBorderTexture[ 1] = vec2Make(0.5, 0.0);  
    arrayBorderTexture[ 2] = vec2Make(0.5, 0.0);  
    arrayBorderTexture[ 3] = vec2Make(1.0, 0.0);
    arrayBorderTexture[ 4] = vec2Make(0.0, 0.5);
    arrayBorderTexture[ 5] = vec2Make(0.5, 0.5);  
    arrayBorderTexture[ 6] = vec2Make(0.5, 0.5);  
    arrayBorderTexture[ 7] = vec2Make(1.0, 0.5);  
    arrayBorderTexture[ 8] = vec2Make(0.0, 0.5);  
    arrayBorderTexture[ 9] = vec2Make(0.5, 0.5);  
    arrayBorderTexture[10] = vec2Make(0.5, 0.5);  
    arrayBorderTexture[11] = vec2Make(1.0, 0.5);  
    arrayBorderTexture[12] = vec2Make(0.0, 1.0);  
    arrayBorderTexture[13] = vec2Make(0.5, 1.0);  
    arrayBorderTexture[14] = vec2Make(0.5, 1.0);  
    arrayBorderTexture[15] = vec2Make(1.0, 1.0);  
    
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
    
    
    arrayTextVertex[0] = vec3Make(labelRight,      0.0, labelTop);  
    arrayTextVertex[1] = vec3Make(labelRightFade,  0.0, labelTop);  
    arrayTextVertex[2] = vec3Make(labelLeftFade,   0.0, labelTop);  
    arrayTextVertex[3] = vec3Make(labelLeft,       0.0, labelTop);  
    arrayTextVertex[4] = vec3Make(labelRight,      0.0, labelBottom);  
    arrayTextVertex[5] = vec3Make(labelRightFade,  0.0, labelBottom);  
    arrayTextVertex[6] = vec3Make(labelLeftFade,   0.0, labelBottom);  
    arrayTextVertex[7] = vec3Make(labelLeft,       0.0, labelBottom);  
        
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
         
    arrayBulletRightVertex[0] = vec3Make(labelRight - bulletRightWidth, 0.0, labelTop);  
    arrayBulletRightVertex[1] = vec3Make(labelRight,                    0.0, labelTop);  
    arrayBulletRightVertex[2] = vec3Make(labelRight - bulletRightWidth, 0.0, labelBottom);  
    arrayBulletRightVertex[3] = vec3Make(labelRight,                    0.0, labelBottom);  
    
    arrayBulletLeftVertex[0] = vec3Make(labelLeft,                   0.0, labelTop);  
    arrayBulletLeftVertex[1] = vec3Make(labelLeft + bulletLeftWidth, 0.0, labelTop);  
    arrayBulletLeftVertex[2] = vec3Make(labelLeft,                   0.0, labelBottom);  
    arrayBulletLeftVertex[3] = vec3Make(labelLeft + bulletLeftWidth, 0.0, labelBottom);  
    
    arrayBulletTexture[0] = vec2Make(1, 0);
    arrayBulletTexture[1] = vec2Make(0, 0);
    arrayBulletTexture[2] = vec2Make(1, 1);
    arrayBulletTexture[3] = vec2Make(0, 1);
    
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
    
    arrayTextTextureBase[0] = vec2Make(textureStringRight,        textureStringTop);
    arrayTextTextureBase[1] = vec2Make(textureStringRightMargin,  textureStringTop);
    arrayTextTextureBase[2] = vec2Make(textureStringLeftMargin,   textureStringTop);
    arrayTextTextureBase[3] = vec2Make(textureStringLeft,         textureStringTop);
    arrayTextTextureBase[4] = vec2Make(textureStringRight,        textureStringBottom);
    arrayTextTextureBase[5] = vec2Make(textureStringRightMargin,  textureStringBottom);
    arrayTextTextureBase[6] = vec2Make(textureStringLeftMargin,   textureStringBottom);
    arrayTextTextureBase[7] = vec2Make(textureStringLeft,         textureStringBottom);
}

-(void)draw
{    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            
    color arrayTextColor[8];
    
    color colorLabelOpaque;
    color colorLabelTransparent;
    
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
                colorLabelOpaque      = colorMake(lightness * self.colorTouched.red, lightness * self.colorTouched.green, lightness * self.colorTouched.blue,  self.colorTouched.alpha * self.textController.opacity.value);
                colorLabelTransparent = colorMake(lightness * self.colorTouched.red, lightness * self.colorTouched.green, lightness * self.colorTouched.blue, 0);
            }
            else 
            {
                colorLabelOpaque       = colorMake(lightness * self.colorNormal.red, lightness * self.colorNormal.green, lightness * self.colorNormal.blue, self.colorNormal.alpha * (1 - self.death.value) * self.layoutOpacity.value * self.textController.opacity.value);
                colorLabelTransparent  = colorMake(lightness * self.colorNormal.red, lightness * self.colorNormal.green, lightness * self.colorNormal.blue, 0);    
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
                colorLabelOpaque      = colorMake(lightness * self.colorTouched.red, lightness * self.colorTouched.green, lightness * self.colorTouched.blue,  self.colorTouched.alpha * self.textController.opacity.value);
                colorLabelTransparent = colorMake(lightness * self.colorTouched.red, lightness * self.colorTouched.green, lightness * self.colorTouched.blue, 0);
            }
            else 
            {
                colorLabelOpaque       = colorMake(lightness * self.colorNormal.red, lightness * self.colorNormal.green, lightness * self.colorNormal.blue, self.colorNormal.alpha * (1 - self.death.value) * self.layoutOpacity.value * self.textController.opacity.value);
                colorLabelTransparent  = colorMake(lightness * self.colorNormal.red, lightness * self.colorNormal.green, lightness * self.colorNormal.blue, 0);    
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
                float scroll = self.scrollAmplitude * sin(CACurrentMediaTime());
                
                memcpy(arrayTextTextureScrolled, arrayTextTextureBase, sizeof(vec2) * 8);
                
                arrayTextTextureScrolled[0].x = arrayTextTextureScrolled[0].x + scroll;
                arrayTextTextureScrolled[1].x = arrayTextTextureScrolled[1].x + scroll;
                arrayTextTextureScrolled[2].x = arrayTextTextureScrolled[2].x + scroll;
                arrayTextTextureScrolled[3].x = arrayTextTextureScrolled[3].x + scroll;
                arrayTextTextureScrolled[4].x = arrayTextTextureScrolled[4].x + scroll;
                arrayTextTextureScrolled[5].x = arrayTextTextureScrolled[5].x + scroll;
                arrayTextTextureScrolled[6].x = arrayTextTextureScrolled[6].x + scroll;
                arrayTextTextureScrolled[7].x = arrayTextTextureScrolled[7].x + scroll;
                
                glTexCoordPointer(2, GL_FLOAT, 0, arrayTextTextureScrolled);
            }
                                
            glVertexPointer(3, GL_FLOAT, 0, arrayTextVertex);
            glColorPointer (4, GL_FLOAT, 0, arrayTextColor);
            
            glDrawElements(GL_TRIANGLES, 18, GL_UNSIGNED_SHORT, arrayTextMesh);    
            
            glDisableClientState(GL_COLOR_ARRAY);
        }
        
        if(self.textureBulletRight)
        {
            if(self.isLabelTouched && self.labelStatus == LabelStatusBulletRightSelected)
            {
                colorLabelOpaque = colorMake(lightness * self.colorTouched.red, lightness * self.colorTouched.green, lightness * self.colorTouched.blue,  self.colorTouched.alpha * self.textController.opacity.value);
            }
            else 
            {
                colorLabelOpaque = colorMake(lightness * self.colorNormal.red, lightness * self.colorNormal.green, lightness * self.colorNormal.blue, self.colorNormal.alpha * (1 - self.death.value) * self.layoutOpacity.value * self.textController.opacity.value);
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
                colorLabelOpaque = colorMake(lightness * self.colorTouched.red, lightness * self.colorTouched.green, lightness * self.colorTouched.blue,  self.colorTouched.alpha * self.textController.opacity.value);
            }
            else 
            {
                colorLabelOpaque = colorMake(lightness * self.colorNormal.red, lightness * self.colorNormal.green, lightness * self.colorNormal.blue, self.colorNormal.alpha * (1 - self.death.value) * self.layoutOpacity.value * self.textController.opacity.value);
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

-(id<Touchable>)testTouch:(UITouch*)touch withPreviousObject:(id<Touchable>)object
{
    GLfloat model_view[16];
    GLfloat projection[16];
    GLint viewport[4];

    vec2 pointsText[16];
    vec2 pointsBulletRight[4];
    vec2 pointsBulletLeft[4];
    
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
    
    vec2 touchLocation = vec2Make(touchPoint.x, UIScreen.mainScreen.bounds.size.height - touchPoint.y);
    
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
    NSString* status = @"D";
    
    if(self.isAlive) { status = @"A"; }
    if(self.isDead)  { status = @"X"; }
    
    return [NSString stringWithFormat:@"<GLText key:'%@', text:'%@', status:'%@:%3i'>", self.key, self.textString, status, (int)(self.death.value * 100)];
}

-(BOOL)isAlive { return within(self.death.endValue, 0, 0.001); }
-(BOOL)isDead  { return within(self.death.value,    1, 0.001); }

-(void)reincarnate:(id<Displayable>)oldObject
{
    if([oldObject isKindOfClass:[GLText class]])
    {
        GLText* oldLabel = (GLText*)oldObject;
        
        self.layoutLocation = oldLabel.layoutLocation;
    }
}

-(void)dieAfterDelay:(NSTimeInterval)delay andThen:(SimpleBlock)work
{
    [self.death setValue:1 forTime:0.4 afterDelay:delay andThen:work];
}

@end