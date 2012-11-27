//
//  YKUISwitchButton.h
//  YelpKit
//
//  Created by Gabriel Handford on 6/26/12.
//  Copyright (c) 2012 Yelp. All rights reserved.
//

#import "YKUILayoutView.h"
#import "YKUIButton.h"

@interface YKUISwitchButton : YKUILayoutView {
  YKUIButton *_button;
  UISwitch *_switchControl;
}

@property (readonly, nonatomic) YKUIButton *button;
@property (readonly, nonatomic) UISwitch *switchControl;

@end
