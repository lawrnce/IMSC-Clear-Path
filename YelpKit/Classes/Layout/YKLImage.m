//
//  YKLImage.m
//  YelpKit
//
//  Created by Gabriel Handford on 4/11/12.
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

#import "YKLImage.h"

@implementation YKLImage

@synthesize insets=_insets;

- (id)initWithImage:(UIImage *)image {
  if ((self = [super init])) {
    _image = [image retain];
    _insets = UIEdgeInsetsZero;
  }
  return self;
}

- (void)dealloc {
  [_image release];
  [super dealloc];
}

- (CGSize)sizeThatFits:(CGSize)size {
  if (!_image) return CGSizeZero;
  return CGSizeMake(_image.size.width + _insets.left + _insets.right, _image.size.height + _insets.top + _insets.bottom);
}

- (void)drawInRect:(CGRect)rect {
  if (!_image) return;
  if (rect.size.width == 0) rect.size.width = _image.size.width;
  if (rect.size.height == 0) rect.size.height = _image.size.height;
  rect.origin.x += _insets.left;
  rect.origin.y += _insets.top;
  rect.size.width += _insets.left + _insets.right;
  rect.size.height += _insets.bottom + _insets.top;
  [_image drawAtPoint:CGPointMake(rect.origin.x, rect.origin.y)];
}

@end
