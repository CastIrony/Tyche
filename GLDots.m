#import "AnimatedFloat.h"
#import "GLTexture.h"
#import "GLMenu.h"

#import "GLDots.h"

@implementation GLDots

@synthesize texture;
@synthesize menu;

-(void)draw
{
    glColor4f(0, 0, 0, self.menu.opacity.value);
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glBindTexture(GL_TEXTURE_2D, self.texture.name);
    
    glVertexPointer  (3, GL_FLOAT, 0, _arrayVertex);
    glNormalPointer  (   GL_FLOAT, 0, _arrayNormal);
    glTexCoordPointer(2, GL_FLOAT, 0, _arrayTexture);            
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, _arrayMesh);   
}

-(void)setDots:(int)dots current:(int)current;
{
    self.texture = [[[GLTexture alloc] initWithDots:23 current:4] autorelease];
}

@end
