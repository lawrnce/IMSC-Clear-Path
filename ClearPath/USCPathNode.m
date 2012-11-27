//
//  USCPathNode.m
//  ClearPath
//
//  Created by Lawrence Tran on 11/23/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCPathNode.h"

@interface USCPathNode()

@property (nonatomic, strong) USCResultCard *card;

@end

@implementation USCPathNode

@synthesize card = _card;

- (id)initWithFrame:(CGRect)frame withCard:(USCResultCard *)card;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        // init paramters
        self.card = card;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
        title.textAlignment = UITextAlignmentCenter;
        [title setText:[NSString stringWithFormat:@"%@", card.title.text]];
        title.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
        [title sizeToFit];
        title.frame = CGRectIntegral(title.frame);
        
        [self addSubview:title];
        
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate;
{
    return [[self.card.route.coordinates lastObject] coordinate];
}

- (NSString *)name;
{
    return self.card.title.text;
}

@end
