//
//  USCAppDelegate.h
//  ClearPath
//
//  Created by Lawrence Tran on 9/7/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <YelpKit/YelpKit.h>
#import <GHKit/GHKit.h>

@class USCViewController;

@interface USCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) USCViewController *viewController;

@end
