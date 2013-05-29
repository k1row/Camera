//
//  EditViewController.h
//  BasicCamera
//
//  Created by 哲太郎 村上 on 12/06/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterController.h"

@interface EditViewController : UIViewController

@property (strong,nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic,setter = setOriginalImage:) UIImage *originalImage;
@property (strong,nonatomic)FilterController *filter;
- (IBAction)org:(id)sender;
- (IBAction)grayscale:(id)sender;
- (IBAction)pro:(id)sender;
- (IBAction)sepia:(id)sender;
- (IBAction)diana:(id)sender;
- (IBAction)country:(id)sender;
- (IBAction)amaro:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)savePhoto:(id)sender;

@end
