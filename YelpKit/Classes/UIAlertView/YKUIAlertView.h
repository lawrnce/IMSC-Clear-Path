//
//  YKUIAlertView.h
//  YelpKit
//
//  Created by Gabriel Handford on 7/16/09.
//  Copyright 2009 Yelp. All rights reserved.
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

typedef void (^YKUIAlertViewBlock)(NSInteger index);

/*!
 Utility methods for UIAlertView.
 */
@interface YKUIAlertView : NSObject <UIAlertViewDelegate> {
  YKUIAlertViewBlock _block;
}

- (id)initWithTarget:(id)target action:(SEL)action context:(id)context;

/*!
 Show alert with block callback.
 @param block YKUIAlertViewBlock that is called when the user presses a button
 @param title
 @param message
 @param cancelButtonTitle
 @param otherButtonTitle
 */
+ (void)showAlertWithBlock:(YKUIAlertViewBlock)block title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showAlertWithBlock:(YKUIAlertViewBlock)block title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle args:(va_list)args;

/*!
 Show alert with target/selector callback.
 @param target
 @param action
  Selector of the form myAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index;
  If context is not nil, selector of the form myAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index context:(id)context;
 @param context Context passed to action (if not nil)
 @param title
 @param message
 @param cancelButtonTitle
 @param otherButtonTitle
 */
+ (void)showAlertWithTarget:(id)target action:(SEL)action context:(id)context title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showAlertWithTarget:(id)target action:(SEL)action context:(id)context title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle args:(va_list)args;

/*!
 Show OK alert.
 @param message
 @param title
 @result Alert view
 */
+ (UIAlertView *)showOKAlertWithMessage:(NSString *)message title:(NSString *)title;

/*!
 Show (simple) alert.
 @param message
 @param title
 @param cancelButtonTitle
 @result Alert view
 */
+ (UIAlertView *)showAlertWithMessage:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle;

@end

@protocol YKUIAlertViewActions
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex context:(id)context; // If context not nil
@end


/*!
 Target, action for use in showAlertWithTarget context.
 */
@interface YKUIAlertViewTarget : NSObject {
  
  id _target; // weak
  SEL _action;
  
}

- (id)initWithTarget:(id)target action:(SEL)action;

+ (YKUIAlertViewTarget *)target:(id)target action:(SEL)action;

- (void)perform;

@end
