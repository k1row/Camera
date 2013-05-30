//
//  Shader.m
//  BasicCamera
//
//  Created by Keiichiro Nagashima on 12/07/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Shader.h"
#import "GLUtil.h"


@interface Shader ()
{
    // ユニフォーム変数位置配列
    int* uniformLocations;
}

-(uint)compileShader:(uint)type source:(NSString*)source;
-(BOOL)linkProgram:(uint)vShader fShader:(uint)fShader;
@end


@implementation Shader
@synthesize vertexShader = _vertexShader;
@synthesize fragmentShader = _fragmentShader;
@synthesize error = _error;
@synthesize programId = _programId;


enum VertexAttribute {
	VA_POSITION,
	VA_TEXCOORD,
};


enum UniformLocation {
	UL_MATRIX,
	UL_TEXTURE,
	UL_COLOR,
	UL_ALPHA,
};


- (id)init 
{
    self = [super init];
    if (self)
    {
		self.programId = 0;
		uniformLocations = nil;        
	}
	return self;
}

// GLでカレントプログラムに指定
-(void)use 
{
	assert(self.programId);//ビルドされていない
	glUseProgram(self.programId);
}

// ビルド。戻り値はエラーメッセージ。成功のときはnil。
-(NSString*)build:(NSString*)vshSrc fsh:(NSString*)fshSrc 
attributeVariables:(NSArray*)att uniformVariables:(NSArray*)uniforms 
{
	assert(fshSrc);
	assert(vshSrc);
	assert(att);
    
	[self deleteProgram];
	self.error = @"";
	self.programId = glCreateProgram();CHECK_GL_ERROR ();
	self.vertexShader = vshSrc;
	self.fragmentShader = fshSrc;

    
    // 頂点シェーダのコンパイル
    uint vShader = [self compileShader:GL_VERTEX_SHADER source:self.vertexShader];
    if (vShader == 0)
    {
        [self deleteProgram];
        return self.error;
    }
    // フラグメントシェーダのコンパイル
    uint fShader = [self compileShader:GL_FRAGMENT_SHADER source:self.fragmentShader];
    if (fShader == 0)
    {
        [self deleteProgram];
        return self.error;
    }
    
    // アトリビュート変数（頂点フォーマットメンバ）の設定
    for (int i = 0; i < att.count; i++)
    {
        NSString* name = [att objectAtIndex:i];
        glBindAttribLocation (self.programId, i, [name UTF8String]);CHECK_GL_ERROR ();
    }
    
	
    // リンク
    BOOL link = [self linkProgram:vShader fShader:fShader];
    if (link == NO)
    {
        [self deleteProgram];
        return self.error;
    }

    // ユニフォーム変数の位置を取得
    NSMutableString* err = nil;
    uniformLocations = (int*)malloc (uniforms.count * sizeof (int));
    for (int i = 0; i < uniforms.count; i++)
    {
        NSString* name = [uniforms objectAtIndex:i];
        uniformLocations[i] = glGetUniformLocation (self.programId, [name UTF8String]);CHECK_GL_ERROR ();
        if (uniformLocations[i] < 0)
        {
            if (err == nil)
                err = [[NSMutableString alloc] initWithString:@"Uniform Error:\n"];
            
            [err appendFormat:@"Can't find uniform variable '%@'.\n", name];
        }
    }
    if (err) // Can't find uniform variable
    {
        debug_log (@"%@", err);
        self.error = err;
        return nil;
    }
    
    return nil;
}


-(uint)compileShader:(uint)type source:(NSString*)source
{
    int compiled;
    
    uint shader = glCreateShader (type);CHECK_GL_ERROR ();
    if (shader == GL_FALSE)
    {
        assert (false);
        return 0;
    }

    const char* src = [source UTF8String];
    glShaderSource (shader, 1, &src, NULL);CHECK_GL_ERROR ();
    glCompileShader (shader);CHECK_GL_ERROR ();
    glGetShaderiv (shader, GL_COMPILE_STATUS, &compiled);CHECK_GL_ERROR ();
    
    if (!compiled) // compile error
    {
        NSString* name = @"";
        if (type == GL_VERTEX_SHADER)
            name = @"Vertex Shader";
        else if (type == GL_FRAGMENT_SHADER)
            name = @"Fragment Shader";
        
        GLint infoLen = 0;
        glGetShaderiv (shader, GL_INFO_LOG_LENGTH, &infoLen);CHECK_GL_ERROR ();
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
        glDeleteShader (shader);CHECK_GL_ERROR ();
        [self deleteProgram];
        debug_log (@"%@", self.error);
        return 0;
    }
    return shader;
}

// シェーダをリンクしてプログラムをセットアップ
-(BOOL)linkProgram:(uint)vShader fShader:(uint)fShader
{
    glAttachShader (self.programId, vShader);CHECK_GL_ERROR ();
    glAttachShader (self.programId, fShader);CHECK_GL_ERROR ();
    
    glLinkProgram (self.programId);CHECK_GL_ERROR ();
    
    GLint linked;
    glGetProgramiv (self.programId, GL_LINK_STATUS, &linked);
    if (!linked)
    {
   		GLint infoLen=0;
        if (infoLen > 0)
        {
            char* infoLog = (char*)malloc (sizeof (char)*infoLen);
            glGetProgramInfoLog (self.programId, infoLen, NULL, infoLog);CHECK_GL_ERROR ();
            self.error = [NSString stringWithFormat:@"Link Error:%@", [NSString stringWithUTF8String:infoLog]];
            free (infoLog);
        }
        else 
        {
            self.error = @"Link Error: unkown";
        }
        glDetachShader (self.programId, vShader);CHECK_GL_ERROR ();
        glDetachShader (self.programId, fShader);CHECK_GL_ERROR ();
        glDeleteShader (vShader);CHECK_GL_ERROR ();
        glDeleteShader (fShader);CHECK_GL_ERROR ();
        [self deleteProgram];
        debug_log (@"%@", self.error);
        return false;
    }
    
    // リンク成功の時
    glDetachShader (self.programId, vShader);CHECK_GL_ERROR ();
    glDetachShader (self.programId, fShader);CHECK_GL_ERROR ();
    glDeleteShader (vShader);CHECK_GL_ERROR ();
    glDeleteShader (fShader);CHECK_GL_ERROR ();
    return true;
}

// プログラム削除
-(void)deleteProgram 
{
	if(self.programId)
    {
		glDeleteProgram(self.programId);
		self.programId = 0;
	}
	free (uniformLocations);
	uniformLocations = nil;
}


// 頂点属性データを設定（float x,float yの配列)
-(void)setVertexAttribute2f:(float*)positions at:(uint)indexOfMember {
	glEnableVertexAttribArray(indexOfMember);CHECK_GL_ERROR();
	glVertexAttribPointer(indexOfMember, 2, GL_FLOAT, false, 0, positions);CHECK_GL_ERROR();
}

// 整数のユニフォーム変数設定
-(void)setUniformInteger:(int)value at:(int)idx {
	assert(self.programId);//ビルドは成功していなければならない
	glUniform1i(uniformLocations[idx], value);CHECK_GL_ERROR();
}

// floatのユニフォーム変数設定
-(void)setUniformFloat:(float)value at:(int)idx {
	assert(self.programId);//ビルドは成功していなければならない
	glUniform1f(uniformLocations[idx], value);CHECK_GL_ERROR();
}

/*
// カラーのユニフォーム変数設定
-(void)setUniformColor:(Color)color at:(int)idx {
	assert(self.programId);//ビルドは成功していなければならない
	glUniform4f(uniformLocations[idx], color.r, color.g, color.b, color.a);CHECK_GL_ERROR();
}
 */

// 4x4行列設定
-(void)setUniformMatrix:(const float*)mat44 at:(int)idx {
	assert(self.programId);//ビルドは成功していなければならない
	glUniformMatrix4fv(uniformLocations[idx], 1, FALSE, mat44);CHECK_GL_ERROR();
}

// 描画ローレベル
-(void)drawArraysNative:(uint)primitive count:(int)count {
	assert(self.programId);//ビルドは成功していなければならない
	glDrawArrays(primitive, 0, count);
}

@end
