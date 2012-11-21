//
//  USCViewController.h
//  ClearPath
//
//  Created by Lawrence Tran on 9/7/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface USCViewController : UIViewController
{
    
    NSString *_name, *_address;
    
    int _count, _reference;
    
    struct {
        BOOL updated: 1;
        BOOL needsUpdate: 1;
    } _userLocation;
}

@end
