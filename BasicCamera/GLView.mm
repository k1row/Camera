//
//  GLView.m
//  BasicCamera
//
//  Created by Keiichiro Nagashima on 12/07/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GLUtil.h"
#import "GLView.h"
//#import "Color.h"
//#import "Vector.h"


@interface GLView ()
{
    // 位置
	//Vector positions[4];
	// テクスチャ座用
	//Vector texCoords[4];
}
-(BOOL)initGLView;
-(void)drawView:(id)sender;
-(void)drawMain;
//-(void)drawSaveButton;
@end


@implementation GLView
@synthesize context = _context;
@synthesize diplayLink = _diplayLink;
@synthesize shader = _shader;


+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        // Initialization code
        self.shader = [[Shader alloc] init];

        if ([self initGLView] == FALSE)
            return nil;
    }
    return self;
}


- (BOOL)initGLView
{
    // Get the layer
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    eaglLayer.opaque = TRUE;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:FALSE],
                                    kEAGLDrawablePropertyRetainedBacking,
                                    kEAGLColorFormatRGBA8,
                                    kEAGLDrawablePropertyColorFormat, nil];
    // コンテキストを取得
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context || ![EAGLContext setCurrentContext:self.context])
    {
        return nil;
    }
    
    glGenFramebuffers (1, &defaultFramebuffer);CHECK_GL_ERROR ();
    glGenRenderbuffers (1, &colorRenderbuffer);CHECK_GL_ERROR ();
    glBindFramebuffer (GL_FRAMEBUFFER, defaultFramebuffer);CHECK_GL_ERROR ();
    glBindRenderbuffer (GL_RENDERBUFFER, colorRenderbuffer);CHECK_GL_ERROR ();
    glFramebufferRenderbuffer (GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, 
                               GL_RENDERBUFFER, colorRenderbuffer);CHECK_GL_ERROR ();

    
    /*
    // prepare Layer
    CAEAGLLayer* eaglLayer = (CAEAGLLayer*)self.layer;
    eaglLayer.opaque = NO;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:NO],
                                    kEAGLDrawablePropertyRetainedBacking, 
                                    kEAGLColorFormatRGBA8, 
                                    kEAGLDrawablePropertyColorFormat, 
                                    nil];
    
    // Create OpenGL context
    self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:self.context];

    // Create Framebuffer
    glGenFramebuffersOES(1, &defaultFramebuffer);
    glGenRenderbuffersOES(1, &colorRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [self.context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
     */
    
    return TRUE;
}

-(void)startAnimation
{
    // To enable displaylink
    self.diplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
    [self.diplayLink setFrameInterval:1];
    [self.diplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)stopAnimation
{
    // To unable displaylink
    [self.diplayLink invalidate];
    self.diplayLink = nil;
}

-(void)drawView:(id)sender
{
    /*
    if ([EAGLContext currentContext] != self.context)
        [EAGLContext setCurrentContext:self.context];

    // Setting to OpenGL
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    
    // Clear color buffer;
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Setting to projection
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, 0, 10.0f);
    
    // Setting to modelview
    glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
    
    // To enable OpenGL state
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    // Draw buffer
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, defaultFramebuffer);
    [self.context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
    // To unnable OpenGL state
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
     */
    
    
    if ([EAGLContext currentContext] != self.context)
        [EAGLContext setCurrentContext:self.context];
    
    // Setting to OpenGL
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    
    // Clear color buffer;
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
	//[self drawMain];
    
    //[self.shader drawArraysMy:defaultFramebuffer];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];


	//[self drawFps];
	//glFlush();CHECK_GL_ERROR();
	// バックバッファをフロントバッファへ
    
	//glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);CHECK_GL_ERROR();
	[self.context presentRenderbuffer:GL_RENDERBUFFER];
}

/*
- (void)drawMain
{
    GLchar *vertexShader = 
	"attribute vec4 vertexPosition;   \n"
	"void main()                 \n"
	"{                           \n"
	"    gl_Position = vertexPosition; \n"
	"}                           \n";
    
	GLchar *fragmentShader = 
	"precision mediump float;                  \n"
	"void main()                               \n"
	"{                                         \n"
	"    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0); \n"
	"}                                         \n"; 
 
    
    [self.shader drawArraysMy:defaultFramebuffer];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}*/


// 描画
-(void)drawMain 
{
    /*
    
	// 色の計算
	double time = [NSDate timeIntervalSinceReferenceDate];
	float alpha = (float)((sin(M_PI * time / 2.0) + 1.0) / 2.0);
	//Color color;
	//color.setHue((float)fmod(time / 8.0, 1.0) * 360.f, 1.f);
    
	// 位置
	float w = fminf(self.width, self.height);
	positions[0] = Vector(0, 0);
	positions[1] = Vector(w, 0);
	positions[2] = Vector(0, w);
	positions[3] = Vector(w, w);
	// テクスチャ座標
	texCoords[0] = Vector(0,0);
	texCoords[1] = Vector(1,0);
	texCoords[2] = Vector(0,1);
	texCoords[3] = Vector(1,1);		
	//[self.shader drawArraysMy:GL_TRIANGLE_STRIP positions:(float*)positions texCoords:(float*)texCoords count:4 alpha:alpha];
     */
}



-(UIImage*)glToUIImage
{
    NSInteger myDataLength = 320 * 480 * 4;
    
    // allocate array and read pixels into it.
    GLubyte* buffer = (GLubyte*) malloc(myDataLength);
    glReadPixels(0, 0, 320, 480, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte* buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y < 480; y++)
    {
        for(int x = 0; x < 320 * 4; x++)
            buffer2[(479 - y) * 320 * 4 + x] = buffer[y * 4 * 320 + x];
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * 320;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(320, 480, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage* myImage = [UIImage imageWithCGImage:imageRef];
    return myImage;
}


- (UIImage *)getImage 
{
	size_t w = [self frame].size.width;
	size_t h = [self frame].size.height;
	int pixelCount = 4 * w * h;
	GLubyte* data = (GLubyte*)malloc(pixelCount * sizeof(GLubyte));
	glReadPixels(0, 0, w, h, GL_RGBA, GL_UNSIGNED_BYTE, data);
	
	CGColorSpaceRef space =  CGColorSpaceCreateDeviceRGB();
	CGContextRef ctx = CGBitmapContextCreate(data, w, h, 8, w * 4, space, kCGImageAlphaPremultipliedLast);
	CGImageRef img = CGBitmapContextCreateImage(ctx);
	
	UIGraphicsBeginImageContext([[UIScreen mainScreen] bounds].size); //保存用サイズのコンテキストを作成

    CGContextDrawImage (UIGraphicsGetCurrentContext(), CGRectMake(0, 20, w, h), img);
    CGContextRotateCTM (UIGraphicsGetCurrentContext(), M_PI); //回転
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(ctx);
	CGColorSpaceRelease(space);
	CGImageRelease(img);
	UIGraphicsEndImageContext();
	free(data);
	return result;
}

- (void) imagePickerController:(UIImagePickerController*) picker
 didFinishPickingMediaWithInfo:(NSDictionary*) info
{
  	[self  stopAnimation];
    
    UIImage* result = [info objectForKey:UIImagePickerControllerOriginalImage];

	size_t w = [self frame].size.width;
	size_t h = [self frame].size.height;
	int pixelCount = 4 * w * h;
	GLubyte* data = (GLubyte*)malloc(pixelCount * sizeof(GLubyte));
	glReadPixels(0, 0, w, h, GL_RGBA, GL_UNSIGNED_BYTE, data);
	
	CGColorSpaceRef space =  CGColorSpaceCreateDeviceRGB();
	CGContextRef ctx = CGBitmapContextCreate(data, w, h, 8, w * 4, space, kCGImageAlphaPremultipliedLast);
	CGImageRef img = CGBitmapContextCreateImage(ctx);
	
	UIGraphicsBeginImageContext([[UIScreen mainScreen] bounds].size); //保存用サイズのコンテキストを作成
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 20, w, h), img);
    CGContextRotateCTM(UIGraphicsGetCurrentContext(), M_PI); //回転
    //UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(ctx);
	CGColorSpaceRelease(space);
	CGImageRelease(img);
	UIGraphicsEndImageContext();
	free(data);
    
    UIImageWriteToSavedPhotosAlbum(result, self, @selector(image:didFinishSavingWithError:contextInfo:), nil); // add callback for finish saving
}


-(void)captureToPhotoAlbum
{
    UIImage *image = [self glToUIImage];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo 
{
	UIAlertView* alert;
	if (!error) 
		alert = [[UIAlertView alloc] initWithTitle:@"The image did saved." message:@"Please check your camera roll." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	else
		alert = [[UIAlertView alloc] initWithTitle:[error domain] message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];

	[alert show];
	[self startAnimation];
}

-(void)changeFilter
{
    glClearColor(0.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glEnable(GL_ALPHA);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
