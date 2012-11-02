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

@end

@implementation USCViewController

@synthesize locationManager = _locationManager;
@synthesize currentRegion = _currentRegion;

@synthesize mapView = _mapView;

@synthesize dictionary = _dictionary;

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
    if (textField.text) [self performGeocode:self withAddress:textField.text];

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

- (void)performGeocode:(id)sender withAddress:(NSString *)address;
{
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
        [self.mapView showSearchResultsForArray:placemarks];
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

// Function creates an array of buttons that contain placemark information
- (void)createPlacemarkArray:(NSArray *)placemarks;
{
    if (!self.dictionary)
        self.dictionary = [[NSMutableDictionary alloc] init];
    
    // fast enumeration that parses each placemark and places it into the array placemarks
    // SAMPLE PLACEMARK "University of Southern California, Los Angeles, CA  90007, United States @ <+34.02137294,-118.28668562> +/- 100.00m, region (identifier <+34.02208300,-118.28567550> radius 770.71) <+34.02208300,-118.28567550> radius 770.71m"
    
    // parse the placemark so the address is the key and the coordinate is the object
    for (CLLocation *element in placemarks) {
        
        // seperate 
        NSArray *firstParse = [[NSArray alloc] initWithArray:[[element description] componentsSeparatedByString:@"@"]];
        NSArray *secondParse = [[NSArray alloc] initWithArray:[[firstParse objectAtIndex:0] componentsSeparatedByString:@","]];
        
        // create dictionary
        [self.dictionary setObject:element forKey:[secondParse objectAtIndex:0]];
        
        // create button for the array
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:[secondParse objectAtIndex:0] forState:UIControlStateNormal]; //set the title of the button to the location 
        [button sizeToFit];
        
    }
    
    // send to mapView
    
}

@end
