//
//  USCResults.m
//  ClearPath
//
//  Created by Lawrence Tran on 10/11/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

// IMPORTANT do not alloc all the buttons depending on results make sure you only allocate 3 at a time!!!! use index as reference 

#import "USCResults.h"

@interface USCResults()

@property (nonatomic, strong) UIButton *result1;
@property (nonatomic, strong) UIButton *result2;
@property (nonatomic, strong) UIButton *result3;

@property (nonatomic, strong) UIButton *nextPage;

@end

@implementation USCResults

@synthesize array = _array;
@synthesize nextPage = _nextPage;


- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // init buttons
        self.result1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.result2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.result3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.nextPage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
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
    
}

#pragma mark - Display Methods

//- (void)setInformationForPage:(int)page;
//{
//    // find starting index for given page
//    int i;
//    NSArray *array;
//    
//    // find the starting index according to the page given
//    // (1,0) (2,3) (3,6) (4,9) (5,12) -> relation is *3 -3
//    i = page * 3.0 - 3.0;
//    
//    // set information for the buttons in the page
//    // SAMPLE PLACEMARK "University of Southern California, Los Angeles, CA  90007, United States @ <+34.02137294,-118.28668562> +/- 100.00m, region (identifier <+34.02208300,-118.28567550> radius 770.71) <+34.02208300,-118.28567550> radius 770.71m"
//    for (int j = 0; j < 3; j++) {
//        NSArray *firstParse = [[NSArray alloc] initWithArray:[[self.array objectAtIndex:i] componentsSeparatedByString:@"@"]];
//        NSArray *secondParse = [[NSArray alloc] initWithArray:[[firstParse objectAtIndex:0] componentsSeparatedByString:@","]];
//        
//        i++;
//    }
//    
//}

- (void)setInitialButtonPosition;
{

}

- (void)setResultPositions;
{
    CGFloat x, y;
    int pages;
    
    x = CGRectGetMidX(self.bounds);
    y = CGRectGetMidY(self.bounds)/2.0f;
    
    pages = [self.array count]/3;
    
    if ([self.array count] % 3 > 0)
        pages++;
    
    for (int i = 0; i < pages; i++)
        for (int j = 0; j < 3; j++) {
            [[self.array objectAtIndex:i] setCenter:CGPointMake(x, y + (i * 100))];
            if (j == 3) x += CGRectGetMaxX(self.bounds);
        }
}

- (void)showSearchResultsForArray:(NSArray *)array withDicionary:(NSDictionary *)dictionary;
{
    _dictionary = dictionary;
    
    self.array = [[NSArray alloc] initWithArray:array];
    
    for (int i = 0; i < [array count]; i++) {
        [[self.array objectAtIndex:i] setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)/2.0f+(i * 100))];
        [[self.array objectAtIndex:i] sizeToFit];
        [[self.array objectAtIndex:i] setFrame:CGRectIntegral([[self.array objectAtIndex:i] frame])];
        [self addSubview:[self.array objectAtIndex:i]];
    }
    
    _index = [array count];
}

#pragma mark - Getters and Setters


@end
