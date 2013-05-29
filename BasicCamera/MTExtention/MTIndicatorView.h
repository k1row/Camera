//
//  IndicatorView.h
//  hola
//
//  Created by 哲太郎 村上 on 12/04/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTIndicatorView : UIView

@property (strong,nonatomic)UIActivityIndicatorView  *indicator;
- (void)stop;
@end
