//
//  MovieEditViewController.m
//  BasicCamera
//
//  Created by on 12/06/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MovieEditViewController.h"
#import "AssetUtil.h"


@interface MovieEditViewController ()
{

    
}
@end

@implementation MovieEditViewController
@synthesize thum1,thum2,thum3;
@synthesize movieURL;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *thumnail = [AssetUtil thumnailFrom:self.movieURL];
    self.thum1.height = [self heightForImage:thumnail];
    self.thum1.image = thumnail;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#define IMAGEVIEW_WIDTH 300
- (float)heightForImage:(UIImage *)image
{
    LOG_FUNC
    
    LOG(@"size h%f w%f",image.size.height,image.size.width);
    
    float u = (IMAGEVIEW_WIDTH * image.size.height) / image.size.width ;
    
    LOG(@"modified h %f",u);
    
    return u;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
