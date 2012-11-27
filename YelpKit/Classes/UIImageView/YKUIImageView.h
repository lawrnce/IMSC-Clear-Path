//
//  YKUIImageView.h
//  YelpKit
//
//  Created by Gabriel Handford on 12/30/08.
//  Copyright 2008 Yelp. All rights reserved.
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

#import "YKUILayoutView.h"
#import "YKImageLoader.h"


@protocol YKUIImageView <NSObject>
@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSString *URLString;
@end


typedef enum {
  YKUIImageViewStatusNone,
  YKUIImageViewStatusLoading,
  YKUIImageViewStatusLoaded,
  YKUIImageViewStatusErrored
} YKUIImageViewStatus;

@class YKUIImageView;

typedef void (^YKUIImageViewStatusBlock)(id<YKUIImageView> imageView, YKUIImageViewStatus status, UIImage *image);

@protocol YKUIImageViewDelegate <NSObject>
@optional
- (void)imageView:(id<YKUIImageView>)imageView didLoadImage:(UIImage *)image;
- (void)imageViewDidStart:(id<YKUIImageView>)imageView;
- (void)imageView:(id<YKUIImageView>)imageView didError:(YKError *)error;
- (void)imageViewDidCancel:(id<YKUIImageView>)imageView;
@end


/*!
 Image base view. Doesn't draw contents. See YKUIImageView.
 */
@interface YKUIImageBaseView : YKUILayoutView <YKUIImageView, YKImageLoaderDelegate> {
  YKImageLoader *_imageLoader;
  YKUIImageViewStatus _status;
  UIImage *_image;  
  YKUIImageViewStatusBlock _statusBlock;
  id<YKUIImageViewDelegate> _delegate;

  BOOL _renderInBackground;
}

@property (readonly, nonatomic) YKUIImageViewStatus status;
@property (assign, nonatomic) id<YKUIImageViewDelegate> delegate;
@property (readonly, nonatomic) YKImageLoader *imageLoader;
@property (copy, nonatomic) YKUIImageViewStatusBlock statusBlock;

/*!
 Experimental. If YES, the view will render to an image in the background then call setNeedsDisplay.
 Note: If this view is drawn directly using drawInRect:, self.frame.size must be set to the same size
 that will be used with drawInRect:. Otherwise the background rendered image may render with an
 incorrect size.
 The images rendered in the background are automatically added to the in-memory image cache and reused appropriately.
 */
@property (assign, nonatomic) BOOL renderInBackground;

/*!
 Image size.
 @result Image size or CGSizeZero if no image set
 */
@property (readonly, nonatomic) CGSize size;


+ (void)setDisableRenderInBackground:(BOOL)disableRenderInBackground;

- (id)initWithImage:(UIImage *)image;

- (id)initWithURLString:(NSString *)URLString loadingImage:(UIImage *)loadingImage defaultImage:(UIImage *)defaultImage;

/*!
 @result Loading image
 */
- (UIImage *)loadingImage;

// For subclasses to notify when image was loaded asynchronously
- (void)didLoadImage:(UIImage *)image;

/*!
 Cancel any image loading.
 */
- (void)cancel;

- (void)reload;

/*!
 Set URLString to load with loading image and default image (if URL is nil).
 
 @param URLString URL as a string
 @param loadingImage Image to use while loading
 @param defaultImage Default image to use if image is nil
 @param errorImage Error image to use on error
 */
- (void)setURLString:(NSString *)URLString loadingImage:(UIImage *)loadingImage defaultImage:(UIImage *)defaultImage errorImage:(UIImage *)errorImage;

- (void)setURLString:(NSString *)URLString loadingImage:(UIImage *)loadingImage defaultImage:(UIImage *)defaultImage;

- (void)setURLString:(NSString *)URLString defaultImage:(UIImage *)defaultImage;


@end


/*!
 Image view.

 Defaults to non-opaque with white background and fill aspect fit content mode.
 */
@interface YKUIImageView : YKUIImageBaseView { 
  
  UIColor *_strokeColor;
  CGFloat _strokeWidth;
  CGFloat _cornerRadius;
    
  UIColor *_color;
  UIColor *_overlayColor;
  
  UIColor *_shadowColor;
  CGFloat _shadowBlur;
  UIColor *_backgroundColor2;

  UIViewContentMode _imageContentMode;
  
  UIImage *_renderedContents;
  UIImage *_renderedBlankContents;
}

/*!
 Stroke (border) color.
 */
@property (retain, nonatomic) UIColor *strokeColor;

/*!
 Stroke (border) width.
 */
@property (assign, nonatomic) CGFloat strokeWidth;

/*!
 Corner radius.
 */
@property (assign, nonatomic) CGFloat cornerRadius;

/*!
 Border corner radius ratio. For example 1.0 will be the most corner radius (half the height).
 */
@property (assign, nonatomic) CGFloat cornerRadiusRatio;

/*!
 Fill background color.
 */
@property (retain, nonatomic) UIColor *color;

/*!
 Fill background color (2) for shading.
 */
@property (retain, nonatomic) UIColor *color2;

/*!
 Overlay color. Will draw after image.
 */
@property (retain, nonatomic) UIColor *overlayColor;

/*!
 Shadow color.
 */
@property (retain, nonatomic) UIColor *shadowColor;

/*!
 Shadow blur amount.
 */
@property (assign, nonatomic) CGFloat shadowBlur;

/*!
 Content mode with which to draw the image. If unset, this will use self.contentMode.
 @result Current imageContentMode or -1 if unset.
 */
@property (assign, nonatomic) UIViewContentMode imageContentMode;

/*!
 Draw image in rect for current graphics context.

 @param rect Rect
 @param contentMode Content mode
 */
- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode;

@end








