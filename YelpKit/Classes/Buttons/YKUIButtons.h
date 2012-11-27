//
//  YKUIButtons.h
//  YelpKit
//
//  Created by Gabriel Handford on 3/22/12.
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

#import "YKUILayoutView.h"
@class YKUIButton;

typedef enum {
  YKUIButtonsStyleHorizontal = 0, // Default
  YKUIButtonsStyleVertical,
  YKUIButtonsStyleHorizontalRounded, // Horizontal with rounded ends
  YKUIButtonsStyleVerticalRounded, // Vertical with rounded ends
} YKUIButtonsStyle;

typedef enum {
  YKUIButtonsSelectionModeNone = 0, // Default
  YKUIButtonsSelectionModeSingle, // Only select 1 (no toggle)
  YKUIButtonsSelectionModeMultiple, // Can toggle multiple on and off
  YKUIButtonsSelectionModeSingleToggle, // Only select 1 (toggle)
} YKUIButtonsSelectionMode;

typedef void (^YKUIButtonsApplyBlock)(YKUIButton *button, NSInteger index);


@class YKUIButtons;

@protocol YKUIButtonsDelegate <NSObject>
/*!
 Notified when a button is selected.
 */
- (void)buttons:(YKUIButtons *)buttons didSelectButton:(YKUIButton *)button index:(NSInteger)index previousButton:(YKUIButton *)previousButton;

@optional
/*!
 Allows the delegate to veto a selection.
 @param button
 */ 
- (BOOL)buttons:(YKUIButtons *)buttons shouldSelectButton:(YKUIButton *)button index:(NSInteger)index;
@end

/*!
 A group of buttons (either horizontal or vertical). This is similar to a segmented control.
 */
@interface YKUIButtons : YKUILayoutView {
  NSMutableArray *_buttons;
  
  UIEdgeInsets _insets;
  YKUIButtonsStyle _style;
  YKUIButtonsSelectionMode _selectionMode;
  
  YKUIButtonsApplyBlock _applyBlock;
  
  id<YKUIButtonsDelegate> _delegate;
}

/*!
 Selected index.
 */
@property (assign, nonatomic) NSInteger selectedIndex;

/*!
 Selected indices.
 */
@property (retain, nonatomic) NSArray *selectedIndices;

/*!
 Insets.
 */
@property (assign, nonatomic) UIEdgeInsets insets;

/*!
 Selection mode.
 */
@property (assign, nonatomic) YKUIButtonsSelectionMode selectionMode;

/*!
 Delegate.
 */
@property (assign, nonatomic) id<YKUIButtonsDelegate> delegate;

/*!
 Create a number of buttons.
 @param count
 @param style Style, use rounded style if you want the YKUIButton border style to be automatically set.
 @param apply
 */
- (id)initWithCount:(NSInteger)count style:(YKUIButtonsStyle)style apply:(YKUIButtonsApplyBlock)apply;

/*!
 Create a set of buttons.
 @param buttons List of YKUIButton
 @param style Style, use rounded style if you want the YKUIButton border style to be automatically set.
 @param apply
 */
- (id)initWithButtons:(NSArray */*of YKUIButton*/)buttons style:(YKUIButtonsStyle)style apply:(YKUIButtonsApplyBlock)apply;

/*!
 Create buttons with titles.
 @param titles Titles
 @param style Style, use rounded style if you want the YKUIButton border style to be automatically set.
 @param apply
 */
- (id)initWithTitles:(NSArray *)titles style:(YKUIButtonsStyle)style apply:(YKUIButtonsApplyBlock)apply;

/*!
 Create buttons with no buttons. Use setButtons to add them.
 @param style Style, use rounded style if you want the YKUIButton border style to be automatically set.
 */
- (id)initWithStyle:(YKUIButtonsStyle)style;

/*!
 @result The buttons
 */
- (NSArray *)buttons;

/*!
 Set buttons.
 @param buttons
 @apram apply
 */
- (void)setButtons:(NSArray *)buttons apply:(YKUIButtonsApplyBlock)apply;

/*!
 Set disabled at button index.
 @param enabled
 @param index
 */
- (void)setEnabled:(BOOL)enabled index:(NSInteger)index;

/*!
 Set all buttons enabled/disabled.
 @param enabled
 */
- (void)setEnabled:(BOOL)enabled;

/*!
 Select button.
 @param selected
 @param button
 */
- (void)setSelected:(BOOL)selected button:(YKUIButton *)button;

/*!
 @result Selected button or nil
 */
- (YKUIButton *)selectedButton;

/*!
 @result Number of buttons
 */
- (NSInteger)count;

/*!
 Set button titles. Does not create buttons.
 @param titles Titles
 */
- (void)setTitles:(NSArray *)titles;

/*!
 @result Index for title, or NSNotFound
 */
- (NSInteger)indexOfTitle:(NSString *)title;

/*!
 Set selected for button with title.
 @param selected
 @param title
 @result YES if set selected, NO if not found
 */
- (BOOL)setSelected:(BOOL)selected title:(NSString *)title;

/*!
 @result Currently selected title, or nil
 */
- (NSString *)selectedTitle;

/*!
 Clear selected.
 */
- (void)clearSelected;

/*!
 Set selected.
 @param selected
 @param index
 */
- (void)setSelected:(BOOL)selected index:(NSInteger)index;

/*!
 @result YES if selected at index
 */
- (BOOL)isSelectedAtIndex:(NSInteger)index;

/*!
 Add button.
 @param button
 */
- (void)addButton:(YKUIButton *)button;

/*!
 Remove button.
 @param button
 */
- (void)removeButton:(YKUIButton *)button;

/*!
 Remove all buttons.
 */
- (void)removeAllButtons;

/*!
 Remove button with title.
 @param title
 */
- (BOOL)removeButtonWithTitle:(NSString *)title;

/*!
 Set button at index.
 @param button
 @param index
 @param animated
 */
- (void)setButton:(YKUIButton *)button index:(NSInteger)index animated:(BOOL)animated;

/*!
 Find button with title.
 @param title
 @result Button or nil if not found
 */
- (YKUIButton *)buttonWithTitle:(NSString *)title;

@end
