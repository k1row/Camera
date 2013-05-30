//
//  COMMON.h
//  LocalNetwork
//
//  Created by on 12/04/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 *  COMMON.h
 *  
 *
 *  Created by  on 10/11/06.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */


/*
 * BOUNDS
 */


#define BOUNDS [[UIScreen mainScreen] bounds]


 //iphone
 #define BOUNDS_W 320
 #define BOUNDS_H 480
 
 #define PORT_BOUNDS CGRectMake(0, 0, 320 , 480)
 #define LAND_BOUNDS CGRectMake(0, 0, 480 , 320)

/*
//ipad
#define BOUNDS_W 768
#define BOUNDS_H 1024

#define PORT_BOUNDS CGRectMake(0, 0, 768 , 1024)
#define LAND_BOUNDS CGRectMake(0, 0, 1024 , 768)
*/

#define STATUS_BAR_H 20

/*
 * INIT
 */

//window
#define WINDOW_INIT [[UIWindow alloc] initWithFrame:BOUNDS]

//navigationBar
#define NAVCONTROLLER_INIT(controller) [[UINavigationController alloc] initWithRootViewController:controller];

//tabBar
#define TABCONTROLLER_INIT [[UITabBarController alloc] init]

//view controller
#define VIEWCONTROLLER_INIT(Controller) [[Controller alloc] init]

//view
#define VIEW_INIT(X,Y,W,H) [[UIView alloc] initWithFrame:CGRectMake(X,Y,W,H)]
#define VIEW_INIT_R(RECT) [[UIView alloc] initWithFrame:RECT]

//image
#define IMAGE_N_INIT(IMAGEPATH) [UIImage imageNamed:IMAGEPATH]
#define IMAGE_D_INIT(IMAGEDATA) [[UIImage alloc] initWithData:data cache:NO]
#define IMAGE_C_INIT(IMAGEPATH) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:IMAGEPATH ofType:nil]] 

//imageView
#define IMAGEVIEW_INIT(X,Y,W,H) [[UIImageView alloc] initWithFrame:CGRectMake(X,Y,W,H)]
#define IMAGEVIEW_INIT_R(RECT)  [[UIImageView alloc] initWithFrame:RECT]

//webView
#define WEBVIEW_INIT(X,Y,W,H) [[UIWebView alloc] initWithFrame:CGRectMake(X,Y,W,H)]
#define WEBVIEW_INIT_R(RECT) [[UIWebView alloc] initWithFrame:RECT]

//label
#define LABEL_INIT(X,Y,W,H) [[UILabel alloc] initWithFrame:CGRectMake(X,Y,W,H)]
#define LABEL_INIT_R(RECT) [[UILabel alloc] initWithFrame:RECT]

//textView
#define TEXTVIEW_INIT(X,Y,W,H) [[UITextView alloc]initWithFrame:CGRectMake(X,Y,W,H)]
#define TEXTVIEW_INIT_R(RECT) [[UITextView alloc]initWithFrame:RECT]

//switch
#define SWITH_INIT(X,Y,W,H) [[UISwitch alloc] initWithFrame:CGRectMake(X,Y,W,H)]
#define SWITH_INIT_R(RECT) [[UISwitch alloc] initWithFrame:RECT]

//slider
#define SLIDER_INIT(X,Y,W,H) [[UISlider alloc] initWithFrame:CGRectMake(X,Y,W,H)]
#define SLIDER_INIT_R(RECT) [[UISlider alloc] initWithFrame:RECT]


//button
#define CUSTOM_BUTTON_INIT [UIButton buttonWithType:UIButtonTypeCustom]
#define ROUND_BUTTON_INIT  [UIButton buttonWithType:UIButtonTypeRoundedRect]
#define CONTACT_BUTTON_INIT  [UIButton buttonWithType:UIButtonTypeContactAdd]
#define INFODARK_BUTTON_INIT  [UIButton buttonWithType:UIButtonTypeInfoDark]
#define INFOLIGHT_BUTTON_INIT  [UIButton buttonWithType:UIButtonTypeInfoLight]

//segmented button
#define SEGMENTED_BUTTON_INIT(ITEMS) [[UISegmentedControl alloc] initWithItems:ITEMS]

//application
#define SHEARD_APPLICATION [UIApplication sharedApplication]

//delegate
#define SHARED_DELEGATE(appdelegate) (appdelegate *)[[UIApplication sharedApplication] delegate]

//rect 
#define RECT_SIZE_ONLY(rect) CGRectMake(0, 0, rect.size.width, rect.size.height) 
#define ccp(x,y) CGPointMake(x, y)
#define ccr(x,y,w,h) CGRectMake(x, y, w, h)

//font
#define FONT_WITH_NAME(name,size) [UIFont fontWithName:name size:size]



//Version
#define DEV_VER [[[UIDevice currentDevice] systemVersion] floatValue]

//MACRO
#define SLEEP(time) [NSThread sleepForTimeInterval:time]

//Log
#define RECT_LOG(frame) LOG(@"x%f,y%f,w%f,h%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height) 
#define LOG_FUNC LOG(@"%s", __func__);
#define IMAGE_SIZE(image) LOG(@"height%f,width%f",(float)CGImageGetHeight(image.CGImage),(float)CGImageGetWidth(image.CGImage)) 
#define IMAGE_HEIGHT(image) (float)CGImageGetHeight(image.CGImage)
#define IMAGE_WIDTH(image) (float)CGImageGetWidth(image.CGImage)


//Memory
#define RELEASE(instance)  [instance release];
#define RETAIN_COUNT(class) LOG(@"retain count: %d (%@)",[class retainCount],class)

//Universal
#define IS_IPhone UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define IS_IPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

//degToRad
#define DegToRad(x) (M_PI * (x) / 180.0)
#define RadToDeg(x) ((x / M_PI) * 180.0)

#define ViEW_SCALE(class) [[class.layer valueForKeyPath:@"transform.scale"] floatValue]
#define VIEW_RAD(class) [[class.layer valueForKeyPath:@"transform.rotation.z"] floatValue]

//dir
#define CACHE_DIR [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define DOCUMENTS_DIR [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//DEBUG

//Logを使うときの設定
#ifdef DEBUG 
#define LOG(...) NSLog(__VA_ARGS__)
//#define LOG(...) 
#else
#define LOG(...) 
#endif

//プロジェクト→プリプロセットマクロにDEBUGを指定 


/*
 * COLOR
 */
#define BLACK_COLOR [UIColor blackColor]
#define DARKGRAY_COLOR [UIColor darkGrayColor]
#define LIGHTGRAY_COLOR [UIColor lightGrayColor]
#define WHITE_COLOR [UIColor whiteColor]
#define GRAY_COLOR [UIColor grayColor]
#define RED_COLOR [UIColor redColor]
#define GREEN_COLOR [UIColor greenColor]
#define BLUE_COLOR [UIColor blueColor]
#define CYAN_COLOR [UIColor cyanColor]
#define YELLOW_COLOR [UIColor yellowColor]
#define MAGENTA_COLOR [UIColor magentaColor]
#define ORANGE_COLOR [UIColor orangeColor]
#define PURPLE_COLOR [UIColor purpleColor]
#define BROWN_COLOR [UIColor brownColor]
#define CLEAR_COLOR [UIColor clearColor]
//System Colors
#define LIGHTTEXT_COLOR [UIColor lightTextColor]
#define DARKTEXT_COLOR [UIColor darkTextColor]
#define GTVBACK_COLOR [UIColor groupTableViewBackgroundColor]
#define VFSBACK_COLOR [UIColor viewFlipsideBackgroundColor]
#define SVTEXBACK_COLOR [UIColor scrollViewTexturedBackgroundColor]
