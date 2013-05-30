//
//  SimpleOpenGL.h
//  BasicCamera
//
//  Created by k16 on 12/07/27.
//
//

#import <Foundation/Foundation.h>
#import "GLUtil.h"

@interface SimpleOpenGL : UIView
{
    GLint bufferWidth;
    GLint bufferHeight;
}
@property GLuint programObject;
@property (nonatomic, strong)EAGLContext* context;
@property (strong, nonatomic)CADisplayLink* diplayLink;
@property(strong, nonatomic) NSString* error;

-(void)startAnimation;
-(void)stopAnimation;

@end
