//
//  NSDate+MTExtention.h
//  Groupin
//
//  Created by 哲太郎 村上 on 12/06/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_MTExtention)

- (NSDate *)toLocalTime;
- (NSDate *)toGlobalTime;
+ (float)timezoneOffset;

@end
