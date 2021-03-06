//
//  USCAnnotation.h
//  ClearPath
//
//  Created by Lawrence Tran on 11/19/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface USCAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *title;

@end
