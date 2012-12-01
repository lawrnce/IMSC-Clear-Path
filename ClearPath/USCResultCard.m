//
//  USCResultCard.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/14/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCResultCard.h"
#import "UIColor+EasySet.h"
#import "UIImage+Loading.h"

#define kContetViewInserts UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)
#define kTitleViewInserts UIEdgeInsetsMake(3.0f, 0.0f, 7.0f, 0.0f)

@interface USCResultCard ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *sideButton;

@end

@implementation USCResultCard

@synthesize touchGestureRecognizer = _touchGestureRecognizer;

@synthesize route = _route;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

@synthesize contentView = _contentView;
@synthesize sideButton = _sideButton;

- (id)initWithFrame:(CGRect)frame withRoute:(USCRoute *)r delegate:(id<USCResultCardDelegate>)delegate withIndex:(int)index;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // set delegate
        [self setDelegate:delegate];
        
        self.backgroundColor = [UIColor colorWithR:102 G:102 B:102 A:0.4f];
        
        self.route = r;
        
        _index = index;
        
        self.userInteractionEnabled = YES;
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.subtitle = [[UILabel alloc] initWithFrame:CGRectZero];
        
        self.touchGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        self.touchGestureRecognizer.delegate = self;
        [self addGestureRecognizer:self.touchGestureRecognizer];
        
        // init sideButton
        self.sideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sideButton.userInteractionEnabled = YES;
        [self.sideButton setBackgroundImage:[UIImage imageNamed:@"FArrow_small.png"] forState:UIControlStateNormal];
        self.sideButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.sideButton sizeToFit];
        [self.sideButton addTarget:self action:@selector(_willRouteAsDestination) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

#pragma mark - Layout Subview

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [indexButton setBackgroundImage:[UIImage imageNamed:@"Button_medium.png"] forState:UIControlStateNormal];
    [indexButton sizeToFit];
    indexButton.center = CGPointMake(CGRectGetMidX(indexButton.bounds), CGRectGetMidY(self.bounds));
    [self addSubview:indexButton];
    [indexButton addTarget:self action:@selector(_willShowInformation) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *indexNumber = [[UILabel alloc] initWithFrame:CGRectZero];
    indexNumber.backgroundColor = [UIColor clearColor];
    
    [indexNumber setText:[NSString stringWithFormat:@"%d", _index]];
    indexNumber.textColor = [UIColor whiteColor];
    indexNumber.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25];
    [indexNumber sizeToFit];
    indexNumber.frame = CGRectIntegral(indexNumber.frame);
    indexNumber.center = CGPointMake(CGRectGetMidX(indexButton.bounds), CGRectGetMidY(indexButton.bounds)-2);
    [indexButton addSubview:indexNumber];

    
    
    
    
    
    
    // position title and subtitle
    [self.title setText:self.route.name];
    self.title.textAlignment = UITextAlignmentLeft;
    self.title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    self.title.textColor = [UIColor colorWithR:51 G:51 B:255 A:1];
    self.title.textColor = [UIColor whiteColor];
    self.title.backgroundColor = [UIColor clearColor];
    [self.title sizeToFit];
    [self.title setFrame:CGRectMake(CGRectGetMaxX(indexButton.bounds) + 5.0f, indexButton.frame.origin.y,
                                    CGRectGetMidX(self.bounds), CGRectGetMaxY(self.title.bounds))];
    self.title.frame = CGRectIntegral(self.title.frame);
    
    CGSize maximumLabelSize = CGSizeMake(296, 9999);
    CGSize expectedLabelSize = [self.route.name sizeWithFont:self.title.font constrainedToSize:maximumLabelSize lineBreakMode:self.title.lineBreakMode];
    CGRect newFrame = self.title.frame;
    newFrame.size.width = expectedLabelSize.width;
    self.title.frame = newFrame;
    [self makeShadowForLabel:self.title];
    [self addSubview:self.title];
    
    
    
    
    
    
    // position address
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectZero];
    [address setText:self.route.address];
    address.textAlignment = UITextAlignmentLeft;
    address.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    address.textColor = [UIColor whiteColor];
    address.backgroundColor = [UIColor clearColor];
    [address sizeToFit];
    address.frame = CGRectMake(self.title.frame.origin.x + 20.0f, self.title.frame.origin.y+CGRectGetMaxY(self.title.bounds),
                                                        CGRectGetMaxX(self.title.bounds) - 20, CGRectGetMaxY(address.bounds));
//    [self makeShadowForLabel:address];
//    [self addSubview:address];

    // set time
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectZero];
    [time setText:self.route.travelTime];
    time.textAlignment = UITextAlignmentLeft;
    time.backgroundColor = [UIColor clearColor];
    time.textColor = [UIColor colorWithR:51 G:51 B:255 A:1];
    time.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [time sizeToFit];
    time.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y + CGRectGetMaxY(self.title.bounds),
                              CGRectGetMaxX(time.bounds), CGRectGetMaxY(time.bounds));
    time.frame = CGRectIntegral(time.frame);
    [self addSubview:time];
    
    self.sideButton.center = CGPointMake(CGRectGetMaxX(self.bounds) * 0.95f, CGRectGetMidY(self.bounds));
    [self addSubview:self.sideButton];
}

- (void)makeShadowForLabel:(UILabel *)label;
{
    // set titleShadow
    UILabel *titleShadow = [[UILabel alloc] initWithFrame:CGRectZero];
    titleShadow.text = label.text;
    titleShadow.font = label.font;
    titleShadow.textColor = [UIColor blackColor];
    titleShadow.backgroundColor = [UIColor clearColor];
    [titleShadow sizeToFit];
    titleShadow.frame = CGRectIntegral(self.title.frame);
    titleShadow.center = CGPointMake(label.center.x*1.01f, label.center.y*1.005f);
    [self addSubview:titleShadow];
}

#pragma mark - Handle Gestures

- (void)handleGesture:(UITapGestureRecognizer *)gesture;
{
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
         NSLog(@"Touch Ended");
        
        
    
    }
}

#pragma mark - Delegate Passing

- (void)_willRouteAsDestination;
{
    if ([self.delegate respondsToSelector:@selector(willRouteAsDestination:)])
        [self.delegate willRouteAsDestination:self.route];
}

- (void)_willShowInformation;
{
    if ([self.delegate respondsToSelector:@selector(willShowInformation:)])
        [self.delegate willShowInformation:self];
}

@end
