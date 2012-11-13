//
//  USCLocationPoint.h
//  ClearPath
//
//  Created by Lawrence Tran on 11/13/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

/*      ** This class represents the information of a search result in object form.
        This will allow easier access to a result's information
*/

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface USCLocationPoint : CLLocation

@property (nonatomic, strong) NSArray *coordinateArray;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *travelTime;
@property (nonatomic, strong) NSNumber *travelTimeNumber;

-(void)setAttributesFromString:(NSString *)rawString;

@end
