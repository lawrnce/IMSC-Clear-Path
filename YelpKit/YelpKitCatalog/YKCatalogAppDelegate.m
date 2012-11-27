//
//  YKCatalogAppDelegate.m
//  YelpKitCatalog
//
//  Created by Gabriel Handford on 7/23/12.
//  Copyright (c) 2012 Yelp. All rights reserved.
//

#import "YKCatalogAppDelegate.h"
#import "YKCatalogViewStack.h"
#import "YKCatalogButtons.h"

@implementation YKCatalogAppDelegate

@synthesize window=_window;

- (void)dealloc {
  [_window release];
  [_viewStack release];
  [_tableView release];
  [super dealloc];
}

- (void)addActionWithTitle:(NSString *)title targetBlock:(UIControlTargetBlock)targetBlock {
  YKUIButtonCell *cell = [[[YKUIButtonCell alloc] init] autorelease];
  cell.button.title = title;
  cell.button.targetBlock = targetBlock;
  [_tableView.dataSource addCellDataSource:cell section:0];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  self.window.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
  
  _viewStack = [[YKUIViewStack alloc] initWithParentView:self.window];
  _tableView = [[YKTableView alloc] init];
  
  [self addActionWithTitle:@"View Stack" targetBlock:^() {
    [_viewStack pushView:[[[YKCatalogViewStack alloc] init] autorelease] animated:YES];
  }];
  
  [self addActionWithTitle:@"Buttons" targetBlock:^() {
    YKCatalogButtons *catalogButtons = [[[YKCatalogButtons alloc] init] autorelease];
    [_viewStack pushView:[YKSUIView viewWithView:catalogButtons title:@"Buttons"] animated:YES];
  }];

  [_viewStack setView:[YKSUIView viewWithView:_tableView title:@"Catalog"] duration:0 options:0];  
  [self.window makeKeyAndVisible];
  return YES;
}

@end
