//
//  AssetUtil.m
//  AssetStudy
//
//  Created by on 12/06/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AssetUtil.h"

@implementation AssetUtil
#define RESIZE_RATE 1
+ (UIImage *)thumnailFrom:(NSURL *)moviePath
{
    LOG(@"moviePath %@",moviePath);
    

    
    
    AVAsset *myAsset = [AVAsset assetWithURL:moviePath];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]
                                             initWithAsset:myAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    Float64 durationSeconds = CMTimeGetSeconds([myAsset duration]);
    CMTime midpoint = CMTimeMakeWithSeconds(durationSeconds/2.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    UIImage *thumnail;
    CGImageRef halfWayImage = [imageGenerator copyCGImageAtTime:midpoint
                                                     actualTime:&actualTime error:&error];
    if (halfWayImage != NULL) {
        NSString *actualTimeString = (__bridge NSString *)CMTimeCopyDescription(NULL,
                                                                                actualTime);
        NSString *requestedTimeString = (__bridge NSString *)CMTimeCopyDescription(NULL,
                                                                                   midpoint);
        NSLog(@"got halfWayImage: Asked for %@, got %@", requestedTimeString,
              actualTimeString);
        //                            [actualTimeString release];
        //                            [requestedTimeString release];
        // この画像を使って必要な作業を実行する
        
        LOG(@"cgImage w %f h %f",(float)CGImageGetWidth(halfWayImage),(float)CGImageGetHeight(halfWayImage));
        
        
        //thumnail = [UIImage imageWithCGImage:halfWayImage scale:1 orientation:UIImageOrientationDown];
        thumnail = [[UIImage alloc] initWithCGImage:halfWayImage];
        
        CGImageRelease(halfWayImage);
    }
    
    LOG(@"ImageSize w%f h%f",thumnail.size.width,thumnail.size.height);
    LOG(@"ImageOrien %d",thumnail.imageOrientation);
    
    
    CGSize sz = CGSizeMake(thumnail.size.width * RESIZE_RATE,
                           thumnail.size.height * RESIZE_RATE);
    UIGraphicsBeginImageContext(sz);
    [thumnail drawInRect:CGRectMake(0,0,sz.width,sz.height)];
    thumnail = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext(); 
    
    
    return thumnail;
    
}




@end
