//
//  USCLocationPoint.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/13/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCLocationPoint.h"
#import "USCParse.h"

@implementation USCLocationPoint

@synthesize coordinateArray = coordinateArray;
@synthesize name = _name;
@synthesize travelTime = _travelTime;
@synthesize travelTimeNumber = _travelTimeNumber;

-(void)setAttributesFromString:(NSString *)rawString;
{
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
    self.coordinateArray = mutableCopy;
    
}

@end
