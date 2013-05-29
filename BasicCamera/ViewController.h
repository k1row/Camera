//
//  ViewController.h
//  BasicCamera
//
//  Created by 哲太郎 村上 on 12/06/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

- (IBAction)cam:(id)sender;
- (IBAction)movie:(id)sender;
- (IBAction)videoAlbum:(id)sender;
- (IBAction)album:(id)sender;

@end
