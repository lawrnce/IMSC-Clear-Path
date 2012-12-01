//
//  USCMapView.m
//  ClearPath
//
//  Created by Lawrence Tran on 9/7/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCMapView.h"
#import "USCResults.h"

#import "CAAnimation+SpecialAnimations.h"
#import "USCResultCard.h"
#import "UIColor+EasySet.h"
#import "USCAnnotation.h"
#import "USCResultInformation.h"
#import "USCPathNode.h"
#import "UIImage+Loading.h"

#define METERS_PER_MILE 1609.344
#define kRECENTS_THRESHOLD 100
#define kRECENTS_TRANSITION 233
#define kKEYBOARD_HEIGHT 162

static NSString * const kUSCRubberBandAnimationKey = @"kUSCRubberBandAnimationKey";
static NSString * const kUSCWobbleAnimationKey = @"kUSCWobbleAnimationKey";

@interface USCMapView () <USCResultsDelegate, MKMapViewDelegate>

@property (nonatomic) CGPoint recentStart;
@property (nonatomic) CGPoint recentStop;

@property (nonatomic, strong) MKPolyline *polyline;
@property (nonatomic, strong) NSArray *results;

@property (nonatomic) BOOL showingResults;
@property (nonatomic) BOOL showingPolyline;
@property (nonatomic) BOOL showingInformtaion;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) USCResultInformation *resultInformation;
@property (nonatomic, strong) USCPathNode *startNode;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *user;

@end

@implementation USCMapView

@synthesize delegate = _delegate;

@synthesize mapView = _mapView;
@synthesize polylineView = _polylineView;

@synthesize polyline = _polyline;

@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize recentStart = _recentStart;
@synthesize recentStop = _recentStop;
@synthesize recentView = _recentView;
@synthesize searchBar = _searchBar;
@synthesize startCoordinate = _startCoordinate;
@synthesize endCoordinate = _endCoordinate;
@synthesize hasCustomStart;

@synthesize results = _results;

@synthesize showingResults = _showingResults;
@synthesize showingPolyline = _showingPolyline;

@synthesize backButton = _backButton;
@synthesize resultInformation = _resultInformation;
@synthesize startNode = _startNode;
@synthesize user = _user;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // set background color
        self.backgroundColor = [UIColor colorWithR:248 G:228 B:204 A:1];
//        self.backgroundColor = [UIColor lightGrayColor];
        
        // mapView
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.mapView];                                 // add mapView to underlay view
        self.mapView.delegate = self;
    
        self.mapView.userInteractionEnabled = YES;
        [self enableFullTouch:NO forMap:self.mapView];                      //disable all touch events

        // searchBar
        self.searchBar = [[UITextField alloc] initWithFrame:CGRectZero];
        self.searchBar.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.searchBar];
        [self.searchBar setPlaceholder:@"Search"];
        
        // recentsView
        self.recentView = [[USCRecents alloc] initWithFrame:CGRectZero];
        self.recentView.alpha = 0.4f;
        [self addSubview:self.recentView];
        
        // backButton
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.userInteractionEnabled = YES;
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"close_small.png"] forState:UIControlStateNormal];
        [self.backButton sizeToFit];
        [self.backButton addTarget:self action:@selector(_backButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // set BOOLs
        self.hasCustomStart = NO;
    }
    return self;
}

#pragma mark - Layout Methods

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    // set map
    self.mapView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.bounds)*3, CGRectGetMaxY(self.bounds)*3);
    self.mapView.center = self.center;
    
    
    // center map
    if (!self.showingPolyline)
        [self centerMapTo:self.mapView.userLocation.coordinate withTrackingMode:MKUserTrackingModeFollow withDuration:2.0f];
    
    // create overlay for map
    
    
    // user place button
    self.user = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.user setBackgroundImage:[UIImage imageNamed:@"Button_medium.png"] forState:UIControlStateNormal];
    [self.user sizeToFit];
    self.user.center = [self.mapView convertCoordinate:self.mapView.userLocation.coordinate toPointToView:self];
    self.user.center = self.mapView.center;
    [self addSubview:self.user];
    
    // set searchBar
    self.searchBar.frame = CGRectMake(5.0f, 5.0f, CGRectGetMaxX(self.bounds)-10.0f, 30);
    _searchBarPosition = CGPointMake(self.searchBar.center.x, self.searchBar.center.y);
    
    // set recentStart and recentStop
    self.recentStart = CGPointMake(CGRectGetMaxX(self.bounds)*(1.5f), CGRectGetMidY(self.bounds));
    self.recentStop = CGPointMake(CGRectGetMaxX(self.bounds)*(.55f), CGRectGetMidY(self.bounds));
    
    // recentesView
    self.recentView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds)*.95f);
    self.recentView.center = self.recentStart;
    
    // backButton
    self.backButton.center = CGPointMake(CGRectGetMaxX(self.bounds) - CGRectGetMidX(self.backButton.bounds), CGRectGetMaxY(self.bounds) - CGRectGetMidY(self.backButton.bounds));
    
    _limitedPanMapFlags.neutral = YES;
    _limitedPanMapFlags.panning = NO;
    _limitedPanMapFlags.showingRecents = NO;
    _limitedPanMapFlags.showingSearch = YES;
    
    _state.showingResults = NO;
    _state.showingPolyline = NO;

}

#pragma mark - ResultsView Methods

- (void)showSearchResultsForPoints:(NSArray *)placemarks;
{
    // init the results view
    self.resultsView = [[USCResults alloc] initWithFrame:CGRectZero withPlacemarks:placemarks delegate:self];
    self.resultsView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
    
    // add to view
    [self addSubview:self.resultsView];
    
    // place searchbar infront
    [self.searchBar removeFromSuperview];
    [self addSubview:self.searchBar];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.mapView.alpha = 0.3f;
    }];
    
    
    // change flags
    self.showingResults = YES;
    self.showingPolyline = NO;
    self.showingInformtaion = NO;
    
    // add back button
    [self addSubview:self.backButton];
}

#pragma mark - Result View Delegate Methods

- (void)willRouteTo:(USCRoute *)route;
{
    [self showPolylineForRoute:route];
    [self showAnnotationsForRoute:route];
}

- (void)willDisplayInformationForCard:(USCResultCard *)card;
{
    // move searchbar off screen
    self.searchBar.hidden = YES;
    
    // set alpha
    self.mapView.alpha = 1.0f;
    
    // move map center to routeLocation
    [self centerMapTo:[[card.route.coordinates lastObject] coordinate] withTrackingMode:MKUserTrackingModeNone withDuration:0.3f];
    
    // init a resultInformation
    self.resultInformation = [[USCResultInformation alloc] initWithFrame:CGRectZero withCard:card];
    
    self.resultInformation.frame = CGRectMake(0, 0, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.resultInformation.center = self.center;
    
    [self addSubview:self.resultInformation];
    
    // set button targets
    [self.resultInformation.start addTarget:self action:@selector(_setAsStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.resultInformation.end addTarget:self action:@selector(_setAsEnd:) forControlEvents:UIControlEventTouchUpInside];
    
    // set BOOLs
    self.showingResults = NO;
    self.showingPolyline = NO;
    self.showingInformtaion = YES;
    
     self.searchBar.frame = CGRectMake(0, 0, 30, 30);
}

- (void)showPolylineForRoute:(USCRoute *)route;
{
    // ***** Make a transition here later
    // hide results view
    [self.resultsView removeFromSuperview];
    
    // bring back alpha
    self.mapView.alpha = 1.0f;
    
    // check if a polyline exists, if so then remove
    if (self.polyline)[self.mapView removeOverlay:self.polyline];
    
    [self createPolylineForCoordinates:route.coordinates];
    
    [self enableFullTouch:YES forMap:self.mapView];
    
    NSLog(@"YESSSSSSSSS!!! %@", route.name);
    
    _state.showingPolyline = YES;
}

- (void)showAnnotationsForRoute:(USCRoute *)route;
{
    USCAnnotation *start = [[USCAnnotation alloc] init];
    start.coordinate = [[route.coordinates objectAtIndex:0] coordinate];
    
    USCAnnotation *end = [[USCAnnotation alloc] init];
    end.coordinate = [[route.coordinates lastObject] coordinate];
    
    start.title = @"Start";
    end.title = @"End";
    
//    NSArray *annotations = [[NSArray alloc] initWithObjects:start, end, nil];
//    [self.mapView addAnnotations:annotations];
    
    // Zoom window to fit annotations
    CLLocationCoordinate2D center;
    CLLocationDistance distance;
    
    center.latitude = (start.coordinate.latitude + end.coordinate.latitude) / 2;
    center.longitude = (start.coordinate.longitude + end.coordinate.longitude) / 2;
    
    distance = [[route.coordinates objectAtIndex:0] distanceFromLocation:[route.coordinates lastObject]];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center, distance*2.75f, distance*2.75f);
    MKCoordinateRegion adjustRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustRegion animated:YES];
    NSLog(@"Annotation set");
}

#pragma mark - Map Display Methods

- (void)displayRouteForCoordinates:(NSArray *)array;
{
    [self.mapView removeOverlay:self.polyline];
    
    CLLocationCoordinate2D *coordinates = malloc([array count] * sizeof(CLLocationCoordinate2D));
    CLLocationCoordinate2D *coordsIter = coordinates;
    for (CLLocation *location in array)
    {
        *coordsIter = location.coordinate;
        coordsIter++;
    }
    
    self.polyline = [MKPolyline polylineWithCoordinates:coordinates count:[array count]];
    free(coordinates);
    
    [self.mapView addOverlay:self.polyline];
    [self addSubview:self.mapView];
    NSLog(@"polyline made");
}

#pragma mark - MapView Delegate Methods

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay;
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        self.polylineView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline *)overlay];
        self.polylineView.fillColor = [UIColor colorWithR:143 G:188 B:219 A:1];
        self.polylineView.strokeColor = [UIColor colorWithR:143 G:188 B:219 A:1];
        self.polylineView.lineWidth = 5;
        
        return self.polylineView;
    }
    
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation;
{
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.image = [UIImage imageNamed:@"Button_medium.png"];
    annotationView.annotation = annotation;
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *ulv = [mapView viewForAnnotation:mapView.userLocation];
    ulv.hidden = YES;
}

#pragma mark - PolyLine and Annotation Methods

- (void)createPolylineForCoordinates:(NSArray *)coordinates;
{
    CLLocationCoordinate2D *coords = malloc([coordinates count] * sizeof(CLLocationCoordinate2D));
    CLLocationCoordinate2D *coordsIter = coords;
    
    for (CLLocation *location in coordinates)
    {
        *coordsIter = location.coordinate;
        coordsIter++;
    }
    
    self.polyline = [MKPolyline polylineWithCoordinates:coords count:[coordinates count]];
    free(coords);
    
    [self.mapView addOverlay:self.polyline];
    [self addSubview:self.mapView];
    
    // set flags
    self.showingResults = NO;
    self.showingPolyline = YES;
    [self addSubview:self.backButton];
    
    NSLog(@"Polyline Made");
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
            [self enableFullTouch:NO forMap:self.mapView];
            
            self.mapView.center = _recentPosition;
            
        } else {
            
            // mapAnimation
            CAAnimation *mapAnimation = [CAAnimation rubberBandAnimationFromPosition:currentPosition toPosition:_startPosition duration:0.7f];
            
            // Reset anchor point to default (since we'll be setting the position)
            gesture.view.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
            
            // Apply the rubber band animation
            [self.mapView.layer addAnimation:mapAnimation forKey:kUSCRubberBandAnimationKey];
            [self enableFullTouch:NO forMap:self.mapView];
            
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

- (void)_setAsStart:(id)sender;
{
    // create a node
    self.startNode = [[USCPathNode alloc] initWithFrame:CGRectZero withCard:self.resultInformation.card];
    self.startNode.frame = CGRectMake(5.0f, CGRectGetMaxY(self.searchBar.bounds) + 10.0f, CGRectGetMaxX(self.bounds)-10.0f, 30);;
    [self addGestureToNode:self.startNode];
    [self addSubview:self.startNode];
    
    // set starting coordinate
    self.hasCustomStart = YES;
    self.startCoordinate = [self.startNode coordinate];

    // remove results view
    [self.resultsView removeFromSuperview];
    [self.resultInformation removeFromSuperview];
    
    self.showingResults = NO;
    self.showingInformtaion = NO;
    self.showingPolyline = NO;
    
    // bring back search bar
    self.searchBar.hidden = NO;
    
    // set search bar as first responder
    [self.searchBar setText:@""];
    [self.searchBar setPlaceholder:@"Enter Desintation"];
    [self.searchBar becomeFirstResponder];
}

- (void)_setAsEnd:(id)sender;
{
    
}

- (void)_backButton:(id)sender;
{
    if (self.showingResults)
    {
        // remove results
        [self.resultsView removeFromSuperview];
        
        // set alpha back
        self.mapView.alpha = 1.0f;
        
        // set BOOLS
        [self enableFullTouch:NO forMap:self.mapView];
        self.showingResults = NO;
        self.showingPolyline = NO;
        _limitedPanMapFlags.neutral = YES;
        [self.backButton removeFromSuperview];
    }
    else if (self.showingPolyline)
    {
        // remove polyline
        [self.polylineView removeFromSuperview];
        
        // remove backButton
        [self.backButton removeFromSuperview];
        
        // add resultsView
        [self addSubview:self.resultsView];
        
        // add searchbar
        [self addSubview:self.searchBar];
        
        // check path Nodes
        if (self.hasCustomStart)
            [self addSubview:self.startNode];
        
        // place button over
        [self addSubview:self.backButton];
        
        // set map to userlocation
        [self centerMapTo:self.mapView.userLocation.coordinate withTrackingMode:MKUserTrackingModeNone withDuration:0.3f];
            
        // set BOOLs
        self.showingResults = YES;
        self.showingPolyline = NO;
    }
    else if (self.showingInformtaion)
    {
        // move card back to oringal place
        [self.resultsView moveSelectedCardToOrginal];
        
        // remove Information
        [self.resultInformation removeFromSuperview];
        
        // move map to user location
        [self centerMapTo:self.mapView.userLocation.coordinate withTrackingMode:MKUserTrackingModeFollow withDuration:0.3f];
        
        // show searchBar
        self.searchBar.hidden = NO;
        
        // unhide results
        for (NSMutableArray *page in self.resultsView.pages)
        {
            for (USCResultCard *card in page)
            {
                card.hidden = NO;
            }
        }
        
        // unhide page control
        self.resultsView.pageControl.hidden = NO;
        self.resultsView.pagesScrollView.userInteractionEnabled = YES;
        
        // set BOOLs
        self.showingInformtaion = NO;
        self.showingResults = YES;
    }
}

- (void)centerMapTo:(CLLocationCoordinate2D)coordinate withTrackingMode:(MKUserTrackingMode)mode withDuration:(float)time;
{
    [UIView animateWithDuration:time animations:^{
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, METERS_PER_MILE*1.5f, METERS_PER_MILE*1.5f);
        MKCoordinateRegion adjustRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustRegion animated:YES];
        
        [self.mapView setUserTrackingMode:mode animated:YES];
    }];
    
}

- (void)enableFullTouch:(BOOL)flag forMap:(MKMapView *)mapView;
{
    // toggle pan gesture recognizer 
    if (flag)
    {
        // Full touch enabled so must remove gesture recognizer
        if (self.panGestureRecognizer) [self removeGestureRecognizer:self.panGestureRecognizer];
    }
    else
    {
        // panGestureRecognizer
        if (!self.panGestureRecognizer)
        {
            self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handeGesture:)];
            self.panGestureRecognizer.delegate = self;
        }
        [self addGestureRecognizer:self.panGestureRecognizer];
    }
    
    mapView.scrollEnabled = flag;             // disable scroll
    mapView.zoomEnabled = flag;               // disable zoom
    mapView.multipleTouchEnabled = flag;      // disable multitouch
    mapView.userInteractionEnabled = flag;    // disable user interaction
}

- (void)addGestureToNode:(USCPathNode *)node;
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNodeGesture:)];
    panGesture.delegate = self;
    
    [node addGestureRecognizer:panGesture];
}

- (void)handleNodeGesture:(UIPanGestureRecognizer *)gesture;
{
    if (gesture.state == UIGestureRecognizerStateBegan){
        
        // Store layer position before adjusting anchor point
        gesture.view.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        
        _nodePosition = gesture.view.layer.position;
        
    } else if (gesture.state == UIGestureRecognizerStateChanged){
        
        // Translate view by panned amount
        CGPoint translationPoint = [gesture translationInView:gesture.view];
        CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(translationPoint.x, 0);
        
        gesture.view.center = CGPointApplyAffineTransform(gesture.view.center, translationTransform);
        
        [gesture setTranslation:CGPointZero inView:gesture.view];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
       
        // Store the current position
        CGPoint midPoint = CGPointMake(CGRectGetMidX(gesture.view.bounds), CGRectGetMidY(gesture.view.bounds));
        CGPoint currentPosition = [gesture.view convertPoint:midPoint toView:gesture.view.superview];
        
        
        if ((currentPosition.x - _nodePosition.x) > 200)
        {
            // mapAnimation
            CAAnimation *mapAnimation = [CAAnimation rubberBandAnimationFromPosition:currentPosition toPosition:CGPointMake(currentPosition.x + 300, currentPosition.y) duration:0.5f];
            
            // Reset anchor point to default (since we'll be setting the position)
            gesture.view.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
            
            // Apply the rubber band animation
            [gesture.view.layer addAnimation:mapAnimation forKey:kUSCRubberBandAnimationKey];
            
            // remove pathNode from superview
            [self.startNode removeFromSuperview];
            
            
            [UIView animateWithDuration:0.3f animations:^{
            
                self.label = [[UILabel alloc] initWithFrame:self.startNode.bounds];
                
                self.label.center = _nodePosition;
                
                [self.label setText:[NSString stringWithFormat:@"'%@' removed as start", [self.startNode name]]];
                
                self.label.textAlignment = UITextAlignmentCenter;
                
                [self addSubview:self.label];
                
            }];
            
            [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                
                [self.label removeFromSuperview];
                
            } completion:NULL];
            
            // set BOOLs
            self.hasCustomStart = NO;
        }
        else
        {
            // mapAnimation
            CAAnimation *mapAnimation = [CAAnimation rubberBandAnimationFromPosition:currentPosition toPosition:_nodePosition duration:0.5f];
            
            // Reset anchor point to default (since we'll be setting the position)
            gesture.view.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
            
            
            // set position to start
            gesture.view.layer.position = _nodePosition;
            
            // Apply the rubber band animation
            [gesture.view.layer addAnimation:mapAnimation forKey:kUSCRubberBandAnimationKey];
        }
        
    }
}

- (void)_adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
{
    // Adjust anchor point to fall under touch location
    UIView *view = gestureRecognizer.view;
    CGPoint locationInView = [gestureRecognizer locationInView:view];
    CGPoint locationInSuperview = [gestureRecognizer locationInView:view.superview];
    
    view.layer.anchorPoint = CGPointMake(locationInView.x / view.bounds.size.width, locationInView.y / view.bounds.size.height);
    view.center = locationInSuperview;
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
