//
//  USCResultInformation.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/23/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCResultInformation.h"

@implementation USCResultInformation

@synthesize card = _card;
@synthesize start = _start;
@synthesize end = _end;

- (id)initWithFrame:(CGRect)frame withCard:(USCResultCard *)card;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.card = card;
        
        // Initialization code
        self.start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.start setTitle:@"<" forState:UIControlStateNormal];
        [self.start sizeToFit];
        [self addSubview:self.start];
        
        self.end = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.end setTitle:@">" forState:UIControlStateNormal];
        [self.end sizeToFit];
        [self addSubview:self.end];
    }
    return self;
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    self.start.center = CGPointMake(CGRectGetMidX(self.start.bounds), CGRectGetMaxY(self.bounds) - CGRectGetMidY(self.start.bounds));
    
    self.end.center = CGPointMake(CGRectGetMaxX(self.bounds) - CGRectGetMidX(self.end.bounds), CGRectGetMaxY(self.bounds) - CGRectGetMidY(self.end.bounds));
}

@end
