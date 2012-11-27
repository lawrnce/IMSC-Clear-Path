//
//  YKCatalogAppDelegate.h
//  YelpKitCatalog
//
//  Created by Gabriel Handford on 7/23/12.
//  Copyright (c) 2012 Yelp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKCatalogAppDelegate : UIResponder <UIApplicationDelegate> {
  YKUIViewStack *_viewStack;
  
  YKTableView *_tableView;
}

@property (strong, nonatomic) UIWindow *window;

@end
