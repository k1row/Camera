//
//  FilterController.m
//  BasicCamera
//
//  Created by 哲太郎 村上 on 12/07/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FilterController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FilterController
@synthesize originalImage = _originalImage;
@synthesize imageView = _imageView;
@synthesize ciImage = _ciImage;


- (id)initWithImage:(UIImage *)image AndView:(UIImageView *)view
{
    if (self = [super init]) {
        
        self.imageView = view;
        
        _originalImage = image;
        _ciImage = [[CIImage alloc] initWithCGImage:_originalImage.CGImage options:nil];
        
    }
        
    return self;
}



//Filter


- (void)doOrigin
{
    LOG_FUNC
    
    self.imageView.image = _originalImage;
    
}

- (void)doSepia:(float)level 
{
    LOG_FUNC
    
    NSOperationQueue *queue = 
    [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView  *ai =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    ai.frame  = ccr(0,0,100,100);
    ai.center = CGPointMake(self.imageView.width/2, self.imageView.height/2);
    
    [self.imageView addSubview:ai];
    [ai startAnimating];
    
    [queue addOperationWithBlock:^{
        
        CIImage *ciImage = _ciImage;
        LOG(@"ciImage: %@",ciImage);
        
        ciImage = [FilterController sepia:ciImage Level:level];
        
        CIContext *ciContext = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = 
        [ciContext createCGImage:ciImage fromRect:ciImage.extent];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        NSOperationQueue *mainQueue = 
        [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            self.imageView.alpha = 0.2;
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.imageView.image = uiImage;
                                 self.imageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 CGImageRelease(cgImage);
                                 [ai stopAnimating];
                             }];
            
        }];
    }];
    
}

- (void)doMonoChrome
{
    LOG_FUNC
    
    NSOperationQueue *queue = 
    [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView  *ai =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    ai.frame  = ccr(0,0,100,100);
    ai.center = CGPointMake(self.imageView.width/2, self.imageView.height/2);
    
    [self.imageView addSubview:ai];
    [ai startAnimating];
    
    [queue addOperationWithBlock:^{
        
        CIImage *ciImage = _ciImage;
        LOG(@"ciImage: %@",ciImage);
        
        ciImage = [FilterController monoChrome:ciImage Color:[CIColor colorWithRed:0.75 green:0.75 blue:0.75] Level:1];
        
        CIContext *ciContext = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = 
        [ciContext createCGImage:ciImage fromRect:ciImage.extent];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        NSOperationQueue *mainQueue = 
        [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            self.imageView.alpha = 0.2;
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.imageView.image = uiImage;
                                 self.imageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 CGImageRelease(cgImage);
                                 [ai stopAnimating];
                             }];
            
        }];
    }];
    
}

- (void)doPro  
{
    LOG_FUNC
    NSOperationQueue *queue = 
    [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView  *ai =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    ai.frame  = ccr(0,0,100,100);
    ai.center = CGPointMake(self.imageView.width/2, self.imageView.height/2);
    
    [self.imageView addSubview:ai];
    [ai startAnimating];
    
    [queue addOperationWithBlock:^{
        
        CIImage *ciImage = _ciImage;
        LOG(@"ciImage: %@",ciImage);
        
        
        

        ciImage =[FilterController colorControl:ciImage Saturation:1.0 Brightness:0.0 Contrast:1.4];
        ciImage =[FilterController vignette:ciImage Intensity:1 Radius:1];
        
        CIContext *ciContext = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = 
        [ciContext createCGImage:ciImage fromRect:ciImage.extent];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        NSOperationQueue *mainQueue = 
        [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            self.imageView.alpha = 0.2;
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.imageView.image = uiImage;
                                 self.imageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 CGImageRelease(cgImage);
                                 [ai stopAnimating];
                             }];
            
        }];
    }];
    
}

- (void)doColorControl
{
    LOG_FUNC
    
    NSOperationQueue *queue = 
    [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView  *ai =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    ai.frame  = ccr(0,0,100,100);
    ai.center = CGPointMake(self.imageView.width/2, self.imageView.height/2);
    
    [self.imageView addSubview:ai];
    [ai startAnimating];
    
    [queue addOperationWithBlock:^{
        CIImage *ciImage = _ciImage;
        
        LOG(@"ciImage: %@",ciImage);
        
        
        CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
        [filter setDefaults];
        LOG(@"inputKeyrs = %@", filter.inputKeys);
        
        [filter setValue:[NSNumber numberWithFloat:2.0] forKey:@"inputSaturation"];
        [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputBrightness"];
        [filter setValue:[NSNumber numberWithFloat:3.0] forKey:@"inputContrast"];
        [filter setValue:ciImage forKey:@"inputImage"];
        ciImage = filter.outputImage;
        
        CIContext *ciContext = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = 
        [ciContext createCGImage:ciImage fromRect:ciImage.extent];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        NSOperationQueue *mainQueue = 
        [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            self.imageView.alpha = 0.2;
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.imageView.image = uiImage;
                                 self.imageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 CGImageRelease(cgImage);
                                 [ai stopAnimating];
                             }];
            
        }];
    }];
    
}

- (void)doRadialGradient
{
    LOG_FUNC
    
    NSOperationQueue *queue = 
    [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView  *ai =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    ai.frame  = ccr(0,0,100,100);
    ai.center = CGPointMake(self.imageView.width/2, self.imageView.height/2);
    
    [self.imageView addSubview:ai];
    [ai startAnimating];
    
    [queue addOperationWithBlock:^{
        CIImage *ciImage = _ciImage;
        
        LOG(@"ciImage: %@",ciImage);
        
        
        CIFilter *filter = [CIFilter filterWithName:@"CIRadialGradient"];
        [filter setDefaults];
        LOG(@"inputKeyrs = %@", filter.inputKeys);
        
        [filter setValue:[CIVector vectorWithX:self.originalImage.size.width/2 Y:self.originalImage.size.height/2 ]  forKey:@"inputCenter"];
        [filter setValue:[NSNumber numberWithFloat:self.originalImage.size.width/2] forKey:@"inputRadius0"];
        [filter setValue:[NSNumber numberWithFloat:0] forKey:@"inputRadius1"];
        [filter setValue:[CIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.0] forKey:@"inputColor0"];
        [filter setValue:[CIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0] forKey:@"inputColor1"];
        CIImage *gaussImage = filter.outputImage;
        
        [FilterController convertCtoU:gaussImage];
        [FilterController convertCtoU:ciImage];
        
        CIFilter *sourceOver = [CIFilter filterWithName:@"CISourceOverCompositing"];
        [sourceOver setDefaults];
        [sourceOver setValue:ciImage forKey:@"inputBackgroundImage"];
        [sourceOver setValue:gaussImage forKey:@"inputImage"];
        LOG(@"inputKeyrs = %@", sourceOver.inputKeys);
        
        ciImage = sourceOver.outputImage;
        
        UIImage *uiImage = [FilterController convertCtoU:ciImage];
    
        NSOperationQueue *mainQueue = 
        [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            self.imageView.alpha = 0.2;
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.imageView.image = uiImage;
                                 self.imageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                              //   CGImageRelease(cgImage);
                                 [ai stopAnimating];
                             }];
            
        }];
    }];
}

- (void)doCountory
{
    LOG_FUNC
    
    NSOperationQueue *queue = 
    [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView  *ai =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    ai.frame  = ccr(0,0,100,100);
    ai.center = CGPointMake(self.imageView.width/2, self.imageView.height/2);
    
    [self.imageView addSubview:ai];
    [ai startAnimating];
    
    [queue addOperationWithBlock:^{
        
        CIImage *ciImage = _ciImage;
        
        
        ciImage =[FilterController colorControl:ciImage Saturation:0.7 Brightness:0.0 Contrast:1.6];
        ciImage =[FilterController vignette:ciImage Intensity:1 Radius:2];
        
        CIColor *col = [FilterController hexToUIColor:@"ffd700"];
        ciImage =[FilterController monoChrome:ciImage Color:col Level:0.4];
        
        
        CIContext *ciContext = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = 
        [ciContext createCGImage:ciImage fromRect:ciImage.extent];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        NSOperationQueue *mainQueue = 
        [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            self.imageView.alpha = 0.2;
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.imageView.image = uiImage;
                                 self.imageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 CGImageRelease(cgImage);
                                 [ai stopAnimating];
                             }];
            
        }];
    }];
    
}

- (void)doVignette
{
    LOG_FUNC
    
    NSOperationQueue *queue = 
    [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView  *ai =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    ai.frame  = ccr(0,0,100,100);
    ai.center = CGPointMake(self.imageView.width/2, self.imageView.height/2);
    
    [self.imageView addSubview:ai];
    [ai startAnimating];
    
    [queue addOperationWithBlock:^{
        
        CIImage *ciImage = _ciImage;
        
        
        CIFilter *filter = [CIFilter filterWithName:@"CIVignette"]; 
        [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
        [filter setValue:[NSNumber numberWithFloat:2.0] forKey:@"inputRadius"];
        [filter setValue:ciImage forKey:@"inputImage"];
        ciImage = filter.outputImage;
        
        
        CIContext *ciContext = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = 
        [ciContext createCGImage:ciImage fromRect:ciImage.extent];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        NSOperationQueue *mainQueue = 
        [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            self.imageView.alpha = 0.2;
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.imageView.image = uiImage;
                                 self.imageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 CGImageRelease(cgImage);
                                 [ai stopAnimating];
                             }];
            
        }];
    }];
}

- (void)doVibrance
{
    LOG_FUNC
    
    NSOperationQueue *queue = 
    [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView  *ai =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    ai.frame  = ccr(0,0,100,100);
    ai.center = CGPointMake(self.imageView.width/2, self.imageView.height/2);
    
    [self.imageView addSubview:ai];
    [ai startAnimating];
    
    [queue addOperationWithBlock:^{
        
        CIImage *ciImage = _ciImage;
        
        
        CIFilter *filter = [CIFilter filterWithName:@"CIVibrance"]; 
        [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputAmount"];
        [filter setValue:ciImage forKey:@"inputImage"];
        ciImage = filter.outputImage;
        
        
        CIContext *ciContext = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = 
        [ciContext createCGImage:ciImage fromRect:ciImage.extent];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        NSOperationQueue *mainQueue = 
        [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            self.imageView.alpha = 0.2;
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.imageView.image = uiImage;
                                 self.imageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 CGImageRelease(cgImage);
                                 [ai stopAnimating];
                             }];
            
        }];
    }];
}

- (void)doHueAdjust:(float)level
{
    LOG_FUNC
    
    NSOperationQueue *queue = 
    [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView  *ai =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    ai.frame  = ccr(0,0,100,100);
    ai.center = CGPointMake(self.imageView.width/2, self.imageView.height/2);
    
    [self.imageView addSubview:ai];
    [ai startAnimating];
    
    [queue addOperationWithBlock:^{
        
        CIImage *ciImage = _ciImage;
        
        
        CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"]; 
        [filter setValue:[NSNumber numberWithFloat:level] forKey:@"inputAngle"];
        [filter setValue:ciImage forKey:@"inputImage"];
        ciImage = filter.outputImage;
        
        
        CIContext *ciContext = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = 
        [ciContext createCGImage:ciImage fromRect:ciImage.extent];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        NSOperationQueue *mainQueue = 
        [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            self.imageView.alpha = 0.2;
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.imageView.image = uiImage;
                                 self.imageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 CGImageRelease(cgImage);
                                 [ai stopAnimating];
                             }];
            
        }];
    }];
}



- (void)doDiana
{
    NSOperationQueue *queue = 
    [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView  *ai =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    ai.frame  = ccr(0,0,100,100);
    ai.center = CGPointMake(self.imageView.width/2, self.imageView.height/2);
    
    [self.imageView addSubview:ai];
    [ai startAnimating];
    
    [queue addOperationWithBlock:^{
        
        CIImage *ciImage = _ciImage;

        /*
         下地に関係なく黄色フィルタをようい
         はじっこをくらくする
         コントラストをあげる
         */
        
        ciImage =[FilterController colorControl:ciImage Saturation:0.7 Brightness:0.0 Contrast:1.3];
        ciImage =[FilterController vignette:ciImage Intensity:1 Radius:1];
        
        CIColor *col = [FilterController hexToUIColor:@"ffd700"];
        ciImage =[FilterController monoChrome:ciImage Color:col Level:0.3];
        
        
        CIContext *ciContext = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = 
        [ciContext createCGImage:ciImage fromRect:ciImage.extent];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        NSOperationQueue *mainQueue = 
        [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            self.imageView.alpha = 0.2;
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.imageView.image = uiImage;
                                 self.imageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 CGImageRelease(cgImage);
                                 [ai stopAnimating];
                             }];
            
        }];
    }];
    
    
}

- (void)doBurnBlend
{
    NSOperationQueue *queue = 
    [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView  *ai =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    ai.frame  = ccr(0,0,100,100);
    ai.center = CGPointMake(self.imageView.width/2, self.imageView.height/2);
    
    [self.imageView addSubview:ai];
    [ai startAnimating];
    
    [queue addOperationWithBlock:^{
        
        CIImage *ciImage = _ciImage;
        
        
        ciImage = [FilterController monoChrome:ciImage Color:[CIColor colorWithRed:0.6 green:0.75 blue:0.6] Level:0.5];
        LOG(@"ciImage: %@",ciImage);
        
        
        
        
        
        CIContext *ciContext = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = 
        [ciContext createCGImage:ciImage fromRect:ciImage.extent];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        NSOperationQueue *mainQueue = 
        [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            self.imageView.alpha = 0.2;
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.imageView.image = uiImage;
                                 self.imageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 CGImageRelease(cgImage);
                                 [ai stopAnimating];
                             }];
            
        }];
    }];
    
    
}

- (void)doAmaro
{

    
    NSOperationQueue *queue = 
    [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView  *ai =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    ai.frame  = ccr(0,0,100,100);
    ai.center = CGPointMake(self.imageView.width/2, self.imageView.height/2);
    
    [self.imageView addSubview:ai];
    [ai startAnimating];
    
    [queue addOperationWithBlock:^{
        
        CIImage *ciImage = _ciImage;
        
        ciImage =[FilterController colorControl:ciImage Saturation:1.0 Brightness:0.25 Contrast:1.6];
        ciImage =[FilterController vignette:ciImage Intensity:1 Radius:0.8];
        
        CIColor *col = [FilterController hexToUIColor:@"B07E9F"];
        ciImage =[FilterController monoChrome:ciImage Color:col Level:0.3];
        
        CIContext *ciContext = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = 
        [ciContext createCGImage:ciImage fromRect:ciImage.extent];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        NSOperationQueue *mainQueue = 
        [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            self.imageView.alpha = 0.2;
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.imageView.image = uiImage;
                                 self.imageView.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 CGImageRelease(cgImage);
                                 [ai stopAnimating];
                             }];
            
        }];
    }];
    

}

#pragma utill
+ (CIImage *)sepia:(CIImage*)ciImage Level:(float)level
{
    LOG_FUNC
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setDefaults];
    LOG(@"inputKeyrs = %@", filter.inputKeys);
    [filter setValue:[NSNumber numberWithFloat:level] forKey:@"inputIntensity"];
    [filter setValue:ciImage forKey:@"inputImage"];
    ciImage = filter.outputImage;
    
    return ciImage;
}


+ (CIImage *)monoChrome:(CIImage*)ciImage Color:(CIColor *)color Level:(float)level
{
    LOG_FUNC
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setDefaults];
    LOG(@"inputKeyrs = %@", filter.inputKeys);
    [filter setValue:color forKey:@"inputColor"];
    [filter setValue:[NSNumber numberWithFloat:level] forKey:@"inputIntensity"];
    [filter setValue:ciImage forKey:@"inputImage"];
    ciImage = filter.outputImage;
    
    return ciImage;
}

+ (CIImage *)vignette:(CIImage*)ciImage Intensity:(float)intensity Radius:(float)radius
{
    CIFilter *filter = [CIFilter filterWithName:@"CIVignette"]; 
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    [filter setValue:ciImage forKey:@"inputImage"];
    ciImage = filter.outputImage;
    
    return ciImage;
}

+ (CIImage *)colorControl:(CIImage *)ciImage Saturation:(float)saturation Brightness:(float)brightness Contrast:(float)contrast
{
    /*
    inputSaturation
    彩度の調整量を指定するスカラー値（NSNumber）。デフォルト値は 1.0 です。範囲は 0.0 ～ 3.0 です。
    inputBrightness
    輝度の調整量を指定するスカラー値（NSNumber）。デフォルト値は 0.0 です。範囲は -1.0 ～ 1.0 です。
    inputContrast
    コントラストの調整量を指定するスカラー値（NSNumber）。デフォルト値は 1.0 です。範囲は 0.25 ～ 4.0 です。
    */
//    NSAssert3((saturation < 0.0 || saturation > 3.0), @"saturation is out of range", nil);
//    if (brightness < -1.0 || brightness > 1.0) {
//        
//    }
//    if (contrast < 0.25 || contrast > 4.0) {
//        
//    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setDefaults];
    LOG(@"inputKeyrs = %@", filter.inputKeys);
    
    [filter setValue:[NSNumber numberWithFloat:saturation] forKey:@"inputSaturation"];
    [filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputBrightness"];
    [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputContrast"];
    [filter setValue:ciImage forKey:@"inputImage"];
    ciImage = filter.outputImage;
    
    return ciImage;
}



+ (UIImage *)convertCtoU:(CIImage *)cImage
{
    
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = 
    [ciContext createCGImage:cImage fromRect:cImage.extent];
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
    
    IMAGE_SIZE(uiImage);
    
    return uiImage;
}


+ (CIColor *) hexToUIColor:(NSString *)hex alpha:(CGFloat)a{
    NSScanner *colorScanner = [NSScanner scannerWithString:hex];
    unsigned int color;
    [colorScanner scanHexInt:&color];
    CGFloat r = ((color & 0xFF0000) >> 16)/255.0f;
    CGFloat g = ((color & 0x00FF00) >> 8) /255.0f;
    CGFloat b =  (color & 0x0000FF) /255.0f;
    //NSLog(@"HEX to RGB >> r:%f g:%f b:%f a:%f\n",r,g,b,a);
    return [CIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (CIColor *) hexToUIColor:(NSString *)hex{
    NSScanner *colorScanner = [NSScanner scannerWithString:hex];
    unsigned int color;
    [colorScanner scanHexInt:&color];
    CGFloat r = ((color & 0xFF0000) >> 16)/255.0f;
    CGFloat g = ((color & 0x00FF00) >> 8) /255.0f;
    CGFloat b =  (color & 0x0000FF) /255.0f;
    //NSLog(@"HEX to RGB >> r:%f g:%f b:%f a:%f\n",r,g,b,a);
    return [CIColor colorWithRed:r green:g blue:b];
}



@end
