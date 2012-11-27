//
//  USCResults.h
//  ClearPath
//
//  Created by Lawrence Tran on 10/11/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USCResultCard.h"
#import "USCResultsPageControl.h"
#import "USCResultsScrollView.h"

@class USCResults;

@protocol USCResultsDelegate <NSObject>

@required

- (void)willRouteTo:(USCRoute *)location;
- (void)willDisplayInformationForCard:(USCResultCard *)card;

@end

@interface USCResults : UIView <UIScrollViewDelegate>
{
    BOOL itemsAdded;
    
	int columnCount;
	int rowCount;
	CGFloat itemWidth;
	CGFloat itemHeight;
    CGFloat minX;
    CGFloat minY;
    CGFloat paddingX;
    CGFloat paddingY;
    __unsafe_unretained id<USCResultsDelegate> _delegate;
    USCResultCard *_selectedResultCard;
    CGPoint _selectedOrginalPosition;
}

@property (nonatomic, unsafe_unretained) id<USCResultsDelegate> delegate;
@property (nonatomic, strong) USCResultsScrollView *pagesScrollView;
@property (nonatomic, strong) USCResultsPageControl *pageControl;
@property (nonatomic, strong) NSArray *pages;

-(void)layoutLauncher;
-(void)layoutLauncherAnimated:(BOOL)animated;
-(int)maxItemsPerPage;
-(int)maxPages;

- (id)initWithFrame:(CGRect)frame withPlacemarks:(NSArray *)pages delegate:(id<USCResultsDelegate>)delegate;
- (void)moveSelectedCardToOrginal;

@end
