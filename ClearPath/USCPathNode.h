//
//  USCPathNode.h
//  ClearPath
//
//  Created by Lawrence Tran on 11/23/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USCResultCard.h"

@interface USCPathNode : UIView

- (id)initWithFrame:(CGRect)frame withCard:(USCResultCard *)card;

- (CLLocationCoordinate2D)coordinate;
- (NSString *)name;

@end
