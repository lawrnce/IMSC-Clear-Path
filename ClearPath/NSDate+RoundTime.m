//
//  NSDate+RoundTime.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/14/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "NSDate+RoundTime.h"

@implementation NSDate (RoundTime)

- (NSDate *)currentTimeRoundedToNearestTimeInterval:(NSTimeInterval)interval;
{
    // Gets the date rounded date depending on the interval passed
    NSTimeInterval timeSince1970 = [self timeIntervalSince1970];
    NSTimeInterval roundedTime = round(timeSince1970 / interval) * interval;
    
    return [NSDate dateWithTimeIntervalSince1970:roundedTime];
}

- (NSDate *)roundTime:(NSDate *)date toNearestTimeInterval:(NSTimeInterval)interval;
{
    NSTimeInterval timeSince1970 = [date timeIntervalSince1970];
    NSTimeInterval roundedTime = round(timeSince1970 / interval) * interval;
    
    return [NSDate dateWithTimeIntervalSince1970:roundedTime];
    
}

- (NSString *)setRoundTimeToString:(NSDate *)date;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Format time
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *roundedTime = [dateFormatter stringFromDate:date];
    
    return roundedTime;
}

@end
