//
//  GLView2.h
//  BasicCamera
//
//  Created by Keiichiro Nagashima on 12/07/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shader.h"



@interface GLView2 : UIView
{
    /* The pixel dimensions of the backbuffer */
    GLint framebufferWidth;
    GLint framebufferHeight;
	
	
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint defaultFramebuffer;
    GLuint colorRenderbuffer;
	
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
	
	
    GLuint shaderProgram;
    GLint shaderAttribVertexPosition;
    
    GLuint texture;
}


@property (nonatomic, strong)EAGLContext* context;
@property (strong, nonatomic)CADisplayLink* diplayLink;

@property (strong, nonatomic)Shader* shader;


-(void)startAnimation;
-(void)stopAnimation;
-(void)changeFilter;

@end
