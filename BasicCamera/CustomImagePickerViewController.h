//
//  CustomImagePickerViewController.h
//  BasicCamera
//
//  Created by k16 on 12/07/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"

@interface CustomImagePickerViewController : UIImagePickerController

@property (strong, nonatomic)UIView* viewOverlay;
@property (strong, nonatomic)GLView* glView;
@property (strong, nonatomic)UIToolbar* toolBar;
@property (strong, nonatomic)UIButton* lensBtn;
@end
