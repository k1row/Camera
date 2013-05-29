//
//  MovieEditViewController.h
//  BasicCamera
//
//  Created by 哲太郎 村上 on 12/06/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MovieEditViewController : UIViewController

@property (strong,nonatomic)IBOutlet UIImageView *thum1; 
@property (strong,nonatomic)IBOutlet UIImageView *thum2; 
@property (strong,nonatomic)IBOutlet UIImageView *thum3; 
@property (strong,nonatomic)NSURL *movieURL;
@end
