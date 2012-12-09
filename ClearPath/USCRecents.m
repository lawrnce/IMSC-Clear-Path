//
//  USCRecents.m
//  ClearPath
//
//  Created by Lawrence Tran on 9/25/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCRecents.h"
#import "UIColor+EasySet.h"

@interface USCRecents () 

@property (nonatomic, strong) UILabel *titleShadow;

@end

@implementation USCRecents

@synthesize title = _title;
@synthesize titleShadow = _titleShadow;
@synthesize gas = _gas;
@synthesize food = _food;
@synthesize hospital = _hospital;

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // set defaults
        self.backgroundColor = //[UIColor colorWithRed:254.0f green:254.0f blue:232.0f alpha:.4f];
        [UIColor clearColor];
//        self.userInteractionEnabled = YES;
        
        // titleShadow
        self.titleShadow = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleShadow.userInteractionEnabled = NO;
        [self addSubview:self.titleShadow];
        
        // title
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.userInteractionEnabled = NO;
        [self addSubview:self.title];
        
    }
    return self;
}

#pragma mark - Layout Methods

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    // set title
    self.title.font = [UIFont fontWithName:@"Helvetica-Bold" size:65];
    self.title.text = [NSString stringWithFormat:@"Favorites"];
    self.title.textColor = [UIColor colorWithRed:254.0f green:254.0f blue:232.0f alpha:1.0f];
    self.title.backgroundColor = [UIColor clearColor];
    [self.title sizeToFit];
    self.title.frame = CGRectIntegral(self.title.frame);
    self.title.center = CGPointMake(self.title.center.x, 40);
    
    // set titleShadow
    self.titleShadow.font = [UIFont fontWithName:@"Helvetica-Bold" size:65];
    self.titleShadow.text = [NSString stringWithFormat:@"Favorites"];
    self.titleShadow.textColor = [UIColor lightGrayColor];
    self.titleShadow.backgroundColor = [UIColor colorWithR:102 G:102 B:102 A:0.3f];
    [self.titleShadow sizeToFit];
    self.titleShadow.frame = CGRectIntegral(self.title.frame);
    self.titleShadow.center = CGPointMake(self.title.center.x*1.015f, self.title.center.y*1.05f);
    
    // set gas
    self.gas = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gas setBackgroundImage:[UIImage imageNamed:@"gas.png"] forState:UIControlStateNormal];
    [self.gas sizeToFit];
    self.gas.center = CGPointMake(CGRectGetMidX(self.bounds) - CGRectGetMidX(self.gas.bounds) - 15.0f,
                              CGRectGetMidY(self.bounds) - CGRectGetMidY(self.gas.bounds) - 10.0f);
    [self addSubview:self.gas];
    
    // set hospital
    self.hospital = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hospital setBackgroundImage:[UIImage imageNamed:@"hospital.png"] forState:UIControlStateNormal];
    [self.hospital sizeToFit];
    self.hospital.center = CGPointMake(CGRectGetMidX(self.bounds) + CGRectGetMidX(self.gas.bounds) + 5.0f,
                              CGRectGetMidY(self.bounds) - CGRectGetMidY(self.gas.bounds) - 10.0f);
    [self addSubview:self.hospital];
    
    // set food
    self.food = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.food setBackgroundImage:[UIImage imageNamed:@"food.png"] forState:UIControlStateNormal];
    [self.food sizeToFit];
    self.food.center = CGPointMake(CGRectGetMidX(self.bounds) - CGRectGetMidX(self.gas.bounds) - 15.0f,
                                       CGRectGetMidY(self.bounds) + CGRectGetMidY(self.gas.bounds) + 10.0f);
    [self addSubview:self.food];
    
    // set add
    UIButton *magic = [UIButton buttonWithType:UIButtonTypeCustom];
    [magic setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [magic sizeToFit];
    magic.center = CGPointMake(CGRectGetMidX(self.bounds) + CGRectGetMidX(self.gas.bounds) + 5.0f,
                                   CGRectGetMidY(self.bounds) + CGRectGetMidY(self.gas.bounds) + 10.0f);
    [self addSubview:magic];
}

@end
