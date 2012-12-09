//
//  USCPathNode.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/23/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCPathNode.h"
#import "UIColor+EasySet.h"

@interface USCPathNode()

@property (nonatomic, strong) USCResultCard *card;

@end

@implementation USCPathNode

@synthesize card = _card;
@synthesize trash = _trash;

- (id)initWithFrame:(CGRect)frame withCard:(USCResultCard *)card;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithR:102 G:102 B:102 A:0.4f];
        
        // init paramters
        self.card = card;
    }
    return self;
}

-(void)layoutSubviews;
{
    [super layoutSubviews];
    
    UIImage *sideImage = [UIImage imageNamed:@"Button_small.png"];
    UIImageView *sideImageView = [[UIImageView alloc] initWithImage:sideImage];
    sideImageView.center = CGPointMake(CGRectGetMidX(sideImageView.bounds), CGRectGetMidY(self.bounds));
    [self addSubview:sideImageView];
    
    UILabel *indexNumber = [[UILabel alloc] initWithFrame:CGRectZero];
    indexNumber.backgroundColor = [UIColor clearColor];
    [indexNumber setText:[NSString stringWithFormat:@"S"]];
    indexNumber.textColor = [UIColor whiteColor];
    indexNumber.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    [indexNumber sizeToFit];
    indexNumber.frame = CGRectIntegral(indexNumber.frame);
    indexNumber.center = CGPointMake(CGRectGetMidX(sideImageView.bounds), CGRectGetMidY(sideImageView.bounds));
    [self addSubview:indexNumber];
    
    self.trash = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.trash setBackgroundImage:[UIImage imageNamed:@"gswipe.png"] forState:UIControlStateNormal];
    [self.trash sizeToFit];
    self.trash.center = CGPointMake(CGRectGetMaxX(self.bounds) - CGRectGetMidX(self.trash.bounds), CGRectGetMidY(self.bounds) + 3.0f);
    [self addSubview:self.trash];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.textAlignment = UITextAlignmentCenter;
    [title setText:[NSString stringWithFormat:@"%@", self.card.route.name]];
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    [title sizeToFit];
    title.frame = CGRectIntegral(title.frame);
    title.center = CGPointMake(CGRectGetMaxX(sideImageView.bounds) * 1.5f + CGRectGetMidX(title.bounds), CGRectGetMidY(self.bounds));
    
    // set titleShadow
    UILabel *titleShadow = [[UILabel alloc] initWithFrame:CGRectZero];
    titleShadow.text = title.text;
    titleShadow.font = title.font;
    titleShadow.textColor = [UIColor blackColor];
    titleShadow.backgroundColor = [UIColor clearColor];
    [titleShadow sizeToFit];
    titleShadow.frame = CGRectIntegral(title.frame);
    titleShadow.center = CGPointMake(title.center.x*1.01f, title.center.y*1.005f);
    [self addSubview:titleShadow];
    [self addSubview:title];
}

- (CLLocationCoordinate2D)coordinate;
{
    return [[self.card.route.coordinates lastObject] coordinate];
}

- (NSString *)name;
{
    return self.card.route.name;
}

@end
