//
//  CustomImagePickerViewController.m
//  BasicCamera
//
//  Created by Keiichiro Nagashima on 12/07/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomImagePickerViewController.h"

@interface CustomImagePickerViewController ()
-(void)addMenu;
-(void)addButton;
@end

@implementation CustomImagePickerViewController
@synthesize viewOverlay = _viewOverlay;
@synthesize glView = _glView;
@synthesize toolBar = _toolBar;
@synthesize lensBtn = _lensBtn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        [[NSBundle mainBundle] loadNibNamed:@"CustomImagePicker" owner:self options:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.glView = [[GLView alloc] initWithFrame:[self view].bounds];
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

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    [[NSBundle mainBundle] loadNibNamed:@"CustomImagePicker" owner:self options:nil];
    
    // To check possible to use camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        // Hide camera controll
        self.showsCameraControls = NO;
        self.navigationBarHidden = YES;
        self.toolbarHidden = YES;      
        
        self.wantsFullScreenLayout = YES; 
        //self.pickerController.cameraViewTransform = CGAffineTransformScale(self.pickerController.cameraViewTransform, 320, 480); 
        
        
        [self setAllowsEditing:NO];
        self.delegate = self.glView;
        
        // Add camera overlay
        self.cameraOverlayView.alpha = 0.0f;
        [self setCameraOverlayView:self.glView];
        self.cameraOverlayView = self.glView;
        
        // View image picker
        //[self presentModalViewController:self animated:NO];
    }

    [self.glView startAnimation];
    
    [self addMenu];
    [self addButton];
}

- (void)addMenu
{
    // ツールバー
    self.toolBar = [[UIToolbar alloc] init];
    self.toolBar.barStyle = UIBarStyleBlackTranslucent;
    [self.toolBar setFrame:CGRectMake(0, 416, self.glView.bounds.size.width, 44)];
    [self.glView addSubview:self.toolBar];
    
    // カメラボタン
    UIBarButtonItem *cameraButton =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                 target:self
                                                 action:@selector(savePhoto:)];
    cameraButton.style = UIBarButtonItemStyleBordered;
    
    
    // キャンセルボタン
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                 target:self
                                                 action:@selector(cancelPhoto:)];
    
    [self.toolBar setItems:[NSArray arrayWithObjects:cameraButton, cancelButton, nil]];    
}

- (void)addButton
{
    //self.lensBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage* img = [UIImage imageNamed:@"postNavi_icon01.png"];
    
    self.lensBtn = [[UIButton alloc] init];
    [self.lensBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.lensBtn setFrame:CGRectMake(220, 360, 45, 45)];
    [self.lensBtn addTarget:self action:@selector(lendsSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.glView addSubview:self.lensBtn];    
}

- (void)savePhoto:(id)sender
{
    /*
	[self.glView stopAnimation];
	UIImage* aImage = [self getImage];
	UIImageWriteToSavedPhotosAlbum(aImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil); // add callback for finish saving
     */
    [self takePicture];
}

- (void)canselPhoto:(id)sender
{
	[self.glView stopAnimation];
}


- (void)lendsSelected:(id)sender
{
    [self.glView changeFilter];
}


@end
