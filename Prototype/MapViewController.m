//
//  MapViewController.m
//  Prototype
//
//  Created by Matthew Liu on 6/10/13.
//  Copyright (c) 2013 Matthew Liu. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBar = [self tabBarItem];
        [tabBar setTitle:@"Google Maps"];
        
        //Start location manager to detect initial user location. Unsure if this is the most efficient way of doing this as Google probably already polls for the location
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager startUpdatingLocation];
    }
    return self;
}

- (void)loadView
{
    
    [super loadView];
    
    //Create map view with user location
    CLLocationCoordinate2D currentCoordinate = [userLocation coordinate];
    NSLog(@"The starting coordinate is: (%f, %f)", currentCoordinate.latitude, currentCoordinate.longitude);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentCoordinate.latitude longitude:currentCoordinate.longitude zoom:12];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [mapView setMyLocationEnabled:YES];
    [[mapView settings] setMyLocationButton:YES];
    [[mapView settings] setCompassButton:YES ];
    self.view = mapView;
    
    //Create UISegmentedControl
    NSArray *mapTypes= [NSArray arrayWithObjects:@"Standard", @"Satellite", @"Hybrid", @"Terrain", nil];
    UISegmentedControl *mapTypeControl = [[UISegmentedControl alloc] initWithItems:mapTypes];
    [mapTypeControl setSegmentedControlStyle:UISegmentedControlStylePlain];
    [mapTypeControl setFrame:CGRectZero];
    UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [mapTypeControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    //Attach IBAction
    [mapTypeControl addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventValueChanged];
    
    //Add UISegmentedControl to main view and set visual constraints
    [mapView addSubview:mapTypeControl];
    [mapTypeControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[mapTypeControl]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mapTypeControl)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[mapTypeControl]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mapTypeControl)]];
    
    //Create UIToolBar to add Places filter buttons
    UIToolbar *placesTypes = [[UIToolbar alloc] initWithFrame:CGRectZero];
    
    //Create UIBarButtons including flexible space to center buttons
    UIBarButtonItem *restaurantsBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Restaurants" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarButtonPress:)];
    UIBarButtonItem *gasStationsBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Gas Stations" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarButtonPress:)];
    UIBarButtonItem *barsAndClubsBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Shopping Mall" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarButtonPress:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *barButtonArray = [NSArray arrayWithObjects: flexibleSpace, restaurantsBarButton, gasStationsBarButton, barsAndClubsBarButton, flexibleSpace, nil];
    
    //Add bar buttons to toolbar
    [placesTypes setItems:barButtonArray animated:YES];
    
    //Add placesType to main view and set visual constraints
    [mapView addSubview:placesTypes];
    [placesTypes setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[placesTypes]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(placesTypes)]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[placesTypes]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(placesTypes)]];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    userLocation = [locations lastObject];    
}

//UISegmentedControl action for changing Google Maps type
- (IBAction)changeMapType:(id)sender
{
    //Grab a GMSMapView type pointer to the map
    GMSMapView *currentMap = (GMSMapView *)[self view];
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
        {
            [currentMap setMapType:kGMSTypeNormal];
            break;
        }
        case 1:
        {
            [currentMap setMapType:kGMSTypeSatellite];
            break;
        }
        case 2:
        {
            [currentMap setMapType:kGMSTypeHybrid];
            break;
        }
        case 3:
        {
            [currentMap setMapType:kGMSTypeTerrain];
            break;
        }
    }
    
}

//Bar Button Methods for call requests to Google Places API
- (IBAction)toolBarButtonPress:(id)sender
{
    //Grab a pointer to the bar button that was pressed
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    
    NSString *buttonTitle = [button.title lowercaseString];
    NSLog(@"This button was pressed: %@", buttonTitle);
    
    if ([buttonTitle isEqual: @"restaurants"]) {
        [self fetchFromGooglePlaces:@"restaurant"];
    } else if ([buttonTitle isEqual:@"gas stations"]) {
        [self fetchFromGooglePlaces:@"gas_station"];
    } else if([buttonTitle isEqual:@"shopping mall"]) {
        [self fetchFromGooglePlaces:@"shopping_mall"];
    }
}

- (void)fetchFromGooglePlaces:(NSString *)googleType
{
    //Build the URL to send to Google
    CLLocationCoordinate2D currentCoordinate = [userLocation coordinate];
    
    //This is hacky - shoudl really base this on the zoom level - refactor later
    int currentRadius = 5000;
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", currentCoordinate.latitude, currentCoordinate.longitude, [NSString stringWithFormat:@"%i", currentRadius], googleType, kGOOGLE_PLACES_API_KEY];
    NSURL *googleRequestURL = [NSURL URLWithString:url];
    
    //Asynchronous call in separate thread to parse JSON
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(parseGooglePlacesJson:) withObject:data waitUntilDone:YES];
    });
}

- (void)parseGooglePlacesJson:(NSData *)responseData
{
    NSError *error;
    NSDictionary *placesData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    //The results will be an array obtained from the NSDictionary object with the key "results". This is done through visual inspection.
    if (placesData) {
        NSArray *places = [placesData objectForKey:@"results"];
        [self plotMapMarkers:places];
    } else {
        //Our JSON deserialization went awry
        NSLog(@"JSON Error: %@", [error localizedDescription]);
    }
}

- (void)plotMapMarkers:(NSArray *)returnedPlaces
{
    //Remove previous map markers
    [mapView clear];
    
    //Plot markers for selected Places type
    for (int i =0; i< [returnedPlaces count]; i++) {
        
        //Traverse the JSON object tree
        NSDictionary *place = [returnedPlaces objectAtIndex:i];
        NSDictionary *geometry = [place objectForKey:@"geometry"];
        NSDictionary *location = [geometry objectForKey:@"location"];
        double latitude = [[location objectForKey:@"lat"] doubleValue];
        double longitude = [[location objectForKey:@"lng"] doubleValue];
        NSString *name = [place objectForKey:@"name"];
        
        //Create a marker
        GMSMarker *marker = [[GMSMarker alloc] init];
        [marker setPosition:CLLocationCoordinate2DMake(latitude, longitude)];
        [marker setTitle:name];
        [marker setAnimated:YES];
        [marker setMap:mapView];
    }
}

@end
