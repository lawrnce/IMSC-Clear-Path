//
//  USCParse.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/7/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCParse.h"

#import <MapKit/MapKit.h>

@implementation USCParse

#pragma mark - Parse Methods

+ (NSArray *)parseRouteFrom:(NSString *)response;
{
    /* 
        The returned response is in this form:
        lat,long; ... lat,long;time-confirmation1-confirmation2-index@TurnByTurn
        We will ignore the confirmatoin tags.
        The parser will separate the string into an array of CLLocation objects for each lat, long
    */
    
    // Parse initial arrays
    NSArray *first = [response componentsSeparatedByString:@"@"]; // separates the coordinates from the turn by turn response string
    NSArray *separateCoordinates = [[first objectAtIndex:0] componentsSeparatedByString:@";"]; // splits string into individual coordinates
    NSArray *rawLatLong = [separateCoordinates subarrayWithRange:NSMakeRange(0, [separateCoordinates count] - 1)]; // cuts away last item
    NSArray *confrimationTags = [[separateCoordinates lastObject] componentsSeparatedByString:@"-"];
    
    // Init Mutable Array for enum
    NSMutableArray *routeCoordinates = [[NSMutableArray alloc] init];
    
    // Create numberformatter for enum
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    
    // enum for cordinates
    for (NSString *coordinates in rawLatLong)
    {
        // create CLL coordinate to store into mutable array
        CLLocationCoordinate2D location;
        
        // Break lat/long into individual components
        NSArray *latLong = [coordinates componentsSeparatedByString:@","];
        
        // Format string to double data type
        location.latitude = [[numberFormatter numberFromString:[latLong objectAtIndex:0]] doubleValue];
        location.longitude = [[numberFormatter numberFromString:[latLong objectAtIndex:1]] doubleValue];
        
        [routeCoordinates addObject:[[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude]];
    }
    
    
    
    NSNumber *travelTime = [numberFormatter numberFromString:[confrimationTags objectAtIndex:0]];
    NSString *travelTimeDisplay = [NSString stringWithFormat:@"%.0f Minutes    50 Miles", [travelTime doubleValue]];
    
    // set string time into array
    [routeCoordinates addObject:travelTimeDisplay];
    // set number time into array
    [routeCoordinates addObject:travelTime];
    
    return routeCoordinates;
}

@end
