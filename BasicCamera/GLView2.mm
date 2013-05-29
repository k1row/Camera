//
//  GLView2.m
//  BasicCamera
//
//  Created by Keiichiro Nagashima on 12/07/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>


#import "GLView2.h"
#import "GLUtil.h"

#define HAS_EAGLVIEW_DEPTH_BUFFER 1


@interface GLView2 ()
- (void) createFramebuffer;
- (void) destroyFramebuffer;
@end

@implementation GLView2

@synthesize context = _context;
@synthesize diplayLink = _diplayLink;
@synthesize shader = _shader;


+ (Class)layerClass 
{
    return  [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder 
{	
    if ((self = [super initWithCoder:coder])) 
    {
        self.shader = [[Shader alloc] init];
        
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE],
                                        kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8,
                                        kEAGLDrawablePropertyColorFormat, nil];
        // コンテキストを取得
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (!self.context || ![EAGLContext setCurrentContext:self.context])
            return nil;


        [self build];
        glGenFramebuffers (1, &defaultFramebuffer);CHECK_GL_ERROR ();
        glGenRenderbuffers (1, &colorRenderbuffer);CHECK_GL_ERROR ();
        glBindFramebuffer (GL_FRAMEBUFFER, defaultFramebuffer);CHECK_GL_ERROR ();
        glBindRenderbuffer (GL_RENDERBUFFER, colorRenderbuffer);CHECK_GL_ERROR ();
        glFramebufferRenderbuffer (GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, 
                                   GL_RENDERBUFFER, colorRenderbuffer);CHECK_GL_ERROR ();
        
        
        glEnable(GL_TEXTURE_2D);
        
        texture = [self loadTexture:@"back.png"];
        
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        
    }
    return self;
}

- (GLuint) loadTexture:(NSString*)fileName
{
    GLuint text;
    CGImageRef img = [UIImage imageNamed:fileName].CGImage;
    int w, h;
    w = CGImageGetWidth(img);
    h = CGImageGetHeight(img);
    GLubyte* data = (GLubyte*)malloc(w * h * 4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(data, w, h, 8, w * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(ctx,CGRectMake(0, 0, w, h));
    
    CGContextDrawImage(ctx, CGRectMake(0, 0, w, h), img);
    
    glGenTextures(1, &text);
    glBindTexture(GL_TEXTURE_2D, text);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    free(data);
    
    return text;
}

- (void)build
{
    /*
    NSString* vertexShader = @""
	"attribute vec4 vertexPosition;   \n"
	"void main()                 \n"
	"{                           \n"
	"    gl_Position = vertexPosition; \n"
	"}                           \n";
    
    NSString* fragmentShader = @"" 
	"precision mediump float;                  \n"
	"void main()                               \n"
	"{                                         \n"
	"    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0); \n"
	"}                                         \n"; 
     */
    
    NSString* vertexShader = @""
    " \n"
    "uniform mat4 World; \n" //プリミティブのワールド行列
    "uniform mat4 View; \n" //ビュー行列
    "uniform mat4 Projection; \n" //射影行列
    " \n"
    "attribute vec4 vPosition; \n" //読み込み用の頂点座標
    "attribute vec2 a_vTexCoord; \n" //読み込み用のuv座標
    " \n"
    "varying vec2 v_vTexCoord; \n" //フラグメントシェーダに渡すuv座標
    " \n"
    "void main() \n"
    "{ \n"
    " gl_Position = World * vPosition; \n" //1.頂点座標にワールド行列を掛ける
    " gl_Position = View * gl_Position; \n" //2.1の結果にビュー行列を掛ける
    " gl_Position = Projection * gl_Position; \n" //3.2の結果に射影行列を掛ける
    " \n"
    "v_vTexCoord = a_vTexCoord; \n" //読み込んだuv座標をそのまま
    "} \n";	 //フラグメントシェーダに渡す
    
    //フラグメントシェーダ
    NSString* fragmentShader = @""
    "precision mediump float; \n"
    "varying vec2 v_vTexCoord; \n" //頂点シェーダから受け取るuv座標
    "uniform sampler2D s_texture; \n" //サンプラー型のuniform変数
    " \n"
    "void main() \n"
    "{ \n"
    " gl_FragColor = texture2D(s_texture, v_vTexCoord); \n" //uv座標によってテクスチャを描画
    "} \n";
    
    
    NSArray* attribs = [NSArray arrayWithObjects:@"a_position", @"a_texCoord", nil];
	NSArray* uniforms = [NSArray arrayWithObjects:@"u_matrix", @"u_texture", 
						 @"u_color", @"u_alpha", nil];
    
    NSString* ret = [self.shader build:vertexShader fsh:fragmentShader attributeVariables:attribs uniformVariables:uniforms];
    if (ret != nil)
    {
        assert (false);
        NSLog (@"Failed to build shader %@", ret);    
    }
}


- (void)createFramebuffer
{
    if (self.context && !defaultFramebuffer) 
    {
        //[EAGLContext setCurrentContext:self.context];
        
        // Create default framebuffer object.
        glGenFramebuffers (1, &defaultFramebuffer);CHECK_GL_ERROR ();
        glBindFramebuffer (GL_FRAMEBUFFER, defaultFramebuffer);CHECK_GL_ERROR ();
        
        // Create color render buffer and allocate backing store.
        glGenRenderbuffers (1, &colorRenderbuffer);CHECK_GL_ERROR ();
        glBindRenderbuffer (GL_RENDERBUFFER, colorRenderbuffer);CHECK_GL_ERROR ();
        [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
        glGetRenderbufferParameteriv (GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);CHECK_GL_ERROR ();
        glGetRenderbufferParameteriv (GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);CHECK_GL_ERROR ();
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);CHECK_GL_ERROR ();

#if HAS_EAGLVIEW_DEPTH_BUFFER
		glGenRenderbuffers (1, &depthRenderbuffer);CHECK_GL_ERROR ();
		glBindRenderbuffer (GL_RENDERBUFFER, depthRenderbuffer);CHECK_GL_ERROR ();
		glFramebufferRenderbuffer (GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);CHECK_GL_ERROR ();
		glRenderbufferStorage (GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, framebufferWidth, framebufferHeight);CHECK_GL_ERROR ();
#endif
        
        if (glCheckFramebufferStatus (GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        {
            NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
            switch (glCheckFramebufferStatus (GL_FRAMEBUFFER))
            {
                case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS:
                    debug_log(@"GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS");
                    break;
                case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
                    debug_log(@"GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT");
                    break;
                case GL_FRAMEBUFFER_UNSUPPORTED:
                    debug_log(@"GL_FRAMEBUFFER_UNSUPPORTED");
                    break;
                default:
                    debug_log(@"NOBADY KNOWS");
                    break;
            }
        }
    }
}

- (void)deleteFramebuffer
{
    if (self.context) 
    {
        //[EAGLContext setCurrentContext:self.context];
        
        if (defaultFramebuffer)
        {
            glDeleteFramebuffers (1, &defaultFramebuffer);CHECK_GL_ERROR ();
            defaultFramebuffer = 0;
        }
        
        if (colorRenderbuffer) 
        {
            glDeleteRenderbuffers (1, &colorRenderbuffer);CHECK_GL_ERROR ();
            colorRenderbuffer = 0;
        }
        
#if HAS_EAGLVIEW_DEPTH_BUFFER		
		if (depthRenderbuffer)
        {
            glDeleteRenderbuffers (1, &depthRenderbuffer);CHECK_GL_ERROR ();
            depthRenderbuffer = 0;
        }
#endif
    }
}


// サブビューをレイアウト
- (void)layoutSubviews
{
	glBindRenderbuffer (GL_RENDERBUFFER, colorRenderbuffer);CHECK_GL_ERROR ();
	[self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
	glGetRenderbufferParameteriv (GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);CHECK_GL_ERROR ();
	glGetRenderbufferParameteriv (GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);CHECK_GL_ERROR ();
	if (glCheckFramebufferStatus (GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus (GL_FRAMEBUFFER));
		return;
	}
	[self setViewRect:CGRectMake (0, 0, self.width, self.height)];
}

// ビューサイズ設定
- (void) setViewRect:(CGRect)rect
{
	glViewport(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);CHECK_GL_ERROR();
}



-(void)startAnimation
{
    // To enable displaylink
    self.diplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector (drawView:)];
    [self.diplayLink setFrameInterval:1];
    [self.diplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)stopAnimation
{
    // To unable displaylink
    [self.diplayLink invalidate];
    self.diplayLink = nil;
}

// ビューを描画
- (void)drawView:(id)sender 
{
	//[EAGLContext setCurrentContext:self.context];
    if ([EAGLContext currentContext] != self.context)
        [EAGLContext setCurrentContext:self.context];
    
	glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);CHECK_GL_ERROR();
	glClearColor(1.0f, 1.0f, 1.0f, 1.0f);CHECK_GL_ERROR();
	glClear(GL_COLOR_BUFFER_BIT);CHECK_GL_ERROR();
	[self drawMain];
	glFlush();CHECK_GL_ERROR();
	// バックバッファをフロントバッファへ
	glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);CHECK_GL_ERROR();
	[self.context presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)drawMain
{
    float vertexs[] = {
        -1.0f, -1.0f, 0.0f,  //left top
        -1.0f,  1.0f, 0.0f,   //left bottom
        1.0f, -1.0f, 0.0f,   //right top
        1.0f,  1.0f, 0.0f,   //right bottom
    };
    
    float texcoords[] = {
        0.0f, 0.0f,//left top
        0.0f, 1.0f,//left bottom
        1.0f, 0.0f,//right top
        1.0f, 1.0f,//right bottom
    };
    
    [self.shader use];    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    //glUniform1i(uniforms[UNIFORM_TEXTURE], 0);
    
    //glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, false, 0, texcoords);                
    //glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, false, 0, vertexs);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    // Replace the implementation of this method to do your own custom drawing
    /*
    const GLfloat squareVertices[] = {
        -0.5f, -0.5f, 0.2f,
        0.5f,  -0.5f, 0.2f,
        -0.5f,  0.5f, 0.2f,
        0.5f,   0.5f, 0.2f,
    };

    const GLfloat squareVertices[] = {
        -0.5f, -0.5f,
        0.5f,  -0.5f,
        -0.5f,  0.5f,
        0.5f,   0.5f,
    };
     */
    
    //[self deleteFramebuffer];
    //[self createFramebuffer];

    /*
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);CHECK_GL_ERROR ();
	
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);CHECK_GL_ERROR ();
    glViewport(0, 0, framebufferWidth, framebufferHeight);CHECK_GL_ERROR ();
	
    [self.shader use];
    shaderAttribVertexPosition = glGetAttribLocation (self.shader.programId, "vertexPosition");CHECK_GL_ERROR ();
    
    glEnableVertexAttribArray (shaderAttribVertexPosition);CHECK_GL_ERROR ();
    glVertexAttribPointer (shaderAttribVertexPosition, 3, GL_FLOAT, GL_FALSE, 0, squareVertices);CHECK_GL_ERROR ();
    glDrawArrays (GL_TRIANGLE_STRIP, 0, 4);CHECK_GL_ERROR ();
    glDisableVertexAttribArray (shaderAttribVertexPosition);CHECK_GL_ERROR ();
	glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);CHECK_GL_ERROR ();
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
     */
}


@end
