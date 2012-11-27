//
//  YKUIRefreshScrollView.h
//  YelpKit
//
//  Created by Gabriel Handford on 5/13/12.
//  Copyright (c) 2012 Yelp. All rights reserved.
//

#import "YKUIRefreshHeaderView.h"
#import "YKError.h"

@class YKUIRefreshScrollView;

@protocol YKUIRefreshScrollViewDelegate <NSObject>
/*!
 @result Return YES to set the state to refreshing.
 */
- (BOOL)refreshScrollViewShouldRefresh:(YKUIRefreshScrollView *)refreshScrollView;
@end

@interface YKUIRefreshScrollView : UIScrollView <YKUIRefreshHeaderViewDelegate, UIScrollViewDelegate> {
  YKUIRefreshHeaderView *_refreshHeaderView;
  
  id<YKUIRefreshScrollViewDelegate> _refreshDelegate;
}

@property (readonly, nonatomic) YKUIRefreshHeaderView *refreshHeaderView;
@property (assign, nonatomic) id<YKUIRefreshScrollViewDelegate> refreshDelegate;

/*!
 Shared init.
 */
- (void)sharedInit;

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

/*!
 Set error. Stops refreshing.
 */
- (void)setError:(YKError *)error;

/*!
 View did scroll. Controllers must call this.
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/*!
 View did end dragging. Controllers must call this.
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end