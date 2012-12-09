//
//  USCTimeSlider.h
//  ClearPath
//
//  Created by Lawrence Tran on 12/3/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USCRoute.h"

@protocol USCTimeSlider <NSObject>

@required

- (void)willRouteFrom:(CLLocation *)start To:(CLLocation *)end withTime:(NSDate *)index;

@end

@interface USCTimeSlider : UIView
{

    __unsafe_unretained id<USCTimeSlider> _delegate;
}

@property (nonatomic, unsafe_unretained) id<USCTimeSlider> delegate;
@property (nonatomic, strong) NSDate *depatureDate;

@property (nonatomic, strong) CLLocation *start;
@property (nonatomic, strong) CLLocation *end;

@end


