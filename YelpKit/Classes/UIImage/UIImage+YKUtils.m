//
//  UIImage+YKUtils.m
//  YelpKit
//
//  Created by John Boiles on 5/9/12.
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

#import "UIImage+YKUtils.h"
#import "YKCGUtils.h"

@implementation UIImage (YKUtils)

+ (UIImage *)imageFromDrawOperations:(void(^)(CGContextRef context))drawOperations size:(CGSize)size opaque:(BOOL)opaque {
  UIGraphicsBeginImageContextWithOptions(size, opaque, [[UIScreen mainScreen] scale]);
  CGContextRef context = UIGraphicsGetCurrentContext();
  // Flip coordinate system, otherwise image will be drawn upside down
  CGContextTranslateCTM(context, 0, size.height);
  CGContextScaleCTM (context, 1.0, -1.0);
  drawOperations(context);
  UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return renderedImage;
}

- (UIImage *)resizedImageInSize:(CGSize)size contentMode:(UIViewContentMode)contentMode opaque:(BOOL)opaque {
  CGRect imageRect = YKCGRectConvert(CGRectMake(0, 0, size.width, size.height), self.size, contentMode);

  UIImage *resizedImage = [UIImage imageFromDrawOperations:^(CGContextRef context) {
     CGContextDrawImage(context, CGRectMake(0, 0, imageRect.size.width, imageRect.size.height), self.CGImage);
  } size:imageRect.size opaque:opaque];

  return resizedImage;
}

@end
