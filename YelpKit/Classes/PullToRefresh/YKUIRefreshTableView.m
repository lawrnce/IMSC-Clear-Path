//
//  YKUIRefreshTableView.m
//  YelpKit
//
//  Created by Gabriel Handford on 8/23/11.
//  Copyright 2011 Yelp. All rights reserved.
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

#import "YKUIRefreshTableView.h"

@implementation YKUIRefreshTableView

@synthesize refreshHeaderView=_refreshHeaderView, refreshDelegate=_refreshDelegate;

- (void)dealloc {
  _refreshHeaderView.delegate = nil;
  [_refreshHeaderView release];
  [super dealloc];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _refreshHeaderView.frame = CGRectMake(0, 0 - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

- (void)setRefreshing:(BOOL)refreshing {
  [_refreshHeaderView setRefreshing:refreshing inScrollView:self];
}

- (void)setRefreshHeaderEnabled:(BOOL)enabled {
  if (enabled && !_refreshHeaderView) {
    _refreshHeaderView = [[YKUIRefreshHeaderView alloc] init];
    _refreshHeaderView.delegate = self;
    [self addSubview:_refreshHeaderView];
    [self sendSubviewToBack:_refreshHeaderView];
    self.showsVerticalScrollIndicator = YES;    
  } else if (!enabled) {
    [_refreshHeaderView removeFromSuperview];
    [_refreshHeaderView release];
    _refreshHeaderView = nil;
  }
  [self setNeedsLayout];
}

- (BOOL)isRefreshHeaderEnabled {
  return !!_refreshHeaderView;
}

- (void)expandRefreshHeaderView:(BOOL)expand {
  [_refreshHeaderView expandRefreshHeaderView:expand inScrollView:self];
}

- (void)refreshHeaderViewDidSelectRefresh:(YKUIRefreshHeaderView *)refreshHeaderView {
  [_refreshDelegate refreshTableViewShouldRefresh:self];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [_refreshHeaderView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {  
  [_refreshHeaderView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
