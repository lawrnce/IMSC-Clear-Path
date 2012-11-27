//
//  YKUIViewStack.h
//  YelpKit
//
//  Created by Gabriel Handford on 7/5/12.
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

#import "YKSUIView.h"

@interface YKUIViewStack : NSObject {
  NSMutableArray *_stack;
  UIView *_parentView;
  
  YKSUIViewAnimationOptions _defaultOptions;
  NSTimeInterval _defaultDuration;
}

/*!
 Default options for push and pop, for pushView:animated: and popViewAnimated:.
 */
@property (assign, nonatomic) YKSUIViewAnimationOptions defaultOptions;

/*!
 Default duration.
 */
@property (assign, nonatomic) NSTimeInterval defaultDuration;

- (id)initWithParentView:(UIView *)parentView;

- (void)pushView:(YKSUIView *)view animated:(BOOL)animated;

- (void)popView:(YKSUIView *)view animated:(BOOL)animated;

- (void)pushView:(YKSUIView *)view duration:(NSTimeInterval)duration options:(YKSUIViewAnimationOptions)options;

- (void)setView:(YKSUIView *)view duration:(NSTimeInterval)duration options:(YKSUIViewAnimationOptions)options;

- (void)popView:(YKSUIView *)view duration:(NSTimeInterval)duration options:(YKSUIViewAnimationOptions)options;

- (void)popToView:(YKSUIView *)view duration:(NSTimeInterval)duration options:(YKSUIViewAnimationOptions)options;

- (void)swapView:(YKSUIView *)view duration:(NSTimeInterval)duration options:(YKSUIViewAnimationOptions)options;

- (YKSUIView *)visibleView;

- (BOOL)isRootView:(YKSUIView *)view;

- (BOOL)isVisibleView:(YKSUIView *)view;

- (NSInteger)indexOfView:(YKSUIView *)view;

@end
