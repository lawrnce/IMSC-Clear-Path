//
//  NSDate+RoundTime.h
//  ClearPath
//
//  Created by Lawrence Tran on 11/14/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RoundTime)

- (NSDate *)currentTimeRoundedToNearestTimeInterval:(NSTimeInterval)interval;
- (NSDate *)roundTime:(NSDate *)date toNearestTimeInterval:(NSTimeInterval)interval;
- (NSString *)setRoundTimeToString:(NSDate *)date;

@end
