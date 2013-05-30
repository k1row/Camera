//
//  NSDate+MTExtention.h
//  Groupin
//
//  Created by on 12/06/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_MTExtention)

- (NSDate *)toLocalTime;
- (NSDate *)toGlobalTime;
+ (float)timezoneOffset;

@end
