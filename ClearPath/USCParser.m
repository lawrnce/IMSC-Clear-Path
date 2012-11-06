//
//  USCParser.m
//  ClearPathDemo
//
//  Created by TCC 330 on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "USCParser.h"
#import <MapKit/MapKit.h>

@interface USCParser ()

@property (nonatomic, strong) NSArray *confrimationTags;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

@implementation USCParser

// Class Extentsion properties
@synthesize confrimationTags = _confrimationTags;
@synthesize numberFormatter = _numberFormatter;

#pragma mark - Route Parsing

- (NSArray *)parseRouteFrom:(NSString *)response;
{
    // Parse initial arrays
    NSArray *separateRawLatLong = [response componentsSeparatedByString:@";"];
    NSArray *rawLatLong = [separateRawLatLong subarrayWithRange:NSMakeRange(0, [separateRawLatLong count] - 1)];
    self.confrimationTags = [[separateRawLatLong lastObject] componentsSeparatedByString:@"-"];
        
    // Init Mutable Array for enum
    NSMutableArray *routeCoordinates = [[NSMutableArray alloc] init];
    
    // Create numberformatter for enum
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    
    // enum for cordinates
    for (NSString *coordinates in rawLatLong) {
        // create CLL coordinate to store into mutable array
        CLLocationCoordinate2D location;
        // Break lat/long into individual components
        NSArray *latLong = [coordinates componentsSeparatedByString:@","];
        location.latitude = [[self.numberFormatter numberFromString:[latLong objectAtIndex:0]] doubleValue];
        location.longitude = [[self.numberFormatter numberFromString:[latLong objectAtIndex:1]] doubleValue];
        [routeCoordinates addObject:[[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude]]; 
    }  
   
    return routeCoordinates;
}

- (NSString *)parseTravelTime;
{
    NSNumber *travelTime = [self.numberFormatter numberFromString:[self.confrimationTags objectAtIndex:0]]; 
    NSString *travelTimeDisplay = [NSString stringWithFormat:@"%.0f Mins", [travelTime doubleValue]];
    
    return travelTimeDisplay;
}

- (NSNumber *)parseConfirmationStartIndex;
{
    NSNumber *startIndex = [self.numberFormatter numberFromString:[self.confrimationTags objectAtIndex:1]];
    
    return startIndex;
}

- (NSNumber *)parseConfirmationEndIndex;
{
    NSNumber *endIndex = [self.numberFormatter numberFromString:[self.confrimationTags objectAtIndex:2]];

    return endIndex;
}

- (NSNumber *)parseConfirmationTimeIndex;
{
    NSNumber *timeIndex = [self.numberFormatter numberFromString:[self.confrimationTags objectAtIndex:3]];
    
    return timeIndex;
}

@end
