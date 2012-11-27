//
//  YKUIRefreshScrollView.m
//  YelpKit
//
//  Created by Gabriel Handford on 5/13/12.
//  Copyright (c) 2012 Yelp. All rights reserved.
//

#import "YKUIRefreshScrollView.h"

@implementation YKUIRefreshScrollView

@synthesize refreshHeaderView=_refreshHeaderView, refreshDelegate=_refreshDelegate;

- (void)sharedInit {
  self.delegate = self;
  self.alwaysBounceVertical = YES;
  [self setRefreshHeaderEnabled:YES];
}

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
    [self sharedInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self sharedInit];
  }
  return self;
}

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

- (void)setError:(YKError *)error {
  [self setRefreshing:NO];
}

- (BOOL)isRefreshHeaderEnabled {
  return !!_refreshHeaderView;
}

- (void)expandRefreshHeaderView:(BOOL)expand {
  [_refreshHeaderView expandRefreshHeaderView:expand inScrollView:self];
}

- (void)refreshHeaderViewDidSelectRefresh:(YKUIRefreshHeaderView *)refreshHeaderView {
  if (!_refreshDelegate) return;
  if ([_refreshDelegate refreshScrollViewShouldRefresh:self]) {
    [self setRefreshing:YES];
  }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [_refreshHeaderView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {  
  [_refreshHeaderView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
