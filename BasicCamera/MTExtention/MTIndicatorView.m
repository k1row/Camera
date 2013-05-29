//
//  IndicatorView.m
//  hola
//
//  Created by 哲太郎 村上 on 12/04/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MTIndicatorView.h"

@implementation MTIndicatorView
@synthesize indicator = _indicator;
- (id)init{
    LOG_FUNC
    
    
    self = [super initWithFrame:BOUNDS];
    if (self) {
        
        self.backgroundColor = BLACK_COLOR;
        self.alpha = 0.8f;
        
        self.indicator =
        [[UIActivityIndicatorView alloc]
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.indicator.center = super.center;
        self.indicator.height = self.indicator.height - 44;
        [self addSubview:self.indicator];
        
        [self.indicator startAnimating];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)stopAnimating
{
    LOG_FUNC
    [self.indicator stopAnimating];
}

- (void)stop
{
    LOG_FUNC
    
    [self performSelectorInBackground:@selector(stopAnimating) withObject:nil];
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
