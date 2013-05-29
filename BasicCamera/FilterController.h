//
//  FilterController.h
//  BasicCamera
//
//  Created by 哲太郎 村上 on 12/07/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@interface FilterController : NSObject
@property (strong,nonatomic)UIImage *originalImage;
@property (strong,nonatomic)UIImageView *imageView;
@property (strong,nonatomic)CIImage *ciImage;


- (id)initWithImage:(UIImage *)image AndView:(UIImageView *)view;

+ (CIImage *)sepia:(CIImage*)ciImage Level:(float)level;
+ (CIImage *)monoChrome:(CIImage*)ciImage Color:(CIColor *)color Level:(float)level;
+ (CIImage *)vignette:(CIImage*)ciImage Intensity:(float)intensity Radius:(float)radius;
+ (CIImage *)colorControl:(CIImage *)ciImage Saturation:(float)saturation Brightness:(float)brightness Contrast:(float)contrast;

+ (UIImage *)convertCtoU:(CIImage *)cImage;
+ (CIColor *)hexToUIColor:(NSString *)hex alpha:(CGFloat)a;
+ (CIColor *)hexToUIColor:(NSString *)hex;

- (void)doOrigin;
- (void)doSepia:(float)level;
- (void)doMonoChrome;
- (void)doPro;
- (void)doColorControl;
- (void)doRadialGradient;
- (void)doCountory;
- (void)doVignette;
- (void)doVibrance;
- (void)doHueAdjust:(float)level;
- (void)doDiana;
- (void)doBurnBlend;
- (void)doAmaro;


@end
