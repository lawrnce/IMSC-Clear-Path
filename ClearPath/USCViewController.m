//
//  USCViewController.m
//  ClearPath
//
//  Created by Lawrence Tran on 9/7/12.
//  Copyright (c) 2012 Lawrence Tran. All rights reserved.
//

#import "USCViewController.h"
#import "USCMapView.h"

#define kSCALE 1

@interface USCViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLRegion *currentRegion;

// class properties
@property (nonatomic, strong) USCMapView *mapView;

// other properties
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation USCViewController

@synthesize locationManager = _locationManager;
@synthesize currentRegion = _currentRegion;

@synthesize mapView = _mapView;

@synthesize dictionary = _dictionary;
@synthesize array = _array;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // find current positoin
//    [self receiveCurrentLocation];
    
    // mapView
    self.mapView = [[USCMapView alloc]initWithFrame:CGRectZero]; // init

    [self.view addSubview:self.mapView]; // add into subview
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // set view defaults
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mapView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds)*kSCALE, CGRectGetMaxY(self.view.bounds)*kSCALE);
    self.mapView.center = self.view.center;
    
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
    [self performGeocode:self];
    
    return NO;
}

#pragma mark - Table View Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"RecentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
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

#pragma mark - Geocoding Methods

- (void)performGeocode:(id)sender;
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:self.mapView.searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"geocodeAddressString:completionHandler: Completion Handler called!");
        if (error)
        {
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:error];
            return;
        }
        
        NSLog(@"Received placemarks: %@", placemarks);
        [self createPlacemarkArray:placemarks];
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

- (void)createPlacemarkArray:(NSArray *)placemarks;
{
    if (!self.dictionary)
        self.dictionary = [[NSMutableDictionary alloc] init];
    
    if (!self.array)
        self.array = [[NSMutableArray alloc] init];
    
    for (CLLocation *element in placemarks) {
        
        NSArray *firstParse = [[NSArray alloc] initWithArray:[[element description] componentsSeparatedByString:@"@"]];
        NSArray *secondParse = [[NSArray alloc] initWithArray:[[firstParse objectAtIndex:0] componentsSeparatedByString:@","]];
        
        // create dictionary
        [self.dictionary setObject:element forKey:[secondParse objectAtIndex:0]];
        
        // create button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:[secondParse objectAtIndex:0] forState:UIControlStateNormal];
        [button sizeToFit];
        
        // add button to array
        [self.array addObject:button];
    }
    
    // send to mapView
//    [self.mapView showSearchResultsForArray:self. withDicionary:dictionary];
}

@end
