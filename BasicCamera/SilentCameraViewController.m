//
//  SilentCameraViewController.m
//  BasicCamera
//
//  Created by on 12/06/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SilentCameraViewController.h"
#import "EditViewController.h"

@interface SilentCameraViewController ()
{
    AVCaptureStillImageOutput *videoStillOutput;
    AVCaptureVideoDataOutput *videoOutput;
    CMSampleBufferRef bufferForCapture;

}
@end

@implementation SilentCameraViewController
@synthesize session = session;
@synthesize preView = _preView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    // [1] init camera device
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        AVCaptureSession* captureSession = [[AVCaptureSession alloc] init];
        AVCaptureDevice* videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError* error = nil;
        AVCaptureDeviceInput* videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice
                                                                                 error:&error];
        
        // AVCaptureStillImageOutputで静止画出力を作る
        videoStillOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        AVVideoCodecJPEG, AVVideoCodecKey, nil];
        videoStillOutput.outputSettings = outputSettings;
        
//        videoOutput = [[AVCaptureVideoDataOutput alloc] init];
//        videoOutput.videoSettings =
//        [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
//        //videoOutput.minFrameDuration = CMTimeMake(1, 15);
//        dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
//        [videoOutput setSampleBufferDelegate:self queue:queue];
//        dispatch_release(queue);
        
 
        // セッションに出力を追加
        [captureSession addOutput:videoStillOutput]; 
//        [captureSession addOutput:videoOutput];
        
        if (videoInput) {
            [captureSession addInput:videoInput];
            //        [captureSession addOutput:v
            [captureSession beginConfiguration];
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
            [captureSession commitConfiguration];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                AVCaptureVideoPreviewLayer* previewLayer =
                [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
                previewLayer.automaticallyAdjustsMirroring = NO;
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                previewLayer.frame = self.view.bounds;
                [self.view.layer insertSublayer:previewLayer atIndex:0];
                
                [captureSession startRunning];
            });        
        }
    });

    [self setupCaptureSession];
    
}
// Create and configure a capture session and start it running
- (void)setupCaptureSession 
{
    NSError *error = nil;
    
    // Create the session
    session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames, if your 
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Find a suitable AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device 
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
    }
    [session addInput:input];
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    // Specify the pixel format
    output.videoSettings = 
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] 
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    
    // If you wish to cap the frame rate to a known value, such as 15 fps, set 
    // minFrameDuration.
    //output.minFrameDuration = CMTimeMake(1, 15);
    //[output setVideoMinFrameDuration:CMTimeMake(1,15)];
    // Start the session running to start the flow of data
    [session startRunning];
    
    // Assign session to an ivar.
    [self setSession:session];
}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
       fromConnection:(AVCaptureConnection *)connection
{ 
    // Create a UIImage from the sample buffer data
    bufferForCapture = sampleBuffer;
    
    //< Add your code here that uses the image >
    
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer 
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); 
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0); 
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer); 
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer); 
    size_t height = CVPixelBufferGetHeight(imageBuffer); 
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, 
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst); 
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context); 
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context); 
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

- (IBAction)take:(id)sender
{
//    UIImage *capture = [self imageFromSampleBuffer:bufferForCapture];
//
//	
//    LOG(@"image %@",capture);
//    
//    [self setCapture:capture];
//    
    
    // コネクションを検索
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in videoStillOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
            break;
    }
    
    
    // 静止画をキャプチャする
    [videoStillOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                   completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         if (imageSampleBuffer != NULL) {
             
             // キャプチャしたデータを取る
             NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             UIImage *capture = [UIImage imageWithData:data];
             
             [self setCapture:capture];
         }
     }]; 
    
    
     
    
}

- (UIImage *) aaa:(CMSampleBufferRef)sampleBuffer
{
    // イメージバッファの取得
    CVImageBufferRef    buffer;
    buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // イメージバッファのロック
    CVPixelBufferLockBaseAddress(buffer, 0);
    
    // イメージバッファ情報の取得
    uint8_t*    base;
    size_t      width, height, bytesPerRow;
    base = CVPixelBufferGetBaseAddress(buffer);
    width = CVPixelBufferGetWidth(buffer);
    height = CVPixelBufferGetHeight(buffer);
    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    // ビットマップコンテキストの作成
    CGColorSpaceRef colorSpace;
    CGContextRef    cgContext;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    cgContext = CGBitmapContextCreate(
                                      base, width, height, 8, bytesPerRow, colorSpace, 
                                      kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    // 画像の作成
    CGImageRef  cgImage;
    UIImage*    image;
    cgImage = CGBitmapContextCreateImage(cgContext);
    image = [UIImage imageWithCGImage:cgImage scale:1.0f 
                          orientation:UIImageOrientationRight];
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    
    // イメージバッファのアンロック
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    
    return image;
}
/*
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    LOG_FUNC
    
    bufferForCapture = sampleBuffer;
}


*/




- (void)setCapture:(UIImage *)capture
{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    EditViewController *ediCon = (EditViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"EditViewController"];
    
    IMAGE_SIZE(capture);
    ediCon.originalImage = capture;
    
    [self.navigationController pushViewController:ediCon animated:YES];
}
- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
