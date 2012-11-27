//
//  YKCatalogTestView.h
//  YelpKit
//
//  Created by Gabriel Handford on 8/2/12.
//  Copyright (c) 2012 Yelp. All rights reserved.
//

#import "YKSUIView.h"

@interface YKCatalogTestView : YKUILayoutView {
  YKUIButton *_button;
}

+ (YKSUIView *)testStackView;

+ (YKSUIView *)testStackViewWithName:(NSString *)name;

@end
