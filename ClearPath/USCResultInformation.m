//
//  USCResultInformation.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/23/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCResultInformation.h"
#import "UIColor+EasySet.h"

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
        self.start = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.start setBackgroundImage:[UIImage imageNamed:@"Button_Green.png"] forState:UIControlStateNormal];
        [self.start sizeToFit];
        [self addSubview:self.start];
        
        self.end = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.end setBackgroundImage:[UIImage imageNamed:@"Button_Red.png"] forState:UIControlStateNormal];
        [self.end sizeToFit];
        [self addSubview:self.end];
    }
    return self;
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    self.start.center = CGPointMake(CGRectGetMidX(self.start.bounds),
                                    CGRectGetMaxY(self.bounds) - CGRectGetMidY(self.start.bounds));
    
    self.end.center = CGPointMake(CGRectGetMaxX(self.bounds) - CGRectGetMidX(self.end.bounds),
                                  CGRectGetMaxY(self.bounds) - CGRectGetMidY(self.end.bounds));
    
    UILabel *start = [[UILabel alloc] initWithFrame:CGRectZero];
    [start setText:@"Start"];
    start.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    start.backgroundColor = [UIColor clearColor];
    start.textColor = [UIColor whiteColor];
    [start sizeToFit];
    start.frame = CGRectIntegral(start.frame);
    start.center = self.start.center;
    [self addSubview:start];
    
    UILabel *end = [[UILabel alloc] initWithFrame:CGRectZero];
    [end setText:@"End"];
    end.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    end.backgroundColor = [UIColor clearColor];
    end.textColor = [UIColor whiteColor];
    [end sizeToFit];
    end.frame = CGRectIntegral(end.frame);
    end.center = self.end.center;
    [self addSubview:end];
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectZero];
    [time setText:self.card.route.travelTime];
    time.font = [UIFont fontWithName:@"Helvetica-Bold" size:32];
    [time sizeToFit];
    time.textColor = [UIColor colorWithR:143 G:188 B:219 A:1];
    time.backgroundColor = [UIColor clearColor];
    time.frame = CGRectIntegral(time.frame);
    time.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(time.bounds));
    
    UILabel *titleShadow = [[UILabel alloc] initWithFrame:CGRectZero];
    titleShadow.text = time.text;
    titleShadow.font = time.font;
    titleShadow.textColor = [UIColor blackColor];
    titleShadow.backgroundColor = [UIColor clearColor];
    [titleShadow sizeToFit];
    titleShadow.frame = CGRectIntegral(time.frame);
    titleShadow.center = CGPointMake(time.center.x*1.015f, time.center.y*1.015f);
    [self addSubview:titleShadow];
    [self addSubview:time];
    
    
    
}

@end
