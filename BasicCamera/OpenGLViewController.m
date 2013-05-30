//
//  OpenGLViewController.m
//  BasicCamera
//
//  Created by k16 on 12/07/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OpenGLViewController.h"

@interface OpenGLViewController ()

@end

@implementation OpenGLViewController
@synthesize pickerController = _pickerController;



/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // Create image picker
    self.pickerController = [[CustomImagePickerViewController alloc] init];
    self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentModalViewController:self.pickerController animated:NO];
    
    /*
    self.glView = [[GLView alloc] initWithFrame:[self view].bounds];
    
    // To check possible to use camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // Create image picker
        self.pickerController = [[CustomImagePickerViewController alloc] init];
        self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // Hide camera controll
        //self.pickerController.showsCameraControls = NO;
        self.pickerController.showsCameraControls = NO;
        self.pickerController.navigationBarHidden = YES;
        self.pickerController.toolbarHidden = YES;      
        
        self.pickerController.wantsFullScreenLayout = YES; 
        //self.pickerController.cameraViewTransform = CGAffineTransformScale(self.pickerController.cameraViewTransform, 320, 480); 
        
        
        [self.pickerController setAllowsEditing:YES];
        self.pickerController.delegate = self.glView;
        
        // Add camera overlay
        self.pickerController.cameraOverlayView.alpha = 0.0f;
        self.pickerController.cameraOverlayView = self.glView;
        
        // View image picker
        [self presentModalViewController:self.pickerController animated:NO];
    }
    
    [self.glView startAnimation];
     */
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
