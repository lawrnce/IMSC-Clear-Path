//
//  USCLocationPoint.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/13/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCRoute.h"
#import "USCParse.h"

@implementation USCRoute

@synthesize coordinates = coordinates;
@synthesize name = _name;
@synthesize address = _address;
@synthesize travelTime = _travelTime;
@synthesize travelTimeNumber = _travelTimeNumber;

-(void)setAttributesFromString:(NSString *)rawString;
{
    if (!rawString) return;
    
    // create mutable copy. This returns an array with order [raw lat], [raw long], ... ,[time string], [time number]
    NSMutableArray *mutableCopy = [[USCParse parseRouteFrom:rawString] mutableCopy];
    
    // set time number
    self.travelTimeNumber = [mutableCopy lastObject];
    
    // pop the back
    [mutableCopy removeLastObject];
    
    // set time string
    self.travelTime = [mutableCopy lastObject];
    
    // pop the back
    [mutableCopy removeLastObject];
    
    // set the array
    self.coordinates = mutableCopy;
    
}

@end
