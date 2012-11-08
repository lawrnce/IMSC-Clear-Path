//
//  NSDate+RoudingCurrentTime.h
//  ClearPathDemo
//
//  Created by Lawrence Tran on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RoudingCurrentTime)

- (NSDate *)currentTimeRoundedToNearestTimeInterval:(NSTimeInterval)interval;
- (NSDate *)roundTime:(NSDate *)date toNearestTimeInterval:(NSTimeInterval)interval;
- (NSString *)setRoundTimeToString:(NSDate *)date;

@end
