//
//  USCResultCard.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/14/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCResultCard.h"

#define kContetViewInserts UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)
#define kTitleViewInserts UIEdgeInsetsMake(3.0f, 0.0f, 7.0f, 0.0f)

@interface USCResultCard ()

@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIView *contentView;


@end

@implementation USCResultCard

@synthesize touchGestureRecognizer = _touchGestureRecognizer;

@synthesize locationPoint = _locationPoint;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

@synthesize contentView = _contentView;

- (id)initWithFrame:(CGRect)frame withPoint:(USCLocationPoint *)point delegate:(id<USCResultCardDelegate>)delegate;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // set delegate
        [self setDelegate:delegate];
        
        self.locationPoint = point;
        
        self.userInteractionEnabled = YES;
        
        // Initialization code
        self.backgroundColor = [UIColor cyanColor];
        
        self.overlayView = [[UIView alloc] initWithFrame:CGRectZero];
        self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.subtitle = [[UILabel alloc] initWithFrame:CGRectZero];
        
        self.touchGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        self.touchGestureRecognizer.delegate = self;
        [self.overlayView addGestureRecognizer:self.touchGestureRecognizer];
    }
    return self;
}

#pragma mark - Layout Subview

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
//    // set contentView
//    self.contentView.frame = self.bounds;
//    
//    [self.contentView sizeToFit];
//    
//    // Position content view
//    UIEdgeInsets contentInsets = kContetViewInserts;
//    CGPoint contentViewOrigin = CGPointMake(contentInsets.left, contentInsets.top);
//    CGRect contentViewFrame = self.contentView.frame;
//    contentViewFrame.origin = contentViewOrigin;
//    self.contentView.frame = contentViewFrame;
//
    
    
    // position title and subtitle
    [self.title setText:self.locationPoint.name];
    self.title.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    [self.title sizeToFit];
    self.title.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    [self addSubview:self.title];
    
    self.overlayView.frame = self.bounds;
    self.overlayView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.overlayView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.overlayView];
}

//- (CGSize)sizeThatFits:(CGSize)size;
//{
//    UIEdgeInsets contentInsets = kContetViewInserts;
//    CGSize contentViewConstraint = size;
//    contentViewConstraint.height -= contentInsets.top + contentInsets.bottom;
//    contentViewConstraint.width -= contentInsets.left + contentInsets.right;
//    CGSize contentViewSize = [self.contentView sizeThatFits:contentViewConstraint];
//    
//    CGSize sizeThatFits = CGSizeMake(contentViewSize.width + contentInsets.left + contentInsets.right, contentViewSize.height + contentInsets.top + contentInsets.bottom);
//    return sizeThatFits;
//}

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
        [self _cardDidGetPressed];
        
        [UIView animateWithDuration:0.1f animations:^{
            
            self.alpha = 1.0;
            
        }];
    }
}

#pragma mark - Delegate Passing

- (void)_cardDidGetPressed;
{
    if ([self.delegate respondsToSelector:@selector(cardDidPressFor:)])
        [self.delegate cardDidPressFor:self.locationPoint];
}

@end
