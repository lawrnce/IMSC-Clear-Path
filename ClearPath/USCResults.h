//
//  USCResults.h
//  ClearPath
//
//  Created by Lawrence Tran on 10/11/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class USCResults;
//
//@protocol USCResultsDelegate <NSObject>
//
//@required
//
//- (void)createLocationPointsForPlacemarks:(NSArray *)placemarks;
//
//@end

@interface USCResults : UIView
{
//    __unsafe_unretained id<USCResultsDelegate> _delegate;
    NSDictionary *_dictionary;
    __unsafe_unretained id _delegate;
    int _index, _page;
}

//@property (nonatomic, unsafe_unretained) id<USCResultsDelegate> delegate;

@property (nonatomic, strong) NSArray *resultCards;

//- (void)setLocationPoints:(NSArray *)placemarks;

- (id)initWithFrame:(CGRect)frame andWithResults:(NSArray *)results;

@end
