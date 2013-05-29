//
//  SimpleOpenGL.m
//  BasicCamera
//
//  Created by Keiichiro Nagashima on 12/07/27.
//
//

#import "SimpleOpenGLView.h"

@implementation SimpleOpenGL

@synthesize programObject = _programObject;
@synthesize context = _context;
@synthesize diplayLink = _diplayLink;
@synthesize error = _error;

+ (Class)layerClass
{
    return  [CAEAGLLayer class];
}


- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self)
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
        
        if ([self initGL] == 0)
        {
            assert(false);
            return nil;
        }
        
        //glGetRenderbufferParameteriv (GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &bufferWidth);CHECK_GL_ERROR ();
        //glGetRenderbufferParameteriv (GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &bufferHeight);CHECK_GL_ERROR ();
    }
    return self;
}



- (GLuint)LoadShader:(GLenum)type src:(const char*)shaderSrc
{
    GLuint shader;
    GLint compiled;
    
    // シェーダオブジェクトの生成
    shader = glCreateShader (type);CHECK_GL_ERROR()
    
    if (shader == 0)
        return 0;
    
    // シェーダソースをロードする
    glShaderSource (shader, 1, &shaderSrc, NULL);CHECK_GL_ERROR()

    // シェーダをコンパイルする
    glCompileShader (shader);CHECK_GL_ERROR()
    
    
    // コンパイル結果をチェックする
    glGetShaderiv (shader, GL_COMPILE_STATUS, &compiled);CHECK_GL_ERROR()
    if (!compiled)
    {
        GLint infoLen = 0;
        glGetShaderiv (shader, GL_INFO_LOG_LENGTH, &infoLen);CHECK_GL_ERROR()

        NSString* name = @"";
        if (type == GL_VERTEX_SHADER)
            name = @"Vertex Shader";
        else if (type == GL_FRAGMENT_SHADER)
            name = @"Fragment Shader";
        if (infoLen > 0)
        {
            char* infoLog = (char*)malloc (sizeof(char)*infoLen);
            glGetShaderInfoLog (shader, infoLen, NULL, infoLog);CHECK_GL_ERROR ();
            self.error = [NSString stringWithFormat:@"Compile Error:%@:\n%@", name, [NSString stringWithUTF8String:infoLog]];
            free (infoLog);
        }
        else
        {
            self.error = [NSString stringWithFormat:@"Compile Error: %@:Unknown", name];
        }

        debug_log (@"%@", self.error);
        
        glDeleteShader(shader);CHECK_GL_ERROR()
        return 0;
    }
    return shader;
}

- (int) initGL
{
    //UserData* userData = esContext userData;
    
    GLchar *vShaderStr =
	"attribute vec4 vertexPosition;   \n"
	"void main()                 \n"
	"{                           \n"
	"    gl_Position = vertexPosition; \n"
	"}                           \n";
    
	GLchar *fShaderStr =
	"precision mediump float;                  \n"
	"void main()                               \n"
	"{                                         \n"
	"    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0); \n"
	"}                                         \n";

    GLuint vertexShader;
    GLuint fragmentShader;
    //GLuint programObject;
    GLint linked;

    // 頂点／フラグメントシェーダをロード
    vertexShader = [self LoadShader:GL_VERTEX_SHADER src:vShaderStr];
    fragmentShader = [self LoadShader:GL_FRAGMENT_SHADER src:fShaderStr];
    
    // プログラムオブジェクトを作成する
    self.programObject = glCreateProgram();CHECK_GL_ERROR()
    if (self.programObject == 0)
        return 0;
    
    glAttachShader(self.programObject, vertexShader);CHECK_GL_ERROR()
    glAttachShader(self.programObject, fragmentShader);CHECK_GL_ERROR()
    
    
    // vPosiontを属性0にバインドする
    glBindAttribLocation(self.programObject, 0, "vPosition");CHECK_GL_ERROR()
    
    // プログラムオブジェクトにリンクする
    glLinkProgram(self.programObject);CHECK_GL_ERROR()
    
    // リンク結果をチェックする
    glGetProgramiv(self.programObject, GL_LINK_STATUS, &linked);CHECK_GL_ERROR()
    
    if (!linked)
    {
        GLint infoLen = 0;
        glGetProgramiv (self.programObject, GL_INFO_LOG_LENGTH, &infoLen);CHECK_GL_ERROR()
        
        if (infoLen > 0)
        {
            char* infoLog = (char*)malloc (sizeof (char)*infoLen);
            glGetProgramInfoLog(self.programObject, infoLen, NULL, infoLog);
            self.error = [NSString stringWithFormat:@"Link Error:%@", [NSString stringWithUTF8String:infoLog]];
            free (infoLog);
        }
        else
        {
            self.error = @"Link Error: unkown";
        }
        
        debug_log (@"%@", self.error);
        glDeleteProgram(self.programObject);CHECK_GL_ERROR()
        return 0;
    }
    
    glClearColor(0.0f, 0.0f, 0.0, 1.0f);CHECK_GL_ERROR()
    return 1;
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
    GLfloat vVerticle[] = {
        0.0f, 0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f
    };
    
    [EAGLContext setCurrentContext:self.context];
    
    // ビューポートの設定
  	//glViewport(100, 100, 50, 50);CHECK_GL_ERROR()
    //glViewport(0, 0, bufferWidth, bufferHeight);CHECK_GL_ERROR()
    
    // カラーバッファをクリア
    glClear(GL_COLOR_BUFFER_BIT);CHECK_GL_ERROR()
    
    // プログラムオブジェクトを使用する
    glUseProgram(self.programObject);CHECK_GL_ERROR()
    
    // 頂点データをロードする
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, vVerticle);CHECK_GL_ERROR()
    glEnableVertexAttribArray(0);CHECK_GL_ERROR()
    glDrawArrays(GL_TRIANGLES, 0, 3);CHECK_GL_ERROR()
  	glFlush();CHECK_GL_ERROR();
	[self.context presentRenderbuffer:GL_RENDERBUFFER];
}
@end
