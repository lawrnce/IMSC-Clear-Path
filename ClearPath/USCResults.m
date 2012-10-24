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

@property (nonatomic, strong) UIButton *nextPage;

@property (nonatomic, strong) NSArray *array;

@end

@implementation USCResults

@synthesize nextPage = _nextPage;

@synthesize array = _array;

- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)array withDictionary:(NSDictionary *)dictionary;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // init array
        self.array = [[NSArray alloc] initWithArray:array];
        
        // init buttons
        self.nextPage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        
    }
    return self;
}

#pragma mark - Layout Methods

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    // set page
    [self setResultPositions];
    
}

#pragma mark - Display Methods

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
