//
//  YKTableView.h
//  YelpKit
//
//  Created by Gabriel Handford on 5/13/12.
//  Copyright (c) 2012 Yelp. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "YKTableViewDataSource.h"
#import "YKUIActivityCell.h"
#import "YKUIRefreshHeaderView.h"

@class YKTableView;

@protocol YKRefreshTableViewDelegate <NSObject>
- (void)refreshTableViewShouldRefresh:(YKTableView *)tableView;
@end


@interface YKTableView : UITableView <UIScrollViewDelegate, YKUIRefreshHeaderViewDelegate> {
  YKTableViewDataSource *dataSource_;
  
  // For activity
  YKUIActivityCell *_activityCell;
  BOOL _activitySection;
  
  // Refresh header
  YKUIRefreshHeaderView *_refreshHeaderView;
  
  id<YKRefreshTableViewDelegate> _refreshDelegate;
}

@property (assign, nonatomic) YKTableViewDataSource *dataSource; // Has to match superclass dataSource assign property
@property (readonly, nonatomic) YKUIActivityCell *activityCell;
@property (assign, nonatomic) BOOL touchesShouldCancelInContentView;

/*!
 Shared init.
 */
- (void)sharedInit;

#pragma mark Activity

/*!
 Set activity enabled.
 @param section
 @param animated
 */
- (void)setActivityEnabledWithSection:(NSInteger)section animated:(BOOL)animated;

/*!
 Set activity disabled.
 @param animated
 */
- (void)setActivityDisabledAnimated:(BOOL)animated;

/*!
 @result YES if activity enabled
 */
- (BOOL)activityEnabled;

/*!
 Set empty section headers of height.
 */
- (void)setEmptySectionHeaderWithHeight:(CGFloat)height;

/*!
 Set empty section footer of height.
 */
- (void)setEmptySectionFooterWithHeight:(CGFloat)height;

#pragma mark Refresh

/*!
 Set refreshing indicator.
 
 @param refreshing YES if refreshing
 */
- (void)setRefreshing:(BOOL)refreshing;

/*!
 Enable or disable the header.
 
 @param enabled YES to enable
 */
- (void)setRefreshHeaderEnabled:(BOOL)enabled;

/*!
 Check if refresh header is enabled.
 */
- (BOOL)isRefreshHeaderEnabled;

/*!
 Expand the refresh header view.
 
 @param expand If YES, expand
 */
- (void)expandRefreshHeaderView:(BOOL)expand;

@end
