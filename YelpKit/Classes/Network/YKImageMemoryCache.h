//
//  YKImageMemoryCache.h
//  YelpKit
//
//  Created by Amir Haghighat  on 5/16/12.
//  Copyright 2012 Yelp. All rights reserved.
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

@interface YKImageMemoryCache : NSObject {
  NSMutableDictionary *_imageCache;
  NSMutableArray *_imageSortedList;
  NSInteger _totalPixelCount;
  NSUInteger _maxPixelCount;
}

/*!
 The maximum number of pixels to keep in memory for cached images.
 
 Setting this to zero will allow an unlimited number of images to be cached. The default is 262,144.
 */
@property (nonatomic) NSUInteger maxPixelCount;

/*!
 Get shared cache.
 */
+ (YKImageMemoryCache *)sharedCache;

/**
 Stores an image in the memory cache.
 */
- (BOOL)cacheImage:(UIImage *)image forKey:(NSString *)key;

/**
 Retrieves an image from the memory cache.
 */
- (UIImage *)memoryCachedImageForKey:(NSString *)key;

/*!
 Erases the cache.
 */
- (void)clearCache;

@end
