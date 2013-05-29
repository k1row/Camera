//
//  AVFoundationCameraViewController.h
//  BasicCamera
//
//  Created by Keiichiro Nagashima on 12/07/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GLView.h"
#import "GLView2.h"

@interface AVFoundationCameraViewController : UIViewController

@property (strong, nonatomic)AVCaptureSession* captureSession;
@property (strong, nonatomic)AVCaptureStillImageOutput* stillImageOutput;


@property (strong, nonatomic)GLView* glView;
@property (strong, nonatomic)GLView2* glView2;
@property (strong, nonatomic)UIToolbar* toolBar;
@property (strong, nonatomic)UIButton* lensBtn;

@end
