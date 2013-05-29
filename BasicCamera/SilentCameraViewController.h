//
//  SilentCameraViewController.h
//  BasicCamera
//
//  Created by 哲太郎 村上 on 12/06/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
@interface SilentCameraViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

- (IBAction)take:(id)sender;
- (IBAction)cancel:(id)sender;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)IBOutlet UIImageView *preView;
@end
