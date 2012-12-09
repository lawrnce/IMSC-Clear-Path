//
//  USCViewController.m
//  ClearPath
//
//  Created by Lawrence Tran on 9/7/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCViewController.h"

#import <RestKit/RestKit.h>
#import "USCMapView.h"
#import "NSDate+RoundTime.h"
#import "USCRoute.h"
#import "USCTimeSlider.h"

#define kSCALE 1
#define kLAT 34.025454
#define kLONG -118.291554

@interface USCViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, RKRequestDelegate, USCTimeSlider>

// variable properties
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLRegion *currentRegion;

// class properties
@property (nonatomic, strong) USCMapView *mapView;

// other properties
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) NSDictionary *timeIndex;
@property (nonatomic, strong) NSMutableArray *nameAdressPassing;

@property (nonatomic, strong) NSMutableArray *locationPoints;
@property (nonatomic, strong) UIView *loadingView;


@property (nonatomic) BOOL timeChanged;

@end

@implementation USCViewController

@synthesize locationManager = _locationManager;
@synthesize currentRegion = _currentRegion;

@synthesize mapView = _mapView;

@synthesize dictionary = _dictionary;
@synthesize timeIndex = _timeIndex;

@synthesize nameAdressPassing = _nameAdressPassing;

@synthesize locationPoints = _locationPoints;

@synthesize loadingView = _loadingView;

@synthesize timeChanged;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // mapView
    self.mapView = [[USCMapView alloc]initWithFrame:CGRectZero]; // init
    self.mapView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds));
    self.mapView.center = self.view.center;

    self.view = self.mapView;
    
    self.locationPoints = [[NSMutableArray alloc] init];
    
    [self.mapView viewDidLoad];
    self.timeChanged = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    // set delegate
    self.mapView.searchBar.delegate = self;
    self.mapView.timeSlider.delegate = self;
    
    // set button targets
    [self.mapView.recentView.gas addTarget:self action:@selector(gasButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView.recentView.hospital addTarget:self action:@selector(hospitalButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView.recentView.food addTarget:self action:@selector(foodButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Text Field Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    // move map up
    [self.mapView searchShowing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    
    // move map down
    [self.mapView searchShowing:NO];
    
    // geocode result
    if (textField.text) [self performGeocode:self withAddress:textField.text];
    
    if (self.mapView.resultsView)
    {
        [self.mapView.resultsView removeFromSuperview];
    }

    // check start coordinate
    if (!self.mapView.hasCustomStart)
        self.mapView.startCoordinate = self.mapView.mapView.userLocation.coordinate;
     
        NSLog(@"Start Coordinate: %f, %f", self.mapView.startCoordinate.latitude, self.mapView.startCoordinate.longitude);
    
    // start progress indicator
    self.loadingView.backgroundColor = [UIColor lightGrayColor];
    self.loadingView.alpha = 0.5f;
    
    
    [self.view addSubview:self.loadingView];
    
    return NO;
}

#pragma mark - Favorities Button handling

-(void)gasButton:(id)sender;
{
    [self.mapView closeFavorites];
    // check start coordinate
    if (!self.mapView.hasCustomStart)
        self.mapView.startCoordinate = self.mapView.mapView.userLocation.coordinate;
    
    NSLog(@"Start Coordinate: %f, %f", self.mapView.startCoordinate.latitude, self.mapView.startCoordinate.longitude);
    self.locationPoints = [[NSMutableArray alloc] init];;
    [self setGasPlacemarks];
}

-(void)hospitalButton:(id)sender;
{
    [self.mapView closeFavorites];
    
}

-(void)foodButton:(id)sender;
{
    [self.mapView closeFavorites];
    
}

#pragma mark - Geocoding Methods

- (void)willRouteFrom:(CLLocation *)start To:(CLLocation *)end withTime:(NSDate *)index;
{
    self.timeChanged = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TimeIndex" ofType:@"plist"];
    self.timeIndex = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *roundedTime = [index setRoundTimeToString:[index currentTimeRoundedToNearestTimeInterval:15*60]];

    
        NSLog(@"POKEMON!!! %@",[self.timeIndex valueForKey:roundedTime]);
    
    // "34.025454,-118.291554"  Set parameters into dictionary
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%f,%f", start.coordinate.latitude, start.coordinate.longitude],@"start",
                            [NSString stringWithFormat:@"%f,%f",end.coordinate.latitude,end.coordinate.longitude],@"end",
                            [self.timeIndex valueForKey:roundedTime], @"time",
                            @"False", @"update",
                            [self receiveDayOfWeek], @"day",
                            nil];
    // start restkit
    [self sendRequests:params];
}


- (void)performGeocode:(id)sender withAddress:(NSString *)address;
{
    // remove everything in locations points array
    [self.locationPoints removeAllObjects];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    // geocoder returns an array of placemarks. Each placemark is a string that needs to be parsed
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"geocodeAddressString:completionHandler: Completion Handler called!");
      
        if (error)
        {
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:error];
            return;
        }
        
        NSLog(@"Received placemarks: %@", placemarks);
        [self createLocationPointsForPlacemarks:placemarks];
        _reference = [placemarks count];
        _count = 0;
    }];

}

// display a given NSError in an UIAlertView
- (void)displayError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(),^ {
        
        NSString *message;
        switch ([error code])
        {
            case kCLErrorGeocodeFoundNoResult:
                message = @"kCLErrorGeocodeFoundNoResult";
                break;
            case kCLErrorGeocodeCanceled:
                message = @"kCLErrorGeocodeCanceled";
                break;
            case kCLErrorGeocodeFoundPartialResult:
                message = @"kCLErrorGeocodeFoundNoResult";
                break;
            default:
                message = [error description];
                break;
        }
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"An error occurred."
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [alert show];
    });   
}

- (void)createLocationPointsForPlacemarks:(NSArray *)placemarks;
{
    for (CLPlacemark *element in placemarks)
    {
        // parse Cllocation for name and address
        // SAMPLE PLACEMARK "University of Southern California, Los Angeles, CA  90007, United States @ <+34.02137294,-118.28668562> +/- 100.00m, region (identifier <+34.02208300,-118.28567550> radius 770.71) <+34.02208300,-118.28567550> radius 770.71m"
        
        // create location point
        USCRoute *locationPoint = [[USCRoute alloc] init];
        locationPoint.name = element.name;
        
        // set into mutable array for results
        [self.locationPoints addObject:locationPoint];
        
        NSArray *first = [[element description] componentsSeparatedByString:@"@"];
        NSArray *second = [[first objectAtIndex:0] componentsSeparatedByString:@","];
        
        // set name
        locationPoint.name = [second objectAtIndex:0];
        
        // set address
        NSArray *address = [second subarrayWithRange:NSMakeRange(1, [second count] - 1)]; // cuts away last item
        locationPoint.address = [[address valueForKey:@"description"] componentsJoinedByString:@""];
        
        NSLog(@"%@, %@", [[self.locationPoints objectAtIndex:0] name], [[self.locationPoints objectAtIndex:0] address]);
        
        // call rest kit
        [self navigateTo:element.location forTimeIndex:[self receiveRoundedTime] forDay:[self receiveDayOfWeek]];
    }
}

#pragma mark - Rest Kit Delegate

- (void)navigateTo:(CLLocation *)end forTimeIndex:(NSString *)index forDay:(NSString *)day;
{
    
    // "34.025454,-118.291554"  Set parameters into dictionary
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%f,%f", self.mapView.startCoordinate.latitude, self.mapView.startCoordinate.longitude],@"start",
                            [NSString stringWithFormat:@"%f,%f",end.coordinate.latitude,end.coordinate.longitude],@"end",
                            index, @"time",
                            @"False", @"update",
                            day, @"day",
                            nil];
    // start restkit
    [self sendRequests:params];
}

- (void)sendRequests:(NSDictionary *)params;
{
    [[RKClient sharedClient] get:@"?" queryParameters:params delegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{    
    
    if ([response isOK])
    {
        // Success! Let's take a look at the data
        NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        
        if (self.timeChanged)
        {
            USCRoute *newTimeRoute = [[USCRoute alloc] init];
            [newTimeRoute setAttributesFromString:[response bodyAsString]];
            [self.mapView showRoute:newTimeRoute];
            self.timeChanged = NO;
        }
        else
        {
            [[self.locationPoints objectAtIndex:_count] setAttributesFromString:[response bodyAsString]];
            
            _count++;
            
            if(_count == _reference)
            {
//                NSLog(@"SENT: %@", [[self.locationPoints objectAtIndex:0] name]);
                
                
                //** test
//                for (int i = 0; i < 9; i++)
//                {
//                    [self.locationPoints addObject:[self.locationPoints objectAtIndex:0]];
//                }
                
                [self.mapView showSearchResultsForPoints:self.locationPoints];
                [self.loadingView removeFromSuperview];
            }
        }
    }
}

#pragma mark - Time Methods

- (NSString *)receiveRoundedTime;
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TimeIndex" ofType:@"plist"];
    self.timeIndex = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSDate *date = [[NSDate alloc] init];
    NSString *roundedTime = [date setRoundTimeToString:[date currentTimeRoundedToNearestTimeInterval:15*60]];
    
    return [self.timeIndex valueForKey:roundedTime];
}

- (NSString *)receiveDayOfWeek;
{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayOfWeek = [dateFormatter stringFromDate:date];
    
    return dayOfWeek;
}

#pragma mark - Table View Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"RecentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"Address"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"details"];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
        cell.backgroundView.backgroundColor = [UIColor blueColor];
        cell.frame = CGRectIntegral(cell.frame);
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 10;
}

#pragma mark - TableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 125.0f;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"yoyoyoyoyo");
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"yo");
}

- (void)setGasPlacemarks;
{
//    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    _reference = 1;
    _count = 0;
    
    // HARD CODE THIS SHIT
    USCRoute *place1 = [[USCRoute alloc] init];
    place1.name = [NSString stringWithFormat:@"Mobil"];
    place1.address = [NSString stringWithFormat:@"2620 South Figueroa Street"];
    [self.locationPoints addObject:place1];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:34.02773 longitude:-118.27612];
    [self navigateTo:location1 forTimeIndex:[self receiveRoundedTime] forDay:[self receiveDayOfWeek]];
    
    
    // OTHER
    
    USCRoute *place2 = [[USCRoute alloc] init];
    place2.name = [NSString stringWithFormat:@"LS Union 76"];
    place2.address = [NSString stringWithFormat:@"1403 West Adams Boulevard"];
    place2.travelTime = [NSString stringWithFormat:@"7 Minutes    2 Miles"];
    [self.locationPoints addObject:place2];
    
    USCRoute *place3 = [[USCRoute alloc] init];
    place3.name = [NSString stringWithFormat:@"Amin's Oil"];
    place3.address = [NSString stringWithFormat:@"2620 South Figueroa Street"];
    place3.travelTime = [NSString stringWithFormat:@"10 Minutes    3 Miles"];
    [self.locationPoints addObject:place3];
    
    USCRoute *place4 = [[USCRoute alloc] init];
    place4.name = [NSString stringWithFormat:@"Normandie"];
    place4.address = [NSString stringWithFormat:@"2217 South Normandie Avenue"];
    place4.travelTime = [NSString stringWithFormat:@"13 Minutes    3 Miles"];
    [self.locationPoints addObject:place4];
    
    USCRoute *place5 = [[USCRoute alloc] init];
    place5.name = [NSString stringWithFormat:@"ARCO"];
    place5.address = [NSString stringWithFormat:@"2211 South Hoover Street"];
    place5.travelTime = [NSString stringWithFormat:@"15 Minutes    3 Miles"];
    [self.locationPoints addObject:place5];
    
    USCRoute *place6 = [[USCRoute alloc] init];
    place6.name = [NSString stringWithFormat:@"Ardicuno"];
    place6.address = [NSString stringWithFormat:@"1247 Magic Street"];
    place6.travelTime = [NSString stringWithFormat:@"20 Minutes    5 Miles"];
    [self.locationPoints addObject:place6];
    
    USCRoute *place7 = [[USCRoute alloc] init];
    place7.name = [NSString stringWithFormat:@"Shell"];
    place7.address = [NSString stringWithFormat:@"3000 South Figueroa Street"];
    place7.travelTime = [NSString stringWithFormat:@"25 Minutes    10 Miles"];
    [self.locationPoints addObject:place7];
    
    USCRoute *place8 = [[USCRoute alloc] init];
    place8.name = [NSString stringWithFormat:@"PF Chang's"];
    place8.address = [NSString stringWithFormat:@"123 Vermont"];
    place8.travelTime = [NSString stringWithFormat:@"25 Minutes    8 Miles"];
    [self.locationPoints addObject:place8];
    
    USCRoute *place9 = [[USCRoute alloc] init];
    place9.name = [NSString stringWithFormat:@"Magic"];
    place9.address = [NSString stringWithFormat:@"2211 Olympic"];
    place9.travelTime = [NSString stringWithFormat:@"30 Minutes    10 Miles"];
    [self.locationPoints addObject:place9];

}

@end
