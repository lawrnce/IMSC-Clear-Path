//
//  USCRecents.m
//  ClearPath
//
//  Created by Lawrence Tran on 9/25/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCRecents.h"

@interface USCRecents () 

@property (nonatomic, strong) UILabel *titleShadow;

@end

@implementation USCRecents

@synthesize tableView = _tableView;
@synthesize title = _title;

@synthesize titleShadow = _titleShadow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // set defaults
        self.backgroundColor = //[UIColor colorWithRed:254.0f green:254.0f blue:232.0f alpha:.4f];
        [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        // titleShadow
        self.titleShadow = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleShadow.userInteractionEnabled = NO;
        [self addSubview:self.titleShadow];
        
        // title
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.userInteractionEnabled = NO;
        [self addSubview:self.title];
        
        // tableView
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark - Layout Methods

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    // set title
    self.title.font = [UIFont fontWithName:@"Helvetica-Bold" size:77];
    self.title.text = [NSString stringWithFormat:@"Recents"];
    self.title.textColor = [UIColor colorWithRed:254.0f green:254.0f blue:232.0f alpha:1.0f];
    self.title.backgroundColor = [UIColor clearColor];
    [self.title sizeToFit];
    self.title.frame = CGRectIntegral(self.title.frame);
    self.title.center = CGPointMake(self.title.center.x, 40);
    
    // set titleShadow
    self.titleShadow.font = [UIFont fontWithName:@"Helvetica-Bold" size:77];
    self.titleShadow.text = [NSString stringWithFormat:@"Recents"];
    self.titleShadow.textColor = [UIColor lightGrayColor];
    self.titleShadow.backgroundColor = [UIColor clearColor];
    [self.titleShadow sizeToFit];
    self.titleShadow.frame = CGRectIntegral(self.title.frame);
    self.titleShadow.center = CGPointMake(self.title.center.x*1.015f, self.title.center.y*1.05f);
    
    // set tableView
    self.tableView.frame = CGRectMake(CGRectGetMidX(self.bounds)*.1f,
                                      CGRectGetMaxY(self.title.bounds)*.9f,
                                      CGRectGetMaxX(self.bounds)*.9f,
                                      CGRectGetMaxY(self.bounds) - CGRectGetMaxY(self.title.bounds)*.9f);
}



@end
