//
//  YKUIListView.m
//  YelpKit
//
//  Created by Gabriel Handford on 3/24/12.
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

#import "YKUIListView.h"
#import "YKCGUtils.h"

@implementation YKUIListView

@synthesize lineSeparatorColor=_lineSeparatorColor, topBorderColor=_topBorderColor, bottomBorderColor=_bottomBorderColor, lineInsets=_lineInsets, insets=_insets;

- (void)sharedInit {
  [super sharedInit];
  self.layout = [YKLayout layoutForView:self];
  self.backgroundColor = [UIColor whiteColor];
  _insets = UIEdgeInsetsMake(0, 0, 0, 0);
  _lineInsets = UIEdgeInsetsMake(0, 10, 0, 10);
  _tagRemovalAnimating = NSNotFound;
}

- (NSString *)description {
  return GHDescription(@"views");
}

- (void)dealloc {
  [_views release];
  [_lineSeparatorColor release];
  [_topBorderColor release];
  [_bottomBorderColor release];
  [super dealloc];
}

- (CGSize)layout:(id<YKLayout>)layout size:(CGSize)size {
  if ([_views count] == 0) return CGSizeMake(size.width, 0);

  CGFloat lineHeight = (_lineSeparatorColor ? 1 : 0);
  
  CGFloat x = _insets.left;
  CGFloat y = _insets.top + lineHeight;
  for (UIView *view in _views) {
    // If a tag is animating removal then lets return size without them
    BOOL skip = (_tagRemovalAnimating != NSNotFound && view.tag == _tagRemovalAnimating);
    if (!skip) {
      CGRect viewRect = [layout setFrame:CGRectMake(x, y, size.width - x - _insets.right, 0) view:view sizeToFit:YES];
      y += viewRect.size.height + lineHeight + _insets.bottom;
    }
  }
  y += _insets.bottom;
  if (![layout isSizing]) [self setNeedsDisplay];
  return CGSizeMake(size.width, y);
}

- (NSInteger)count {
  return [_views count];
}

- (void)addView:(UIView *)view {
  if (!_views) _views = [[NSMutableArray alloc] init];
  [_views addObject:view];
  [self addSubview:view];
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

- (void)insertView:(UIView *)view atIndex:(NSInteger)index {
  if (!_views) _views = [[NSMutableArray alloc] init];
  [_views insertObject:view atIndex:index];
  [self addSubview:view];
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

- (void)addViews:(NSArray *)views {
  for (UIView *view in views) {
    [self addView:view];
  }
}

- (NSArray *)viewsWithTag:(NSInteger)tag {
  NSMutableArray *views = [[NSMutableArray alloc] init];
  for (UIView *view in _views) {
    if (view.tag == tag) {
      [views addObject:view];
    }
  }
  return [views autorelease];
}

- (void)setViewsHidden:(BOOL)hidden tag:(NSInteger)tag animationDuration:(NSTimeInterval)animationDuration {
  [UIView animateWithDuration:animationDuration animations:^{
    if (hidden) _tagRemovalAnimating = tag;
    for (UIView *view in [self viewsWithTag:tag]) {
      view.alpha = (hidden ? 0.0 : 1.0);
    }
  } completion:^(BOOL finished) {
    for (UIView *view in [self viewsWithTag:tag]) {
      view.alpha = 1.0;
    }
    [self removeViewsWithTag:tag];
    _tagRemovalAnimating = NSNotFound;
  }];
}

- (void)removeView:(UIView *)view {
  [view removeFromSuperview];
  [_views removeObject:view];
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

- (void)removeViewsWithTag:(NSInteger)tag {
  NSArray *views = [self viewsWithTag:tag];
  for (UIView *view in views) {
    if (view.tag == tag) {
      [view removeFromSuperview];
    }
  }
  [_views removeObjectsInArray:views];
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

- (NSArray *)views {
  return _views;
}

- (void)removeAllViews {
  for (UIView *view in _views) {
    [view removeFromSuperview];
  }
  [_views removeAllObjects];
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  CGContextRef context = UIGraphicsGetCurrentContext();  
  CGFloat y = 1;
  if (_topBorderColor) {
    YKCGContextDrawLine(context, _lineInsets.left, 0.5 + _lineInsets.top, self.frame.size.width - _lineInsets.right, 0.5 + _lineInsets.top, _topBorderColor.CGColor, 1.0);
  }
  
  if (_lineSeparatorColor) {
    for (NSInteger i = 0; i < [_views count]; i++) {
      UIView *view = [_views objectAtIndex:i];
      y += view.frame.size.height;
      UIView *nextView = nil;
      if (i < ([_views count] - 1)) nextView = [_views objectAtIndex:i + 1];
      
      BOOL viewHasCustomListViewAppearance = NO;
      if ([view respondsToSelector:@selector(hasCustomListViewAppearance)]) {
        viewHasCustomListViewAppearance = [(id)view hasCustomListViewAppearance];
      }
      
      BOOL nextViewHasCustomListViewAppearance = NO;
      if ([nextView respondsToSelector:@selector(hasCustomListViewAppearance)]) {
        nextViewHasCustomListViewAppearance = [(id)nextView hasCustomListViewAppearance];
      }
      
      if (!viewHasCustomListViewAppearance && !nextViewHasCustomListViewAppearance && nextView) {
        YKCGContextDrawLine(context, _lineInsets.left, y + 0.5 + _lineInsets.bottom, self.frame.size.width - _lineInsets.right, y + 0.5 + _lineInsets.bottom, _lineSeparatorColor.CGColor, 1.0);
      }

      y += 1;
    }
  }

  if (_bottomBorderColor) {
    CGFloat bottomBorderY = self.frame.size.height - 0.5 - _lineInsets.bottom;
    YKCGContextDrawLine(context, _lineInsets.left, bottomBorderY, self.frame.size.width - _lineInsets.right, bottomBorderY, _bottomBorderColor.CGColor, 1.0);
  }
}


@end
