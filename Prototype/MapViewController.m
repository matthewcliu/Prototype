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
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentCoordinate.latitude longitude:currentCoordinate.longitude zoom:6];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [mapView setMyLocationEnabled:YES];
    [[mapView settings] setMyLocationButton:YES];
    [[mapView settings] setCompassButton:YES ];
    self.view = mapView;
    
    //Creates a marker in the center of the map
    GMSMarker *marker = [[GMSMarker alloc] init];
    [marker setPosition:CLLocationCoordinate2DMake(-33.86, 151.20)];
    [marker setTitle:@"Sydney"];
    [marker setSnippet:@"Australia"];
    [marker setMap:mapView];
    
    
    //Create UISegmentedControl
    NSArray *mapTypes= [NSArray arrayWithObjects:@"Standard", @"Satellite", @"Hybrid", @"Terrain", nil];
    UISegmentedControl *mapTypeControl = [[UISegmentedControl alloc] initWithItems:mapTypes];
    
    //Style segmented control
    [mapTypeControl setSegmentedControlStyle:UISegmentedControlStylePlain];
    
    //Manually set - need to refactor for different screen sizes
    [mapTypeControl setFrame:CGRectMake(10, 460, 240, 30)];
    UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [mapTypeControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    //Attach IBAction
    [mapTypeControl addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventValueChanged];
    
    //Add mapTypeControl to main view
    [mapView addSubview:mapTypeControl];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeMapType:(id)sender
{
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //NSLog(@"%@", locations);
    userLocation = [locations lastObject];
    
    NSLog(@"User is currently at: %@", userLocation);
    //How many seconds ago was this new location created?
    NSTimeInterval t = [[userLocation timestamp] timeIntervalSinceNow];
    if(t < -180) {
        return;
    }

}

@end
