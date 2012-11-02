//
//  USCResults.h
//  ClearPath
//
//  Created by Lawrence Tran on 10/11/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USCResults : UIView
{
    NSDictionary *_dictionary;
    int _index, _page;
}

@property (nonatomic, strong) NSArray *array;

@end
