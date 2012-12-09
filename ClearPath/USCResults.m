//
//  USCResults.m
//  ClearPath
//
//  Created by Lawrence Tran on 10/11/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

// IMPORTANT do not alloc all the buttons depending on results make sure you only allocate 3 at a time!!!! use index as reference 

#import "USCResults.h"

struct NItemLocation
{
	NSInteger page;
	NSInteger sindex;
};

typedef struct NItemLocation NItemLocation;

static const int pControllHeight = 30;
static const int maxPageCount = 6;

/* iPhone */
static const int maxItemsPageCount = 3;

static const int portraitItemWidth = 310;
static const int portraitItemHeight = 75;
static const int portraitColumnCount = 1;
static const int portraitRowCount = 3;
static const CGFloat portraitItemXStart = 5;
static const CGFloat portraitItemYStart = 80;
static const CGFloat portraitXPadding = 0;
static const CGFloat portraitYPadding = 45;

@interface USCResults () <USCResultCardDelegate>

-(void)setupCurrentViewLayoutSettings;

@property (nonatomic, retain) NSTimer *itemHoldTimer;
@property (nonatomic, retain) NSTimer *movePagesTimer;

@end

@implementation USCResults

@synthesize pagesScrollView = _pageScrollView;
@synthesize pageControl = _pageControl;
@synthesize pages = _pages;
@synthesize itemHoldTimer = _itemHoldTimer;
@synthesize movePagesTimer = _movePagesTimer;
@synthesize hasStartNode = _hasStartNode;

#pragma mark - View lifecycle

- (id)initWithFrame:(CGRect)frame withPlacemarks:(NSArray *)placemarks delegate:(id<USCResultsDelegate>)delegate;
{
    if ((self = [super initWithFrame:frame]))
	{
		itemsAdded = NO;
		[self setupCurrentViewLayoutSettings];
	
        // create array size of pages
        NSMutableArray *pages = [[NSMutableArray alloc] init];
        
        // Content of one page
        NSMutableArray *pageContent = [[NSMutableArray alloc] init];
        
        // create a counter
        NSInteger count = 0;
        
        // for index
        int index = 1;
        
        if (self.hasStartNode) {
            index++;
        }
        
        // set placemarks to the pages
        for (USCRoute *route in placemarks)
        {
            // init a resultCard with location point and add to array
            [pageContent addObject:[[USCResultCard alloc] initWithFrame:CGRectZero withRoute:route delegate:self withIndex:index]];
            
            // increase count
            count++;
            index++;
            
            // three have been added
            if (count == 3)
            {
                // add pageContent to pages
                [pages addObject:[NSArray arrayWithArray:pageContent]];
                
                // clear pageContent;
                [pageContent removeAllObjects];
                
                count = 0;
            }
        }
        
        // set in last page
        if ([pageContent count] > 0)
        {
            [pages addObject:[NSArray arrayWithArray:pageContent]];
            [pageContent removeAllObjects];
        }
        
        [self setPages:pages];
        
        [self setDelegate:delegate];
        
		[self setPagesScrollView:[[USCResultsScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - pControllHeight)]];
        
		self.pagesScrollView.delegate = self;
		self.pagesScrollView.pagingEnabled = YES;
		self.pagesScrollView.showsHorizontalScrollIndicator = NO;
		self.pagesScrollView.showsVerticalScrollIndicator = NO;
		self.pagesScrollView.alwaysBounceHorizontal = YES;
		self.pagesScrollView.scrollsToTop = NO;
		self.pagesScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.pagesScrollView.delaysContentTouches = YES;
		self.pagesScrollView.multipleTouchEnabled = NO;
		[self addSubview:self.pagesScrollView];
		
		[self setPageControl:[[USCResultsPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - pControllHeight - 45, frame.size.width, pControllHeight)]]; //if starts landscape this will break...
		self.pageControl.numberOfPages = 1;
		self.pageControl.currentPage = 0;
        self.pageControl.maxNumberOfPages = maxPageCount;
		self.pageControl.backgroundColor = [UIColor clearColor];
        self.pageControl.alpha = 1.0f;
		[self.pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
		[self addSubview:self.pageControl];
        
        [self addObserver:self forKeyPath:@"frame" options:0 context:nil];
    }
    return self;
}

-(void)layoutSubviews;
{
    [super layoutSubviews];
    
    CGFloat pageWidth = self.pagesScrollView.frame.size.width;
	
    [self setupCurrentViewLayoutSettings];
    
	for (NSMutableArray *page in self.pages)
	{
        CGFloat x = minX;
        CGFloat y = minY;
		int itemsCount = 1;
        
		for (USCResultCard *item in page)
		{
            item.frame = CGRectMake(x, y, itemWidth, itemHeight);
            [self.pagesScrollView addSubview:item];
            
			x += itemWidth + paddingX;
            y += itemHeight + paddingY;
            x = minX;
			
			itemsCount++;
		}
		
		minX += pageWidth;
	}
	
	self.pageControl.numberOfPages = self.pages.count;
	self.pagesScrollView.contentSize = CGSizeMake(self.pagesScrollView.frame.size.width * self.pages.count,rowCount * itemHeight);
	
	itemsAdded = YES;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}

#pragma mark - Results Card Delegate Methods

// prepares mapView to route
- (void)willRouteAsDestination:(USCRoute *)route;
{
    if ([self.delegate respondsToSelector:@selector(willRouteTo:)])
        [self.delegate willRouteTo:route];
}

- (void)willShowInformation:(USCResultCard *)resultCard
{
    if ([self.delegate respondsToSelector:@selector(willDisplayInformationForCard:)])
        [self.delegate willDisplayInformationForCard:resultCard];
    
    // save original center
    _selectedOrginalPosition = resultCard.center;
    
    // store point to card
    _selectedResultCard = resultCard;
    
    // remove all result cards
    for (NSMutableArray *page in self.pages)
    {
        for (USCResultCard *item in page)
		{
            if (resultCard != item)
            item.hidden = YES;
		}
    }
    
    // move card to top
    [UIView animateWithDuration:0.3f animations:^{
    
        resultCard.time.hidden = YES;
        
        resultCard.sideButton.hidden = YES;
        
        CGPoint point = resultCard.center;
        
        point.y = (CGRectGetMidY(self.bounds) * 0.35f);
        
        resultCard.center = point;
    
    }];
    
    // remove page control
    self.pageControl.hidden = YES;
    self.pagesScrollView.userInteractionEnabled = NO;
    
    // find current page
    NSLog(@"%d", [self.pageControl currentPage]);
}

- (void)moveSelectedCardToOrginal;
{
    // move card to top
    [UIView animateWithDuration:0.3f animations:^{
        
        _selectedResultCard.time.hidden = NO;
        _selectedResultCard.sideButton.hidden = NO;
        _selectedResultCard.center = _selectedOrginalPosition;
        
    }];
}

#pragma mark - ScrollView and PageControl Management

- (void)pageChanged
{
	self.pagesScrollView.contentOffset = CGPointMake(self.pageControl.currentPage * self.pagesScrollView.frame.size.width, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	self.pageControl.currentPage = floor((self.pagesScrollView.contentOffset.x - self.pagesScrollView.frame.size.width / 2) /
                                         self.pagesScrollView.frame.size.width) + 1;	
}

- (void)updateFrames
{
    self.pagesScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - pControllHeight);
	self.pageControl.frame = CGRectMake(0, self.frame.size.height - pControllHeight, self.frame.size.width, pControllHeight);
	[self.pageControl setNeedsDisplay];
}

-(void)didChangeValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"frame"]) {
        [self updateFrames];
    }
}

#pragma mark - Layout Settings

-(int)maxItemsPerPage
{
    return maxItemsPageCount;
}

-(int)maxPages
{
    return maxPageCount;
}

-(void)setupCurrentViewLayoutSettings
{
    minX = portraitItemXStart;
    minY = portraitItemYStart;
    paddingX = portraitXPadding;
    paddingY = portraitYPadding;
    columnCount = portraitColumnCount;
    rowCount = portraitRowCount;
    itemWidth = portraitItemWidth;
    itemHeight = portraitItemHeight;
}

#pragma mark - Layout Management

-(void)layoutLauncher
{
	[self layoutLauncherAnimated:YES];
}

-(void)layoutLauncherAnimated:(BOOL)animated
{
    [self updateFrames];
    
    [UIView animateWithDuration:animated ? 0.3 : 0
                     animations:^{
                         [self layoutIfNeeded];
                     }];
    
	[self pageChanged];
}

@end
