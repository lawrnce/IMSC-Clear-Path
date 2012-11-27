//
//  YKSUIInternalView.m
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

#import "YKSUIInternalView.h"
#import "YKSUIView.h"
#import "YKUIViewStack.h"

@implementation YKSUIInternalView

@synthesize view=_view;

- (void)sharedInit {
  self.backgroundColor = [UIColor blackColor];
  self.opaque = YES;
  self.layout = [YKLayout layoutForView:self];
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
  [_view release];
  [super dealloc];
}

- (NSString *)description {
  return GHDescription(@"view");
}

- (CGSize)layout:(id<YKLayout>)layout size:(CGSize)size {
  CGFloat y = 0;
  CGSize contentSize = size;
  
  UIView *navigationBar = _view.navigationBar;
  if (navigationBar && !navigationBar.hidden) {
    CGRect navigationBarFrame = [layout setFrame:CGRectMake(0, y, size.width, 0) view:navigationBar sizeToFit:YES];    
    y += navigationBarFrame.size.height;
    contentSize.height -= navigationBarFrame.size.height;
  }
  
  CGRect contentFrame = CGRectMake(0, y, contentSize.width, contentSize.height);
  // This prevents UIScrollViews from causing a layoutSubviews call after setFrame.
  //if (!YKCGRectIsEqual(contentFrame, _contentView.frame)) {
  [layout setFrame:contentFrame view:_view];    
  
  return size;
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  // This causes the subview frame changes to occur when the internal frame changes
  // which is important for animatable properties
  if (self.layout) [self layoutView];
}

- (void)setView:(YKSUIView *)view {
  [_view removeFromSuperview];
  [view retain];
  [_view release];  
  _view = view;
  [self addSubview:_view];
  
  if (_view.navigationBar) {
    [self addSubview:_view.navigationBar];
  }
  
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)viewWillAppear:(BOOL)animated {
  [_view _viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [_view viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [_view viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [_view viewDidDisappear:animated];
}

@end

