//
//  USCParse.h
//  ClearPath
//
//  Created by Lawrence Tran on 11/7/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USCParse : NSObject

// Route Parsing
+ (NSArray *)parseRouteFrom:(NSString *)response; // method returns an array of CLLocations with the last element travel time (string)

@end
