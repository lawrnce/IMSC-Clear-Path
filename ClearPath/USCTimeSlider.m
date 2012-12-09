//
//  USCTimeSlider.m
//  ClearPath
//
//  Created by Lawrence Tran on 12/3/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCTimeSlider.h"

#import "NSDate+RoundTime.h"
#import "UIColor+EasySet.h"

@interface USCTimeSlider ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) UILabel *departureTimeLabel;
@property (nonatomic, strong) UIControl *departureTimeControl;
@property (nonatomic, strong) UIEvent *departureTimeEvent;

@property (nonatomic, strong) UIView *depatureTimePanView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation USCTimeSlider

@synthesize dateFormatter = _dateFormatter;
@synthesize currentDate = _currentDate;

@synthesize departureTimeLabel = _departureTimeLabel;
@synthesize departureTimeControl = _departureTimeControl;
@synthesize departureTimeEvent = _departureTimeEvent;

@synthesize depatureTimePanView = _depatureTimePanView;
@synthesize panGestureRecognizer = _panGestureRecognizer;

@synthesize start = _start;
@synthesize end = _end;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {        
        // init date control
        self.depatureDate = [[NSDate alloc]init];
        
//        self.backgroundColor = [UIColor colorWithR:102 G:102 B:102 A:0.4f];
    }
    return self;
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    // init date
    self.currentDate = [[NSDate alloc] init];
    
    // init dateFormatter
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *currentTime = [self.dateFormatter stringFromDate:self.currentDate];
    
    // init departureTimeLabel
    self.departureTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.departureTimeLabel.textColor = [UIColor colorWithR:143 G:188 B:219 A:1];
    self.departureTimeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:60];
    self.departureTimeLabel.backgroundColor = [UIColor colorWithR:255 G:255 B:255 A:0.5f];
    [self.departureTimeLabel setText:currentTime];
    [self.departureTimeLabel sizeToFit];
    self.departureTimeLabel.frame = CGRectMake(0, 0, 300, CGRectGetMaxY(self.departureTimeLabel.bounds));
    self.departureTimeLabel.center = CGPointMake(CGRectGetMidX(self.bounds) + 40, CGRectGetMidY(self.bounds));
    [self addSubview:self.departureTimeLabel];
    
    // init panGestureRecognizer
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.panGestureRecognizer addTarget:self action:@selector(touchDown:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    // Create descriptive labels
    UILabel *depatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    depatureLabel.backgroundColor = [UIColor colorWithR:255 G:255 B:255 A:0.5f];
    depatureLabel.textColor = [UIColor colorWithR:143 G:188 B:219 A:1];
    depatureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:35];
    depatureLabel.text = [NSString stringWithFormat:@"Departure Time"];
    [depatureLabel sizeToFit];
    depatureLabel.center = CGPointMake(CGRectGetMidX(self.bounds), - CGRectGetMidY(depatureLabel.bounds));
    [self addSubview:depatureLabel];
}

#pragma mark - PanGesture Methods

- (void)touchDown:(UIPanGestureRecognizer *)gesture;
{
    switch (gesture.state)
    {
            
        case UIGestureRecognizerStateBegan:
        {
            self.depatureDate = [self.depatureDate currentTimeRoundedToNearestTimeInterval:5*60];
            NSString *depatureTime = [self.dateFormatter stringFromDate:self.depatureDate];
            self.departureTimeLabel.text = depatureTime;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture translationInView:self.depatureTimePanView];
            [gesture setTranslation:CGPointZero inView:self.depatureTimePanView];
            
            NSTimeInterval timeChange = point.x*20.0f;
            self.depatureDate = [self.depatureDate dateByAddingTimeInterval:timeChange];
            NSString *newTime = [self.dateFormatter stringFromDate:self.depatureDate];
            self.departureTimeLabel.text = newTime;
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            self.depatureDate = [self.depatureDate currentTimeRoundedToNearestTimeInterval:5*60];
            NSString *depatureTime = [self.dateFormatter stringFromDate:self.depatureDate];
            self.departureTimeLabel.text = depatureTime;
            
            if ([self.delegate respondsToSelector:@selector(willRouteFrom:To:withTime:)])
            {
                [self.delegate willRouteFrom:self.start To:self.end withTime:self.depatureDate];
            }
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
            
            break;
            
        default:
            break;
    }
}

@end
