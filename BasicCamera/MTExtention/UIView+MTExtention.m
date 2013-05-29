//
//  UIView+MTExtention.m
//  PullTest
//
//  Created by 哲太郎 村上 on 12/04/16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+MTExtention.h"

@implementation UIView (UIView_MTExtention)

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

////


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)l {
    
    self.frame = CGRectMake(l,self.frame.origin.y,
                            self.frame.size.width,self.frame.size.height);
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)r {
    
    self.frame = CGRectMake(r - self.frame.size.width,self.frame.origin.y,
                            self.frame.size.width,self.frame.size.height);
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    
    self.frame = CGRectMake(self.frame.origin.x,y,
                            self.frame.size.width,self.frame.size.height);
}

- (CGFloat)bottom {
    return self.frame.origin.x - self.frame.size.height;
}

- (void)setBottom:(CGFloat)y {
    
    self.frame = CGRectMake(self.frame.origin.x, y + self.frame.size.height ,
                            self.frame.size.width,self.frame.size.height);
}

//size//

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)w {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            w, self.frame.size.height) ;
    //self.frame.size = size;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)h {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width, h) ;
    //self.frame.size = size;
}


@end
