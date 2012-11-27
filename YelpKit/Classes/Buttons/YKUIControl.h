//
//  YKUIControl.h
//  YelpKit
//
//  Created by Gabriel Handford on 10/27/09.
//  Copyright 2009 Yelp. All rights reserved.
//

#import "YKLayout.h"

typedef void (^UIControlTargetBlock)();

/*!
 UIControl with some helpers.

 Also implements YKLayout.
 */
@interface YKUIControl : UIControl {
  id _target; // weak
  SEL _action;
  
  BOOL _highlightedEnabled;
  BOOL _selectedEnabled;

  BOOL _delayActionEnabled;

  id _context;
  
  UIControlTargetBlock _targetBlock;
  BOOL _targetDisabled;
  
  id<YKLayout> _layout;
  
  NSString *_valueForCopy;
  UILongPressGestureRecognizer *_longPressGestureRecognizer;
}

@property (readonly, nonatomic) id target;
@property (readonly, nonatomic) SEL action;
@property (assign, nonatomic, getter=isHighlightedEnabled) BOOL highlightedEnabled; // If YES, will set highlighted state while in between touch begin/end (or cancel); Default is NO
@property (assign, nonatomic, getter=isSelectedEnabled) BOOL selectedEnabled; // If YES, will set selected state when touch (ended); Default is NO
@property (assign, nonatomic, getter=isDelayActionEnabled) BOOL delayActionEnabled; // If YES, the action on the control is delayed in order to display the highlighted state
@property (retain, nonatomic) id<YKLayout> layout;
@property (retain, nonatomic) id context;
@property (copy, nonatomic) UIControlTargetBlock targetBlock;
@property (retain, nonatomic) NSString *valueForCopy;

/*!
 If YES, then touching the button will not callTarget.
 */
@property (assign, nonatomic, getter=isTargetDisabled) BOOL targetDisabled;

/*!
 This method gets called by both initWithFrame and initWithCoder. Subclasses taking advantage of
 this method should make sure to call [super sharedInit] at the top of their implementation
 of sharedInit
 */
- (void)sharedInit;

/*!
 Removes all targets.
 Does NOT remove or clear the setTarget:action:.
 */
- (void)removeAllTargets;

/*!
 Removes all targets.
 Does NOT remove targets that the control has set for itself.
 */
+ (void)removeAllTargets:(UIControl *)control;

/*!
 Check if touches are all inside this view.
 @param touches
 @param event
 @result YES if all touches are inside control
 */
- (BOOL)touchesAllInView:(NSSet */*of UITouch*/)touches withEvent:(UIEvent *)event;

/*!
 Check if touches are all inside the view.
 @param view
 @param touches
 @param event
 @result YES if all touches are inside the view
*/
+ (BOOL)touchesAllInView:(UIView *)view touches:(NSSet */*of UITouch*/)touches withEvent:(UIEvent *)event;

/*!
 Set target and action.
 Will pass self as the argument.
 Selected status is set before this method is called.
 @param target
 @param action
 */
- (void)setTarget:(id)target action:(SEL)action;

/*!
 Set target and action.
 Will pass context as the argument or self if context is nil.
 Selected status is set before this method is called.
 @param target
 @param action
 @param context Weak
 */
- (void)setTarget:(id)target action:(SEL)action context:(id)context;

/*!
 Add a target.
 @param target
 @param action
 */
- (void)addTarget:(id)target action:(SEL)action;

/*!
 Call the target and targetBlock. This is what is called automatically on the touch up inside event.
 */
- (void)callTarget;

/*!
 Force the layout, if using YKLayout.
 You can use this instead of setNeedsLayout + layoutIfNeeded.
 This is also useful when using animations and setNeedsLayout + layoutIfNeeded don't work as expected.
 */
- (void)layoutView;

@end
