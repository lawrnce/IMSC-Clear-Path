//
//  USCResultCard.h
//  ClearPath
//
//  Created by Lawrence Tran on 11/14/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "USCLocationPoint.h"

@class USCResultCard;

@protocol USCResultCardDelegate <NSObject>

@required

- (void)cardDidPressFor:(USCLocationPoint *)location;


//- (BOOL)mapShouldBeginPanning:(USCLimitedPanMapView *)profilePic;
//- (void)mapDidBeginPanning:(USCLimitedPanMapView *)profilePic;
//- (void)mapDidPan:(USCLimitedPanMapView *)profilePic;
//
//- (void)mapWillSnapToStart:(USCLimitedPanMapView *)profilePic duration:(NSTimeInterval)duration;
//- (void)mapDidSnapToStart:(USCLimitedPanMapView *)profilePic;

@end

@interface USCResultCard : UIView <UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *_touchGestureRecognizer;
    __unsafe_unretained id<USCResultCardDelegate> _delegate;
}

@property (nonatomic, unsafe_unretained) id<USCResultCardDelegate> delegate;

@property (nonatomic, strong) UITapGestureRecognizer *touchGestureRecognizer;
@property (nonatomic, strong) USCLocationPoint *locationPoint;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;

- (id)initWithFrame:(CGRect)frame withPoint:(USCLocationPoint *)point delegate:(id<USCResultCardDelegate>)delegate;

@end
