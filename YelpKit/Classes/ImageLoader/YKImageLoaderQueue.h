//
//  YKImageLoaderQueue.h
//  YelpKit
//
//  Created by Gabriel Handford on 6/21/12.
//  Copyright (c) 2012 Yelp. All rights reserved.
//

#import "YKImageLoader.h"

/*!
 Image loader queue.
 */
@interface YKImageLoaderQueue : NSObject {
  NSMutableArray *_waitingQueue;
  NSMutableArray *_loadingQueue;
  
  NSInteger _maxLoadingCount;
}

+ (YKImageLoaderQueue *)sharedQueue;

/*!
 Enqueue an image loader.
 @param imageLoader Image laoder to enqueue
 */
- (void)enqueue:(YKImageLoader *)imageLoader;

/*!
 Dequeue an image loader.
 @param imageLoader Image laoder to dequeue
 */
- (void)dequeue:(YKImageLoader *)imageLoader;

/*!
 Check the queue.
 */
- (void)check;

/*!
 Called when the image loader finished.
 @param imageLoader Image loader that finished
 */
- (void)imageLoaderDidEnd:(YKImageLoader *)imageLoader;

@end
