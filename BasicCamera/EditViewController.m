//
//  EditViewController.m
//  BasicCamera
//
//  Created by on 12/06/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EditViewController.h"
#import "FilterController.h"

@interface EditViewController ()

@end

@implementation EditViewController
@synthesize imageView = _imageView;
@synthesize originalImage = _originalImage;
@synthesize filter = _filter;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
        self.navigationController.navigationBarHidden = YES;
	// Do any additional setup after loading the view.
   // _ciImage = _originalImage.CIImage;
    //_ciImage = [[CIImage alloc] initWithCGImage:_originalImage.CGImage options:nil];

    _filter =  [[FilterController alloc] initWithImage:_originalImage AndView:self.imageView];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#define IMAGEVIEW_WIDTH 300

- (void)viewDidAppear:(BOOL)animated
{
    LOG_FUNC
    
    if (_originalImage != nil) {
        self.imageView.image = _originalImage;
        
    }
    
    self.imageView.height = [self heightForImage:_originalImage];
    self.imageView.width  =IMAGEVIEW_WIDTH;

}

- (float)heightForImage:(UIImage *)image
{
    LOG_FUNC
    
    LOG(@"size h%f w%f",image.size.height,image.size.width);
    
    float u = (IMAGEVIEW_WIDTH * image.size.height) / image.size.width ;
        
    
    
    
    return u;
}

#define RESIZE_RATE 1
- (void)setOriginalImage:(UIImage *)image
{
    LOG_FUNC
    
    LOG(@"aaaaa %f,%f",image.size.width,image.size.height);
    
    CGSize sz = CGSizeMake(image.size.width * RESIZE_RATE,
                           image.size.height * RESIZE_RATE);
    UIGraphicsBeginImageContext(sz);
    [image drawInRect:CGRectMake(0,0,sz.width,sz.height)];
    _originalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext(); 
    
    
}

- (IBAction)back:(id)sender
{
    LOG_FUNC
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)org:(id)sender
{
    [self.filter doOrigin];
}
- (IBAction)grayscale:(id)sender
{
    [self.filter doMonoChrome];

}
- (IBAction)pro:(id)sender
{
    LOG_FUNC
    [self.filter doPro];

}
- (IBAction)sepia:(id)sender
{
    LOG_FUNC
    [self.filter doSepia:0.8];


}
- (IBAction)diana:(id)sender
{
    [self.filter doDiana];

}

- (IBAction)country:(id)sender
{
    [self.filter doCountory];

}
- (IBAction)amaro:(id)sender
{
    [self.filter doAmaro];

}

- (IBAction)savePhoto:(id)sender
{

    // 渡されてきた画像をフォトアルバムに保存する
    UIImageWriteToSavedPhotosAlbum(
                               self.imageView.image, self, @selector(targetImage:didFinishSavingWithError:contextInfo:),
                               NULL);    
}

//画像の保存完了時に呼ばれるメソッド
-(void)targetImage:(UIImage*)image
didFinishSavingWithError:(NSError*)error contextInfo:(void*)context{
    
    if(error){
        // 保存失敗時
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"保存失敗" message:[error description]
                            delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        // 保存成功時
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"保存完了" message:@""
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}




- (void)viewWillDisappear:(BOOL)animated
{
    LOG_FUNC
    
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
