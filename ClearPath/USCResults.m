//
//  USCResults.m
//  ClearPath
//
//  Created by Lawrence Tran on 10/11/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

// IMPORTANT do not alloc all the buttons depending on results make sure you only allocate 3 at a time!!!! use index as reference 

#import "USCResults.h"

#import "USCLocationPoint.h"
#import "USCResultCard.h"

@interface USCResults()

@property (nonatomic, strong) NSArray *displayArray;

@property (nonatomic, strong) UIButton *result1;
@property (nonatomic, strong) UIButton *result2;
@property (nonatomic, strong) UIButton *result3;

@property (nonatomic, strong) UIButton *nextPage;

@end

@implementation USCResults

@synthesize nextPage = _nextPage;


- (id)initWithFrame:(CGRect)frame andWithResults:(NSArray *)results;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        // set resultCard array to public property
        self.resultCards = [[NSArray alloc] initWithArray:results];
        
        // test
//        NSLog(@"%@", [[self.resultCards objectAtIndex:0] name]);
    }
    return self;
}

#pragma mark - Layout Methods

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    _page = 1; //set page count 
//    [self setInformationForPage:_page];
    
    // set page
    [self setResultPositions];
    
    [self setInformationForPage:1];
    
}

#pragma mark - Display Methods

- (void)setInformationForPage:(int)page;
{
    // place each result in appropiate location
    for (int i = 0; i < [self.resultCards count]; i++)
    {
        // set frame
        [[self.resultCards objectAtIndex:i] setFrame:CGRectMake(0, 0, CGRectGetMaxX(self.bounds)*0.95f, CGRectGetMaxY(self.bounds)*0.25f)];
        // set center *** THIS WILL BE CHANGED AFTER WE GET MORE THAN ONE RESULT***
        [[self.resultCards objectAtIndex:i] setCenter:CGPointMake(self.center.x, CGRectGetMaxY(self.bounds)*.15f)];
        // add to subview
        [self addSubview:[self.resultCards objectAtIndex:i]];
    }
//
//    // find starting index for given page
//    int i;
//    NSArray *array;
//    
//    // find the starting index according to the page given
//    // (1,0) (2,3) (3,6) (4,9) (5,12) -> relation is *3 -3
//    i = page * 3.0 - 3.0;
//    
//    // set information for the buttons in the page
//  
//    for (int j = 0; j < 3; j++)
//    {
//        NSArray *firstParse = [[NSArray alloc] initWithArray:[[self.array objectAtIndex:i] componentsSeparatedByString:@"@"]];
//        NSArray *secondParse = [[NSArray alloc] initWithArray:[[firstParse objectAtIndex:0] componentsSeparatedByString:@","]];
//        
//        i++;
//    }
}

- (void)setInitialButtonPosition;
{

}

- (void)setResultPositions;
{
//    CGFloat x, y;
//    int pages;
//    
//    x = CGRectGetMidX(self.bounds);
//    y = CGRectGetMidY(self.bounds)/2.0f;
//    
//    pages = [self.array count]/3;
//    
//    if ([self.array count] % 3 > 0)
//        pages++;
//    
//    for (int i = 0; i < pages; i++)
//        for (int j = 0; j < 3; j++) {
//            [[self.array objectAtIndex:i] setCenter:CGPointMake(x, y + (i * 100))];
//            if (j == 3) x += CGRectGetMaxX(self.bounds);
//        }
//}
//
//- (void)showSearchResultsForArray:(NSArray *)array withDicionary:(NSDictionary *)dictionary;
//{
//    _dictionary = dictionary;
//    
//    self.array = [[NSArray alloc] initWithArray:array];
//    
//    for (int i = 0; i < [array count]; i++) {
//        [[self.array objectAtIndex:i] setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)/2.0f+(i * 100))];
//        [[self.array objectAtIndex:i] sizeToFit];
//        [[self.array objectAtIndex:i] setFrame:CGRectIntegral([[self.array objectAtIndex:i] frame])];
//        [self addSubview:[self.array objectAtIndex:i]];
//    }
//    
//    _index = [array count];
}

//#pragma mark - Delegate Passing
//
//- (void)setLocationPoints:(NSArray *)placemarks;
//{
//    // check delegate
//    if([self.delegate respondsToSelector:@selector(createLocationPointsForPlacemarks:)])
//       [self.delegate createLocationPointsForPlacemarks:placemarks];
//}

#pragma mark - Getters and Setters



@end
