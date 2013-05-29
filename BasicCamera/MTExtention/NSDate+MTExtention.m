//
//  NSDate+MTExtention.m
//  Groupin
//
//  Created by 哲太郎 村上 on 12/06/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+MTExtention.h"

@implementation NSDate (NSDate_MTExtention)

- (NSDate *) toLocalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

- (NSDate *) toGlobalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

+ (float)timezoneOffset
{
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    float offset = [zone secondsFromGMT]/3600.0;
    return offset;
}

@end
