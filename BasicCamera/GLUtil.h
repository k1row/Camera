//
//  GLUtil.h
//  BasicCamera
//
//  Created by Keiichiro Nagashima on 12/07/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef _GLUTIL_H_
#define _GLUTIL_H_

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#ifndef uint
#define uint unsigned int
#endif

#ifndef uchar
#define uchar unsigned char
#endif

#ifdef DEBUG // build for Debug

#define debug_log(format, ...) NSLog(format, ## __VA_ARGS__)
#define CHECK_GL_ERROR()	{ int err = glGetError (); \
if (err != GL_NO_ERROR) { debug_log (@"glGetError() = 0x%x\n", err); glGetError (); assert (false); }}

#else // build for Release

#define debug_log (format, ...)
#define CHECK_GL_ERROR ()	

#endif


#endif