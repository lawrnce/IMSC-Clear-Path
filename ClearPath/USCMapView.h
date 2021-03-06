//
//  USCMapView.h
//  ClearPath
//
//  Created by Lawrence Tran on 9/7/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import "USCRecents.h"
#import "USCResults.h"
#import "USCFavorites.h"
#import "USCTimeSlider.h"

#define METERS_PER_MILE 1609.344

@class USCLimitedPanMapView;

@protocol USCLimitedPanMapViewDelegate <NSObject>

@optional
- (BOOL)mapShouldBeginPanning:(USCLimitedPanMapView *)profilePic;
- (void)mapDidBeginPanning:(USCLimitedPanMapView *)profilePic;
- (void)mapDidPan:(USCLimitedPanMapView *)profilePic;

- (void)mapWillSnapToStart:(USCLimitedPanMapView *)profilePic duration:(NSTimeInterval)duration;
- (void)mapDidSnapToStart:(USCLimitedPanMapView *)profilePic;

@end

@interface USCMapView : UIView <UIGestureRecognizerDelegate>
{
    
    UIPanGestureRecognizer *_panGestureRecognizer;
    UILongPressGestureRecognizer *_touchDownGestureRecognizer;
    UIView *_contentView;
    
    __unsafe_unretained id<USCLimitedPanMapViewDelegate> _delegate;
    
    CGPoint _startPosition, _mapNeutralPosition ,_mapSearchPosition, _recentPosition, _searchBarPosition, _nodePosition, _favoritePosition;
    CGPoint _startNodePosition;
    
    struct
    {
        BOOL neutral: 1;
        BOOL panning: 1;
        BOOL showingRecents: 1;
        BOOL showingSearch: 1;
    } _limitedPanMapFlags;
    
    struct
    {
        BOOL showingResults: 1;
        BOOL showingPolyline: 1;
    } _state;
}

@property (nonatomic, unsafe_unretained) id<USCLimitedPanMapViewDelegate> delegate;

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKPolylineView *polylineView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *touchDownGestureRecognizer;
@property (nonatomic, strong) USCRecents *recentView;
@property (nonatomic, strong) USCFavorites *favoritesView;
@property (nonatomic, strong) USCResults *resultsView;
@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
@property (nonatomic) CLLocationCoordinate2D endCoordinate;
@property (nonatomic) BOOL hasCustomStart;
@property (nonatomic, strong) USCTimeSlider *timeSlider;

- (void)enableFullTouch:(BOOL)flag forMap:(MKMapView *)mapView;
- (void)searchShowing:(BOOL)flag;
- (void)showSearchResultsForPoints:(NSArray *)placemarks;
- (void)viewDidLoad;
- (void)showRoute:(USCRoute *)route;
- (void)closeFavorites;

@end
