//
//  USCMapView.m
//  ClearPath
//
//  Created by Lawrence Tran on 9/7/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCMapView.h"
#import "USCResults.h"
#import "USCFavorites.h"

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

@property (nonatomic) CGPoint favoriteStart;
@property (nonatomic) CGPoint favoriteStop;

@property (nonatomic, strong) MKPolyline *polyline;
@property (nonatomic, strong) NSArray *results;

@property (nonatomic) BOOL showingResults;
@property (nonatomic) BOOL showingPolyline;
@property (nonatomic) BOOL showingInformtaion;

@property (nonatomic) BOOL showingFavorities;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) USCResultInformation *resultInformation;
@property (nonatomic, strong) USCPathNode *startNode;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *user;

@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, strong) USCAnnotation *userAnnotation;
@property (nonatomic, strong) UILabel *nameDisplay;
@property (nonatomic, strong) UILabel *timeDisplay;

@property (nonatomic, strong) UIScrollView *help;

@property (nonatomic) BOOL canShowRecents;
@property (nonatomic) BOOL canShowFavorites;
@property (nonatomic) BOOL hasStartNode;
@property (nonatomic) BOOL timeChanged;

@property (nonatomic, strong) UIButton *helpButton;
@property (nonatomic) BOOL showingHelp;


@property (nonatomic, strong) UIImageView *favoriteImage;

@end

@implementation USCMapView

@synthesize helpButton = _helpButton;
@synthesize showingHelp = _showingHelp;

@synthesize favoriteImage = _favoriteImage;

@synthesize delegate = _delegate;

@synthesize mapView = _mapView;
@synthesize polylineView = _polylineView;

@synthesize polyline = _polyline;

@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize recentStart = _recentStart;
@synthesize recentStop = _recentStop;

@synthesize favoriteStart = _favoriteStart;
@synthesize favoriteStop = _favoriteStop;

@synthesize recentView = _recentView;
@synthesize favoritesView = _favoritesView;
@synthesize searchBar = _searchBar;
@synthesize startCoordinate = _startCoordinate;
@synthesize endCoordinate = _endCoordinate;
@synthesize hasCustomStart;

@synthesize results = _results;
@synthesize help = _help;

@synthesize showingFavorities = _showingFavorities;
@synthesize showingResults = _showingResults;
@synthesize showingPolyline = _showingPolyline;
@synthesize canShowRecents = _canShowRecents;
@synthesize canShowFavorites = _canShowFavorites;
@synthesize hasStartNode = _hasStartNode;

@synthesize backButton = _backButton;
@synthesize resultInformation = _resultInformation;
@synthesize startNode = _startNode;
@synthesize user = _user;
@synthesize annotations = _annotations;
@synthesize userAnnotation = _userAnnotation;

@synthesize timeSlider = _timeSlider;
@synthesize timeChanged = _timeChanged;

@synthesize nameDisplay = _nameDisplay;
@synthesize timeDisplay = _timeDisplay;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // set background color
        self.backgroundColor = [UIColor colorWithR:248 G:228 B:204 A:1];
        self.backgroundColor = [UIColor whiteColor];
        
        // mapView
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.mapView];                                 // add mapView to underlay view
        self.mapView.delegate = self;
    
        self.mapView.showsUserLocation = YES;
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
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"BArrow_small.png"] forState:UIControlStateNormal];
        [self.backButton sizeToFit];
        [self.backButton addTarget:self action:@selector(_backButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // set BOOLs
        self.hasCustomStart = NO;
        self.canShowRecents = YES;
        self.canShowFavorites = YES;
        self.hasStartNode = NO;
        self.timeChanged = NO;
        self.showingHelp = NO;
        
        // time slider
        self.timeSlider = [[USCTimeSlider alloc] initWithFrame:CGRectZero];
        self.timeDisplay = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nameDisplay = [[UILabel alloc] initWithFrame:CGRectZero];
        
        
        // help view
        self.help = [[UIScrollView alloc] initWithFrame:CGRectZero];
        UIImageView *helpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"final.png"]];
//        [self.help sizeToFit];
        [self.help addSubview:helpImageView];
        self.help.contentSize = CGSizeMake(CGRectGetMaxX(self.help.bounds), CGRectGetMaxY(helpImageView.bounds));
        self.help.pagingEnabled = YES;
        
        // favorite image
        self.favoriteImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gfavorites.png"]];
        
    }
    return self;
}

#pragma mark - Layout Methods

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    // set help
    self.help.frame = CGRectMake(0, 0, 320, 480);
    self.help.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds) + CGRectGetMidY(self.help.bounds));
    [self addSubview:self.help];
    
    // set map
    self.mapView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.bounds)*3, CGRectGetMaxY(self.bounds)*3);
    self.mapView.center = self.center;
    
    // center map
    if (!self.showingPolyline)
        [self centerMapTo:self.mapView.userLocation.coordinate withTrackingMode:MKUserTrackingModeFollow withDuration:0.3f];
    
    // set searchBar
    self.searchBar.frame = CGRectMake(5.0f, 5.0f, CGRectGetMaxX(self.bounds)-10.0f, 30);
    _searchBarPosition = CGPointMake(self.searchBar.center.x, self.searchBar.center.y);
    
    // set favorites image
    self.favoriteImage.center = CGPointMake(CGRectGetMaxX(self.bounds) - CGRectGetMidX(self.favoriteImage.bounds) - 5,
                                            CGRectGetMaxY(self.searchBar.bounds) + CGRectGetMidY(self.favoriteImage.bounds) + 10.0f);
    [self addSubview:self.favoriteImage];
    
    // set recentStart and recentStop
    self.recentStart = CGPointMake(CGRectGetMaxX(self.bounds)*(1.5f), CGRectGetMidY(self.bounds));
    self.recentStop = CGPointMake(CGRectGetMaxX(self.bounds)*(.55f), CGRectGetMidY(self.bounds));
    
    // recentesView
    self.recentView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds)*.95f);
    self.recentView.center = self.recentStart;
    
    // favorites view
    self.favoritesView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds)*.95f);
    self.favoritesView.center = self.favoriteStart;
    
    // backButton
    self.backButton.center = CGPointMake(CGRectGetMidX(self.backButton.bounds), CGRectGetMaxY(self.bounds) - CGRectGetMidY(self.backButton.bounds));
    
    // time slider
    self.timeSlider.frame = CGRectMake(0, 0, 250, 75);
    self.timeSlider.center = CGPointMake(CGRectGetMidX(self.bounds),
                                         CGRectGetMaxY(self.bounds) - CGRectGetMidY(self.timeSlider.bounds));
    
    // name display
    self.nameDisplay.backgroundColor = [UIColor colorWithR:102 G:102 B:102 A:0.4f];
    self.nameDisplay.textColor = [UIColor whiteColor];
    self.nameDisplay.font = [UIFont fontWithName:@"Helvetica-Bold" size:40];
   
    // time display
    self.timeDisplay.backgroundColor = [UIColor colorWithR:102 G:102 B:102 A:0.4f];
    self.timeDisplay.textColor = [UIColor whiteColor];
    self.timeDisplay.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    
    _limitedPanMapFlags.neutral = YES;
    _limitedPanMapFlags.panning = NO;
    _limitedPanMapFlags.showingRecents = NO;
    self.showingFavorities = NO;
    _limitedPanMapFlags.showingSearch = YES;
    
    _state.showingResults = NO;
    _state.showingPolyline = NO;
    
    
    // Help Button
    self.helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.helpButton setBackgroundImage:[UIImage imageNamed:@"Button_small"] forState:UIControlStateNormal];
    [self.helpButton setTitle:[NSString stringWithFormat:@"?"] forState:UIControlStateNormal];
    [self.helpButton sizeToFit];
    self.helpButton.center = CGPointMake(CGRectGetMaxX(self.bounds) - CGRectGetMidX(self.helpButton.bounds), CGRectGetMaxY(self.bounds) - CGRectGetMidY(self.helpButton.bounds));
    [self addSubview:self.helpButton];
    [self.helpButton addTarget:self action:@selector(helpButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)helpButton:(id)sender;
{
    if (self.showingHelp)
    {
        [UIView animateWithDuration:0.3f animations:^{
        
            self.help.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds) + CGRectGetMidY(self.help.bounds));
            self.favoriteImage.alpha = 1.0f;
        }];
        
        self.showingHelp = NO;
    }
    else if (!self.showingHelp)
    {

        [UIView animateWithDuration:0.3f animations:^{
        
            self.help.center = self.center;
            self.favoriteImage.alpha = 0;
        }];
        
        self.showingHelp = YES;
    }
}

- (void)viewDidLoad;
{
    self.userAnnotation = [[USCAnnotation alloc] init];
    self.userAnnotation.coordinate = [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
    
    self.userAnnotation.title = @"user";
    
    [self.mapView addAnnotation:self.userAnnotation];
}

- (void)showRoute:(USCRoute *)route;
{
    [self.polylineView removeFromSuperview];
    [self.timeSlider removeFromSuperview];
    [self.timeDisplay removeFromSuperview];
    [self.nameDisplay removeFromSuperview];
    NSLog(@"MAGIC POKEMON");
    self.timeChanged = YES;
    [self _backButton:NULL];
    [self showPolylineForRoute:route];
    [self showAnnotationsForRoute:route withZoom:NO];
    [self addSubview:self.timeSlider];
    [self addSubview:self.nameDisplay];
    self.timeChanged = NO;
    
    // time display
    [self.timeDisplay setText:route.travelTime];
    [self.timeDisplay sizeToFit];
    self.timeDisplay.frame = CGRectIntegral(self.timeDisplay.frame);
    [self addSubview:self.timeDisplay];
}

#pragma mark - ResultsView Methods

- (void)closeFavorites;
{
    // mapAnimation
    CAAnimation *mapAnimation = [CAAnimation rubberBandAnimationFromPosition:[self.mapView convertCoordinate:self.mapView.userLocation.coordinate toPointToView:self] toPosition:_startPosition duration:0.7f];
    
    // Reset anchor point to default (since we'll be setting the position)
//    gesture.view.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    
    // Apply the rubber band animation
    [self.mapView.layer addAnimation:mapAnimation forKey:kUSCRubberBandAnimationKey];
    [self enableFullTouch:NO forMap:self.mapView];
    
    self.mapView.center = self.center;
    
    // exit out of favorites view
    [UIView animateWithDuration:0.2f animations:^{
        
        self.recentView.center = CGPointMake(CGRectGetMaxX(self.bounds)*(1.5f), CGRectGetMaxY(self.bounds)*(.5f));
        self.recentView.alpha = 0;
        self.mapView.alpha = 1.0f;
        [self searchBarPositionHidden:NO];
        
        _limitedPanMapFlags.showingRecents = NO;
        _limitedPanMapFlags.showingSearch = NO;
        
    }];
}

- (void)showSearchResultsForPoints:(NSArray *)placemarks;
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // init the results view
    self.resultsView = [[USCResults alloc] initWithFrame:CGRectZero withPlacemarks:placemarks delegate:self];
    self.resultsView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
    
    // add to view
    [self addSubview:self.resultsView];
    
    // place searchbar infront
    [self.searchBar removeFromSuperview];
    [self addSubview:self.searchBar];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.mapView.alpha = 0.5f;
    }];
    
    // change flags
    self.showingResults = YES;
    self.showingPolyline = NO;
    self.showingInformtaion = NO;
    self.canShowRecents = NO;
    self.canShowFavorites = NO;
    
    // add back button
    [self addSubview:self.backButton];
    
    [self.helpButton removeFromSuperview];
    
    self.favoriteImage.alpha = 0;
}

#pragma mark - Result View Delegate Methods

- (void)willRouteTo:(USCRoute *)route;
{
    [self showPolylineForRoute:route];
    [self showAnnotationsForRoute:route withZoom:YES];
    [self addSubview:self.timeSlider];
    
    // name display
    [self.nameDisplay setText:route.name];
    [self.nameDisplay sizeToFit];
    self.nameDisplay.frame = CGRectIntegral(self.nameDisplay.frame);
    self.nameDisplay.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.nameDisplay.bounds) * 1.25f );
    [self addSubview:self.nameDisplay];
    
    // time display
    [self.timeDisplay setText:route.travelTime];
    [self.timeDisplay sizeToFit];
    self.timeDisplay.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.nameDisplay.bounds) + CGRectGetMaxY(self.timeDisplay.bounds));
    self.timeDisplay.frame = CGRectIntegral(self.timeDisplay.frame);
    [self addSubview:self.timeDisplay];
}

- (void)willDisplayInformationForCard:(USCResultCard *)card;
{
    USCAnnotation *start = [[USCAnnotation alloc] init];
    start.coordinate = [[card.route.coordinates lastObject] coordinate];
    
    start.title = @"start";
    
    self.annotations = [[NSArray alloc] initWithObjects:start, nil];
    [self.mapView addAnnotations:self.annotations];
    
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
    
    if (self.hasStartNode)
    {
        self.resultInformation.start.userInteractionEnabled = NO;
        self.resultInformation.start.alpha = 0.5f;
        
        // move card to top
        [UIView animateWithDuration:0.3f animations:^{
            
            _startNodePosition = self.startNode.center;
            
            CGPoint point = self.startNode.center;
            
            point.y = (CGRectGetMidY(self.startNode.bounds) * 1.3f);
            
            self.startNode.center = point;
            
        }];
    }
    
    [self addSubview:self.resultInformation];
    
    // set button targets
    [self.resultInformation.start addTarget:self action:@selector(_setAsStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.resultInformation.end addTarget:self action:@selector(_setAsEnd:) forControlEvents:UIControlEventTouchUpInside];
    
    // set BOOLs
    self.showingResults = NO;
    self.showingPolyline = NO;
    self.showingInformtaion = YES;
    
    self.searchBar.frame = CGRectMake(0, 0, 30, 30);
    
    [self enableFullTouch:NO forMap:self.mapView];                      //disable all touch events
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
    
    self.timeSlider.start = [route.coordinates objectAtIndex:0];
    self.timeSlider.end = [route.coordinates lastObject];
    
    _state.showingPolyline = YES;
}

- (void)showAnnotationsForRoute:(USCRoute *)route withZoom:(BOOL)flag;
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    USCAnnotation *start = [[USCAnnotation alloc] init];
    start.coordinate = [[route.coordinates objectAtIndex:0] coordinate];
    
    USCAnnotation *end = [[USCAnnotation alloc] init];
    end.coordinate = [[route.coordinates lastObject] coordinate];
    
    USCAnnotation *user = [[USCAnnotation alloc] init];
    user.coordinate = self.mapView.userLocation.coordinate;
    
    start.title = @"start";
    end.title = @"end";
    user.title = @"userSmall";
    
    self.annotations = [[NSArray alloc] initWithObjects:start, end, user, nil];
    [self.mapView addAnnotations:self.annotations];
    
    if (flag)
    {
        // Zoom window to fit annotations
        CLLocationCoordinate2D center;
        CLLocationDistance distance;
        
        center.latitude = (start.coordinate.latitude + end.coordinate.latitude) / 2;
        center.longitude = (start.coordinate.longitude + end.coordinate.longitude) / 2;
        
        distance = [[route.coordinates objectAtIndex:0] distanceFromLocation:[route.coordinates lastObject]];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center, distance*3.25f, distance*3.25f);
        MKCoordinateRegion adjustRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustRegion animated:YES];
    }

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
        self.polylineView.lineWidth = 10;
        
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
    
    // if annotation is user
    if ([[annotation title] isEqualToString:@"user"])
    {
        annotationView.image = [UIImage imageNamed:@"prof_image_80x80.png"];
        annotationView.canShowCallout = YES;
    }

    if ([[annotation title] isEqualToString:@"userSmall"])
    {
        annotationView.image = [UIImage imageNamed:@"prof_image_40x40.png"];
    }
    
    // if annotation is start
    if ([[annotation title] isEqualToString:@"start"] || [[annotation title] isEqualToString:@"end"])
    {
        annotationView.image = [UIImage imageNamed:@"Button1.png"];
    }
    
    // if annotation is start
    if ([[annotation title] isEqualToString:@"end"] || [[annotation title] isEqualToString:@"end"])
    {
        annotationView.image = [UIImage imageNamed:@"Button2.png"];
    }
    
    annotationView.annotation = annotation;
   
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
//    MKAnnotationView *ulv = [mapView viewForAnnotation:mapView.userLocation];
//    ulv.hidden = YES;
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
        if (_limitedPanMapFlags.neutral &&((_startPosition.x - currentPosition.x) >= kRECENTS_THRESHOLD) && self.canShowRecents) {
            
            _recentPosition = CGPointMake(_startPosition.x - kRECENTS_TRANSITION, _startPosition.y);
            
            // mapAnimation
            CAAnimation *mapAnimation = [CAAnimation rubberBandAnimationFromPosition:currentPosition toPosition:_recentPosition duration:0.7f];
            
            // recentAnimation
            [UIView animateWithDuration:0.3f animations:^{
                
                self.recentView.center = self.recentStop;
                self.mapView.alpha = .7f;
                self.recentView.alpha = 1.0f;
                [self searchBarPositionHidden:YES];
                
                self.favoriteImage.alpha = 0;
                
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
                    
                    self.favoriteImage.alpha = 1.0f;
                    
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
    [self.startNode.trash addTarget:self action:@selector(removeStartNodeStart:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    self.hasStartNode = YES;
    self.resultsView.hasStartNode = YES;
}

- (void)_setAsEnd:(id)sender;
{
    [self _backButton:sender];
    
    [self showPolylineForRoute:self.resultInformation.card.route];
    [self showAnnotationsForRoute:self.resultInformation.card.route withZoom:YES];
    [self addSubview:self.timeSlider];
    
    // name display
    [self.nameDisplay setText:self.resultInformation.card.route.name];
    [self.nameDisplay sizeToFit];
    self.nameDisplay.frame = CGRectIntegral(self.nameDisplay.frame);
    self.nameDisplay.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.nameDisplay.bounds) * 1.25f );
    [self addSubview:self.nameDisplay];
    
    // time display
    [self.timeDisplay setText:self.resultInformation.card.route.name];
    [self.timeDisplay sizeToFit];
    self.timeDisplay.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.nameDisplay.bounds) + CGRectGetMaxY(self.timeDisplay.bounds));
    self.timeDisplay.frame = CGRectIntegral(self.timeDisplay.frame);
    [self addSubview:self.timeDisplay];
}

- (void)_backButton:(id)sender;
{
    if (self.showingResults)
    {
        // remove results
        [self.resultsView removeFromSuperview];
        
        // set alpha back
        self.mapView.alpha = 1.0f;
        
        // bring back user image
        [self.mapView addAnnotations:self.mapView.annotations];
        
        // set BOOLS
        [self enableFullTouch:NO forMap:self.mapView];
        self.showingResults = NO;
        self.showingPolyline = NO;
        _limitedPanMapFlags.neutral = YES;
        self.canShowRecents = YES;
        self.canShowFavorites = YES;
        [self.backButton removeFromSuperview];
        [self addSubview:self.helpButton];
        self.favoriteImage.alpha = 1.0f;
    }
    else if (self.showingPolyline)
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.mapView.alpha = 0.5f;
        }];
        
        // remove polyline
        [self.polylineView removeFromSuperview];
        
        // remove annotations
        [self.mapView removeAnnotations:self.mapView.annotations];
        
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
        
        if (!self.timeChanged)
        {
            [self centerMapTo:self.mapView.userLocation.coordinate withTrackingMode:MKUserTrackingModeNone withDuration:0.3f];
        }
        
        // remove superview
        [self.timeSlider removeFromSuperview];
        [self.nameDisplay removeFromSuperview];
        [self.timeDisplay removeFromSuperview];
            
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
        
        [UIView animateWithDuration:0.3f animations:^{
            
            self.startNode.center = _startNodePosition;
            
        }];
        
        // unhide page control
        self.resultsView.pageControl.hidden = NO;
        self.resultsView.pagesScrollView.userInteractionEnabled = YES;
        
        // set BOOLs
        self.showingInformtaion = NO;
        self.showingResults = YES;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.mapView.alpha = 0.5f;
        }];
    }
}

- (void)centerMapTo:(CLLocationCoordinate2D)coordinate withTrackingMode:(MKUserTrackingMode)mode withDuration:(float)time;
{
    [UIView animateWithDuration:time animations:^{
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, METERS_PER_MILE*2.5f, METERS_PER_MILE*1.5f);
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

- (void)removeStartNodeStart:(id)sender;
{
    [self.startNode removeFromSuperview];

    // set BOOLs
    self.hasCustomStart = NO;
    self.hasStartNode = NO;
    self.resultsView.hasStartNode = NO;
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
            self.hasStartNode = NO;
            self.resultsView.hasStartNode = NO;
            
            self.searchBar.placeholder = @"Search";
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
