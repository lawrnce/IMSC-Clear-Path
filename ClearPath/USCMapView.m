//
//  USCMapView.m
//  ClearPath
//
//  Created by Lawrence Tran on 9/7/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCMapView.h"

#import "CAAnimation+SpecialAnimations.h"

#define METERS_PER_MILE 1609.344
#define kRECENTS_THRESHOLD 100
#define kRECENTS_TRANSITION 233
#define kKEYBOARD_HEIGHT 162

static NSString * const kUSCRubberBandAnimationKey = @"kUSCRubberBandAnimationKey";
static NSString * const kUSCWobbleAnimationKey = @"kUSCWobbleAnimationKey";

@interface USCMapView () 

@property (nonatomic) CGPoint recentStart;
@property (nonatomic) CGPoint recentStop;

@property (nonatomic, strong) NSArray *results;

@end

@implementation USCMapView

@synthesize delegate = _delegate;

@synthesize mapView = _mapView;
@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize recentStart = _recentPosition;
@synthesize recentStop = _recentStop;
@synthesize recentView = _recentView;
@synthesize searchBar = _searchBar;

@synthesize results = _results;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // set background color
        self.backgroundColor = [UIColor clearColor];
        
        // panGestureRecognizer
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handeGesture:)];
        self.panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:self.panGestureRecognizer];
        
        // mapView
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.mapView];                                 // add mapView to underlay view
        self.mapView.showsUserLocation = YES;
        [self enableTouch:NO forMap:self.mapView];                      //disable all touch events

        // searchBar
        self.searchBar = [[UITextField alloc] initWithFrame:CGRectZero];
        self.searchBar.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.searchBar];
        
        // recentsView
        self.recentView = [[USCRecents alloc] initWithFrame:CGRectZero];
        self.recentView.alpha = 0.4f;
        [self addSubview:self.recentView];
    }
    return self;
}

#pragma mark - Layout Methods

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    // set mapView
    self.mapView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.bounds)*4.5f, CGRectGetMaxY(self.bounds)*3);
    self.mapView.center = self.center;
    
    [UIView animateWithDuration:5.0f animations:^{
    
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        self.recentView.alpha = 1.0f;
        
    }];
    
    // set searchBar
    self.searchBar.frame = CGRectMake(5.0f, 5.0f, CGRectGetMaxX(self.bounds)-10.0f, 30);
    _searchBarPosition = CGPointMake(self.searchBar.center.x, self.searchBar.center.y);
    
    // set recentStart and recentStop
    self.recentStart = CGPointMake(CGRectGetMaxX(self.bounds)*(1.5f), CGRectGetMidY(self.bounds));
    self.recentStop = CGPointMake(CGRectGetMaxX(self.bounds)*(.55f), CGRectGetMidY(self.bounds));
    
    // recentesView
    self.recentView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds)*.95f);
    self.recentView.center = self.recentStart;
    
    _limitedPanMapFlags.neutral = YES;
    _limitedPanMapFlags.showingRecents = NO;
    _limitedPanMapFlags.panning = NO;
    _limitedPanMapFlags.showingSearch = YES;

}

#pragma mark - Gesture Handling

- (void)handeGesture:(UIPanGestureRecognizer *)gesture;
{
    if (gesture.state == UIGestureRecognizerStateBegan){
        
        _limitedPanMapFlags.panning = YES;
        
        // Store layer position before adjusting anchor point
        gesture.view.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        
        _startPosition = gesture.view.layer.position;
        
    } else if (gesture.state == UIGestureRecognizerStateChanged){
        
        // Translate view by panned amount
        CGPoint translationPoint = [gesture translationInView:gesture.view];
        CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(translationPoint.x, translationPoint.y);
        self.mapView.center = CGPointApplyAffineTransform(self.mapView.center, translationTransform);
        
        if (_limitedPanMapFlags.showingRecents) {
            
            CGAffineTransform recentTransform = CGAffineTransformMakeTranslation(translationPoint.x, 0);
            self.recentView.center = CGPointApplyAffineTransform(self.recentView.center, recentTransform);
            
        }
        
        [gesture setTranslation:CGPointZero inView:self.mapView];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
        
        _limitedPanMapFlags.panning = NO;
        
        // Store current map position
        CGPoint currentPosition = [self.mapView convertCoordinate:self.mapView.userLocation.coordinate toPointToView:self];
        
        // Reset anchor point to default (since we'll be setting the position)
        gesture.view.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        
        // Set position to the start (otherwise the animation "pops back" to the current position)
        gesture.view.layer.position = _startPosition;
        
        // TEST FOR RECENTS
        if (_limitedPanMapFlags.neutral &&((_startPosition.x - currentPosition.x) >= kRECENTS_THRESHOLD)) {
            
            _recentPosition = CGPointMake(_startPosition.x - kRECENTS_TRANSITION, _startPosition.y);
        
            // mapAnimation
            CAAnimation *mapAnimation = [CAAnimation rubberBandAnimationFromPosition:currentPosition toPosition:_recentPosition duration:0.7f];
            
            // recentAnimation
            [UIView animateWithDuration:0.3f animations:^{
             
                self.recentView.center = self.recentStop;
                self.mapView.alpha = .7f;
                self.recentView.alpha = 1.0f;
                [self searchBarPositionHidden:YES];
                
                _limitedPanMapFlags.showingRecents = YES;
                _limitedPanMapFlags.showingSearch = YES;
             
            }];
            
            // Apply the mapAnimation
            [self.mapView.layer addAnimation:mapAnimation forKey:kUSCRubberBandAnimationKey];
            [self enableTouch:NO forMap:self.mapView];
            
            self.mapView.center = _recentPosition;
        
        } else {

            // mapAnimation
            CAAnimation *mapAnimation = [CAAnimation rubberBandAnimationFromPosition:currentPosition toPosition:_startPosition duration:0.7f];
            
            // Reset anchor point to default (since we'll be setting the position)
            gesture.view.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
            
            // Apply the rubber band animation
            [self.mapView.layer addAnimation:mapAnimation forKey:kUSCRubberBandAnimationKey];
            [self enableTouch:NO forMap:self.mapView];
            
            self.mapView.center = self.center;
            
            // recentAnimation
            if (_limitedPanMapFlags.showingRecents) {
                
                [UIView animateWithDuration:0.2f animations:^{
                    
                    self.recentView.center = CGPointMake(CGRectGetMaxX(self.bounds)*(1.5f), CGRectGetMaxY(self.bounds)*(.5f));
                    self.recentView.alpha = 0;
                    self.mapView.alpha = 1.0f;
                    [self searchBarPositionHidden:NO];
                    
                    _limitedPanMapFlags.showingRecents = NO;
                    _limitedPanMapFlags.showingSearch = NO;
                    
                }];
            }
        }
    }
}

#pragma mark - Helper Methods

- (void)enableTouch:(BOOL)flag forMap:(MKMapView *)mapView;
{
    mapView.scrollEnabled = flag;             // disable scroll
    mapView.zoomEnabled = flag;               // disable zoom
    mapView.multipleTouchEnabled = flag;      // disable multitouch
    mapView.userInteractionEnabled = flag;    // disable user interaction
}

- (void)searchBarPositionHidden:(BOOL)flag;
{
    if (flag) {
        self.searchBar.center = CGPointMake(_searchBarPosition.x, _searchBarPosition.y - 40);
    } else {
        self.searchBar.center = _searchBarPosition;
    }
}

- (void)searchShowing:(BOOL)flag;
{
    if (flag) {
        _mapSearchPosition = CGPointMake(self.mapView.center.x, self.mapView.center.y - kKEYBOARD_HEIGHT / 2.0f);
        _mapNeutralPosition = self.mapView.center;
        
        [UIView animateWithDuration:0.3f animations:^{
            
            self.mapView.center = _mapSearchPosition;
            
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            
            self.mapView.center = _mapNeutralPosition;
            
        }];
    }
}



@end
