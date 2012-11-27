//
//  USCResultInformation.h
//  ClearPath
//
//  Created by Lawrence Tran on 11/23/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USCResultCard.h"

@interface USCResultInformation : UIView
{
    USCRoute *_route;
}

@property (nonatomic, strong) USCResultCard *card;
@property (nonatomic, strong) UIButton *start;
@property (nonatomic, strong) UIButton *end;

- (id)initWithFrame:(CGRect)frame withCard:(USCResultCard *)card;

@end
