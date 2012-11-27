//
//  YKLUIView.h
//  YelpKit
//
//  Created by Gabriel Handford on 5/2/12.
//  Copyright (c) 2012 Yelp. All rights reserved.
//

#import "YKUILayoutView.h"

@interface YKLUIView : YKUILayoutView {
  NSMutableArray *subviews_;
}

- (CGSize)layout:(id<YKLayout>)layout size:(CGSize)size;

- (void)addView:(id)view;

- (void)removeView:(id)view;

- (void)removeAllViews;

@end
