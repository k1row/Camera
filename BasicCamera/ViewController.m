//
//  ViewController.m
//  BasicCamera
//
//  Created by on 12/06/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "EditViewController.h"
#import "MovieEditViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (IBAction)cam:(id)sender
{

    if([UIImagePickerController
        isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];  // 生成
        ipc.delegate = self;  // デリゲートを自分自身に設定
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;  // 画像の取得先をカメラに設定
        ipc.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage,
                          nil];
        ipc.allowsEditing = NO;  // 画像取得後編集する
        [self presentModalViewController:ipc animated:YES];
    }
}

- (IBAction)movie:(id)sender
{
    if([UIImagePickerController
        isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];  // 生成
        ipc.delegate = self;  // デリゲートを自分自身に設定
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;  // 画像の取得先をカメラに設定
        ipc.mediaTypes = [[NSArray alloc] initWithObjects:
                          (NSString *)kUTTypeMovie , nil];
        ipc.videoQuality = UIImagePickerControllerQualityTypeHigh;
        ipc.videoMaximumDuration = 100;
        
        ipc.allowsEditing = NO;  // 画像取得後編集する
        [self presentModalViewController:ipc animated:YES];
    }
}

- (IBAction)videoAlbum:(id)sender
{
    if([UIImagePickerController
        isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary ])
    {
        UIImagePickerController *ipc =
        [[UIImagePickerController alloc] init];  // 生成
        ipc.delegate = self;  // デリゲートを自分自身に設定
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  // 
        ipc.allowsEditing = NO;  // 画像取得後編集する
        ipc.mediaTypes = [[NSArray alloc] initWithObjects:
                          (NSString *)kUTTypeMovie , nil];
        
        [self presentModalViewController:ipc animated:YES];
        
    }    
}


- (IBAction)album:(id)sender
{
    if([UIImagePickerController
        isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary ])
    {
        UIImagePickerController *ipc =
        [[UIImagePickerController alloc] init];  // 生成
        ipc.delegate = self;  // デリゲートを自分自身に設定
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  // 
        ipc.allowsEditing = NO;  // 画像取得後編集する
        ipc.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage,
                           nil];
        
        [self presentModalViewController:ipc animated:YES];
        
    }    
}




- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    LOG_FUNC
    
    LOG(@"info %@",[info allKeys]);
    LOG(@"value %@",[info description]);
    
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0)
        
        == kCFCompareEqualTo) {
        
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        EditViewController *ediCon = (EditViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"EditViewController"];
        
        
        UIImage *originalImage =  (UIImage *) [info objectForKey:
                                               UIImagePickerControllerOriginalImage];
        
        LOG(@"jjjj");
        IMAGE_SIZE(originalImage);
        ediCon.originalImage = originalImage;
        
        if ([self.presentedViewController isKindOfClass:[UIImagePickerController class]]) {
            
            [self dismissModalViewControllerAnimated:NO];        
        }
        
        [self.navigationController pushViewController:ediCon animated:YES];
        
        
    }
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0)
        
        == kCFCompareEqualTo) {
        
        
        LOG(@"MediaURL %@",[info objectForKey:UIImagePickerControllerMediaURL]);
        
        
        NSURL *movieURL = [info objectForKey:
                                
                                UIImagePickerControllerMediaURL];
        
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        MovieEditViewController *ediCon = (MovieEditViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"MovieEditViewController"];
        ediCon.movieURL = movieURL;
        
        [self.navigationController pushViewController:ediCon animated:YES];
        
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
//            
//            UISaveVideoAtPathToSavedPhotosAlbum (
//                                                 
//                                                 moviePath, nil, nil, nil);
//        }
        
        
        if ([self.presentedViewController isKindOfClass:[UIImagePickerController class]]) {
            
            [self dismissModalViewControllerAnimated:NO];        
        }
        
    }
    
    
    
    
    
}



//画像の選択がキャンセルされた時に呼ばれる
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    LOG_FUNC
    [self dismissModalViewControllerAnimated:YES];  // モーダルビューを閉じる
    // 何かの処理
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
