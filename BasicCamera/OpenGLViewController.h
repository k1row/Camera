//
//  OpenGLViewController.h
//  BasicCamera
//
//  Created by k16 on 12/07/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#include <math.h>


#import "CustomImagePickerViewController.h"


@interface OpenGLViewController : UIViewController

@property (strong, nonatomic)CustomImagePickerViewController* pickerController;



@end
