//
//  USCResultCard.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/14/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCResultCard.h"
#import "UIColor+EasySet.h"

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

- (id)initWithFrame:(CGRect)frame withRoute:(USCRoute *)r delegate:(id<USCResultCardDelegate>)delegate;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // set delegate
        [self setDelegate:delegate];
        
        self.route = r;
        
        self.userInteractionEnabled = YES;
        
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithR:254 G:254 B:232 A:1]];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.subtitle = [[UILabel alloc] initWithFrame:CGRectZero];
        
        self.touchGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        self.touchGestureRecognizer.delegate = self;
        [self addGestureRecognizer:self.touchGestureRecognizer];
        
        // init sideButton
        self.sideButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.sideButton addTarget:self action:@selector(_willRouteAsDestination) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Layout Subview

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    // position title and subtitle
    [self.title setText:self.route.name];
    self.title.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    [self.title sizeToFit];
    self.title.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [self addSubview:self.title];
    
    // position sideButton
    [self.sideButton setTitle:@">" forState:UIControlStateNormal];
    [self.sideButton sizeToFit];
    self.sideButton.center = CGPointMake(CGRectGetMaxX(self.bounds) * 0.9f, CGRectGetMidY(self.bounds));
    [self addSubview:self.sideButton];
}

#pragma mark - Handle Gestures

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [UIView animateWithDuration:0.1f animations:^{
        
        self.alpha = 0.6;
        
    }];
    
    NSLog(@"Touched");
}

- (void)handleGesture:(UITapGestureRecognizer *)gesture;
{
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
         NSLog(@"Touch Ended");
        
        [self _willShowInformation];
        
        [UIView animateWithDuration:0.1f animations:^{
            
            self.alpha = 1.0;
            
        }];
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
