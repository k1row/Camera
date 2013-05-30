//
//  AVFoundationCameraViewController.m
//  BasicCamera
//
//  Created by Keiichiro Nagashima on 12/07/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AVFoundationCameraViewController.h"
#import "GLUtil.h"

@interface AVFoundationCameraViewController ()
// フラグメントシェーダーソース
@property(strong,nonatomic) NSString* fshSource;
@end

@implementation AVFoundationCameraViewController
@synthesize captureSession = captureSession;
@synthesize glView = _glView;
@synthesize glView2 = _glView2;
@synthesize toolBar = _toolBar;
@synthesize lensBtn = _lensBtn;
@synthesize stillImageOutput = _stillImageOutput;
@synthesize fshSource = _fshSource;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //self.glView = [[GLView alloc] initWithFrame:[self view].bounds];
    self.glView = [[GLView alloc] initWithCoder:nil];
    self.glView2 = [[GLView2 alloc] initWithCoder:nil];

    self.captureSession = [[AVCaptureSession alloc] init];
    
    // ビデオの解像度
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetMedium])
        self.captureSession.sessionPreset = AVCaptureSessionPresetMedium;

    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput* deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!deviceInput)
        NSLog(@"deviceInput = %@", error);
    
    [self.captureSession addInput:deviceInput];
    
    
    // make static image output by AVCaptureStillImageOutput
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    self.stillImageOutput.outputSettings = outputSettings;
    
    // セッションに出力を追加
    [self.captureSession addOutput:_stillImageOutput];
    
    
    // make preview layer
    AVCaptureVideoPreviewLayer* previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];

    // resize
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.bounds;
 
    [self.view.layer addSublayer:previewLayer];
    [self.captureSession startRunning];
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

// ビュー表示前イベント
- (void)viewWillAppear:(BOOL)animated 
{
    return;

    /*
	self.glView.shader.fragmentShader = self.fshSource;
	NSString* error = [self.glView.shader build];
	if(error)
		debug_log(@"%@", error);
     */
}
// ビュー表示後イベント
- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
	//[self.glView startAnimation];
    [self.glView2 startAnimation];
	//[self.navigationController setNavigationBarHidden:YES animated:YES];//ナビバーOFF
    
    [self addMenu];
    [self addButton];
    //[self.view addSubview:self.glView];
    [self.view addSubview:self.glView2];
}

// ビュー非表示前イベント
- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
	//[self.glView stopAnimation];
    [self.glView2 stopAnimation];
	[UIApplication sharedApplication].statusBarHidden = NO;//OSステータスバーON
	//[self.navigationController setNavigationBarHidden:NO animated:NO];//ナビバーON	
}

// ビュー非表示後イベント
- (void)viewDidDisappear:(BOOL)animated 
{
}


- (void)addMenu
{
    // ツールバー
    self.toolBar = [[UIToolbar alloc] init];
    self.toolBar.barStyle = UIBarStyleBlackTranslucent;
    [self.toolBar setFrame:CGRectMake(0, 375, self.glView.bounds.size.width, 44)];
    [self.glView addSubview:self.toolBar];
    
    // カメラボタン
    UIBarButtonItem *cameraButton =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                 target:self
                                                 action:@selector (capture:)];
    cameraButton.style = UIBarButtonItemStyleBordered;
    
    
    // キャンセルボタン
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                 target:self
                                                 action:@selector (cancel:)];
    
    [self.toolBar setItems:[NSArray arrayWithObjects:cameraButton, cancelButton, nil]];    
}

- (void)addButton
{
    //self.lensBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage* img = [UIImage imageNamed:@"postNavi_icon01.png"];
    
    self.lensBtn = [[UIButton alloc] init];
    [self.lensBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.lensBtn setFrame:CGRectMake(260, 320, 45, 45)];
    [self.lensBtn addTarget:self action:@selector (lendsSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.glView addSubview:self.lensBtn];    
}

- (void)capture:(id)sender
{
    // コネクションを検索
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) 
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
            break;
    }
    
    // 静止画をキャプチャする
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection 
                                                       completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         if (imageSampleBuffer != NULL) 
         {
             // キャプチャしたデータを取る
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             UIImage *image = [[UIImage alloc] initWithData:imageData];
             UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
         }
     }];    
}

- (void)cancel:(id)sender
{
	//[self.glView stopAnimation];
    [self.glView2 stopAnimation];
}


- (void)lendsSelected:(id)sender
{
}

@end
