//
//  USCResultCard.h
//  ClearPath
//
//  Created by Lawrence Tran on 11/14/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "USCRoute.h"

@class USCResultCard;

@protocol USCResultCardDelegate <NSObject>

@required

- (void)willRouteAsDestination:(USCRoute *)route;
- (void)willShowInformation:(USCResultCard *)resultCard;

@end

@interface USCResultCard : UIView <UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *_touchGestureRecognizer;
    __unsafe_unretained id<USCResultCardDelegate> _delegate;
    int _index;
}

@property (nonatomic, unsafe_unretained) id<USCResultCardDelegate> delegate;

@property (nonatomic, strong) UITapGestureRecognizer *touchGestureRecognizer;
@property (nonatomic, strong) USCRoute *route;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;

- (id)initWithFrame:(CGRect)frame withRoute:(USCRoute *)point delegate:(id<USCResultCardDelegate>)delegate withIndex:(int)index;

@end
