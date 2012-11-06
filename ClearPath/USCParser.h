//
//  USCParser.h
//  ClearPathDemo
//
//  Created by TCC 330 on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USCParser : NSObject

// Route Parsing
- (NSArray *)parseRouteFrom:(NSString *)response;
- (NSString *)parseTravelTime;

- (NSNumber *)parseConfirmationStartIndex;
- (NSNumber *)parseConfirmationEndIndex;
- (NSNumber *)parseConfirmationTimeIndex;

@end
