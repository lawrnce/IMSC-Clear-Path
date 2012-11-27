//
//  YKTableViewCell.m
//  YelpKit
//
//  Created by Gabriel Handford on 5/13/12.
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

#import "YKTableViewCell.h"

@implementation YKTableViewCell

@synthesize cellView=_cellView;

- (id)initWithView:(UIView *)view reuseIdentifier:(NSString *)reuseIdentifier {
	NSParameterAssert(view);
	if ((self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
		_cellView = [view retain];
		[self.contentView addSubview:_cellView];
	}
	return self;
}

- (void)dealloc {
	[_cellView release];
	[super dealloc];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGSize contentViewSize = self.contentView.frame.size;
  CGSize cellViewSize = [_cellView sizeThatFits:contentViewSize];
  _cellView.frame = CGRectMake(0, 0, cellViewSize.width, cellViewSize.height);
}

- (CGSize)sizeThatFits:(CGSize)size {
  if (!_cellView) return [super sizeThatFits:size];

  CGSize sizeThatFits = [_cellView sizeThatFits:size];
  sizeThatFits.height += _cellView.frame.origin.y;
	return sizeThatFits;
}

+ (YKTableViewCell *)tableViewCellWithView:(UIView *)view {
	return [self tableViewCellWithView:view reuseIdentifier:nil];
}

+ (YKTableViewCell *)tableViewCellWithView:(UIView *)view reuseIdentifier:(NSString *)reuseIdentifier {
	return [[[YKTableViewCell alloc] initWithView:view reuseIdentifier:reuseIdentifier] autorelease];
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath {
  CGSize sizeThatFits = [_cellView sizeThatFits:CGSizeMake(tableView.frame.size.width, CGFLOAT_MAX)];
  _cellView.frame = CGRectMake(0, 0, tableView.frame.size.width, sizeThatFits.height);  
	return self;
}

@end
