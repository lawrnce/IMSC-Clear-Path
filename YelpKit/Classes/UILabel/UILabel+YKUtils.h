//
//  UILabel+YKUtils.h
//  YelpKit
//
//  Created by John Boiles on 8/1/12.
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

@interface UILabel (YKUtils)

/*!
 By default, UILabel does not conform to NSCopying. This category adds a copy method
 so you can copy the label using [label yk_copy]. We don't use copyWithZone: in case
 Apple decides to implement copyWithZone: in the future.

 @result UILabel with the same properties as self
 */
- (UILabel *)yk_copy;

/*!
 Returns the size that will fit this label. This method respects the label's numberOfLines property.

 @param size Size in which to fit the label. The height may extend beyond size.
 @result Size in which the label will draw.
 */
- (CGSize)yk_multilineSizeThatFits:(CGSize)size;

/*!
 Draws the label in its frame.
 */
- (void)yk_draw;

@end
