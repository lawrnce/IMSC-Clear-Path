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
    
    CGPoint _startPosition, _mapNeutralPosition ,_mapSearchPosition, _recentPosition, _searchBarPosition;
    
    struct {
        BOOL neutral: 1;
        BOOL panning: 1;
        BOOL showingRecents: 1;
        BOOL showingSearch: 1;
    } _limitedPanMapFlags;
}

@property (nonatomic, unsafe_unretained) id<USCLimitedPanMapViewDelegate> delegate;

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKPolylineView *polylineView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *touchDownGestureRecognizer;
@property (nonatomic, strong) USCRecents *recentView;
@property (nonatomic, strong) USCResults *resultsView;
@property (nonatomic, strong) UITextField *searchBar;

- (void)enableTouch:(BOOL)flag forMap:(MKMapView *)mapView;
- (void)searchShowing:(BOOL)flag;
- (void)showSearchResultsForArray:(NSArray *)array;

@end
