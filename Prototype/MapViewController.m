//
//  MapViewController.m
//  Prototype
//
//  Created by Matthew Liu on 6/10/13.
//  Copyright (c) 2013 Matthew Liu. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>


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
    }
    return self;
}

- (void)loadView
{
    
    [super loadView];
    //Create default map view
    
    GMSMapView *mapView = [[GMSMapView alloc] init];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
    
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

@end
