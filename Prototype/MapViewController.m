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
    
    /*
    //Creates a marker in the center of the map
    GMSMarker *marker = [[GMSMarker alloc] init];
    [marker setPosition:CLLocationCoordinate2DMake(-33.86, 151.20)];
    [marker setTitle:@"Sydney"];
    [marker setSnippet:@"Australia"];
    [marker setMap:mapView];
    */
    
    
    //Create UISegmentedControl
    NSArray *mapTypes= [NSArray arrayWithObjects:@"Standard", @"Satellite", @"Hybrid", @"Terrain", nil];
    UISegmentedControl *mapTypeControl = [[UISegmentedControl alloc] initWithItems:mapTypes];
    [mapTypeControl setSegmentedControlStyle:UISegmentedControlStylePlain];
    
    //Manually set frame - need to refactor for different screen sizes
    [mapTypeControl setFrame:CGRectMake(10, 460, 240, 30)];
    UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [mapTypeControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    //Attach IBAction
    [mapTypeControl addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventValueChanged];
    //Add mapTypeControl to main view
    [mapView addSubview:mapTypeControl];
    
    
    //Create UIToolBar to add Places filters
    UIToolbar *placesTypes = [[UIToolbar alloc] init];
    
    //Manually set frame - need to refactor for different screen sizes
    [placesTypes setFrame:CGRectMake(0, 0, 320, 50)];
    
    //Create UIBarButtons
    UIBarButtonItem *restaurantsBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Restaurants" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarButtonPress:)];
    UIBarButtonItem *gasStationsBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Gas Stations" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarButtonPress:)];
    UIBarButtonItem *barsAndClubsBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Bars & Clubs" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarButtonPress:)];
    
    NSArray *barButtonArray = [NSArray arrayWithObjects:restaurantsBarButton, gasStationsBarButton, barsAndClubsBarButton, nil];
    
    //Add bar buttons to toolbar
    [placesTypes setItems:barButtonArray animated:YES];
    
    //Add placesType to main view
    [mapView addSubview:placesTypes];
    
    
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

//Bar Button Methods for placing requests to Google Places API

- (IBAction)toolBarButtonPress:(id)sender
{
    //Grab a pointer to the bar button that was pressed
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    
    NSString *buttonTitle = [button.title lowercaseString];
    NSLog(@"This button was pressed: %@", buttonTitle);
}
@end
