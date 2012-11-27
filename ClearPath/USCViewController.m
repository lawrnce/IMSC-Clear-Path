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

#define kSCALE 1
#define kLAT 34.025454
#define kLONG -118.291554

@interface USCViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, RKRequestDelegate>

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

@end

@implementation USCViewController

@synthesize locationManager = _locationManager;
@synthesize currentRegion = _currentRegion;

@synthesize mapView = _mapView;

@synthesize dictionary = _dictionary;
@synthesize timeIndex = _timeIndex;

@synthesize nameAdressPassing = _nameAdressPassing;

@synthesize locationPoints = _locationPoints;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // mapView
    self.mapView = [[USCMapView alloc]initWithFrame:CGRectZero]; // init
    self.mapView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds));
    self.mapView.center = self.view.center;

    self.view = self.mapView;
    
    self.locationPoints = [[NSMutableArray alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // set view defaults
    self.view.backgroundColor = [UIColor whiteColor];
    
    // set delegate
    self.mapView.recentView.tableView.dataSource = self;
    self.mapView.recentView.tableView.delegate = self;
    self.mapView.searchBar.delegate = self;
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
    
    return NO;
}

#pragma mark - Geocoding Methods

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

        [[self.locationPoints objectAtIndex:_count] setAttributesFromString:[response bodyAsString]];
        
        _count++;
        
        if(_count == _reference)
        {
            NSLog(@"SENT: %@", [[self.locationPoints objectAtIndex:0] name]);
            
            
            //** test
            for (int i = 0; i < 9; i++)
            {
                [self.locationPoints addObject:[self.locationPoints objectAtIndex:0]];
            }
            
            [self.mapView showSearchResultsForPoints:self.locationPoints];
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
    
    //    // Configure the cell...
    //    NSString *continent = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    //    NSString *country = [[self.favAndRecent valueForKey:continent] objectAtIndex:indexPath.row];
    //
    //    cell.textLabel.text = country;
    //
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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

@end
