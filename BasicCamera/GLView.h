//
//  GLView.h
//  BasicCamera
//
//  Created by Keiichiro Nagashima on 12/07/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "Shader.h"


@interface GLView : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    // OPenGL
    GLuint defaultFramebuffer;
    GLuint colorRenderbuffer;
    
    GLint backingWidth;
    GLint backingHeight;
    
    GLint shaderAttribVertexPosition;
}

@property (strong, nonatomic)EAGLContext* context;
@property (strong, nonatomic)CADisplayLink* diplayLink;

@property (strong, nonatomic)Shader* shader;




-(void)startAnimation;
-(void)stopAnimation;
-(void)changeFilter;

@end