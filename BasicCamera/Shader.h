//
//  Shader.h
//  BasicCamera
//
//  Created by k16 on 12/07/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Shader : NSObject

// GLプログラムID
@property uint programId;
//頂点シェーダーソース
@property(strong, nonatomic) NSString* vertexShader;
//フラグメントシェーダーソース
@property(strong, nonatomic) NSString* fragmentShader;
//ビルドエラー
@property(strong, nonatomic) NSString* error;



- (id)init;
// GLでカレントプログラムに指定
-(void)use;
// プログラム削除
-(void)deleteProgram;

-(NSString*)build:(NSString*)vshSrc fsh:(NSString*)fshSrc 
            attributeVariables:(NSArray*)att uniformVariables:(NSArray*)uniforms;


// 頂点属性データを設定（float x,float yの配列)
-(void)setVertexAttribute2f:(float*)positions at:(uint)indexOfMember;
// 整数のユニフォーム変数設定
-(void)setUniformInteger:(int)value at:(int)idx;
// floatのユニフォーム変数設定
-(void)setUniformFloat:(float)value at:(int)idx;
// カラーのユニフォーム変数設定
//-(void)setUniformColor:(Color)color at:(int)idx;
// 4x4行列設定
-(void)setUniformMatrix:(const float*)mat44 at:(int)idx;
// 描画ローレベル
-(void)drawArraysNative:(uint)primitive count:(int)count;


@end
