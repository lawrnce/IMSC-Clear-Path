//
//  USCResultsPageControl.h
//  ClearPath
//
//  Created by Lawrence Tran on 11/21/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USCResultsPageControl : UIPageControl
{
    NSInteger currentPage;
    NSInteger numberOfPages;
    NSInteger maxNumberOfPages;
    BOOL hidesForSinglePage;
}

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger maxNumberOfPages;
@property (nonatomic) BOOL hidesForSinglePage;
@property (nonatomic, strong) UIColor *inactivePageColor;
@property (nonatomic, strong) UIColor *activePageColor;

@end
