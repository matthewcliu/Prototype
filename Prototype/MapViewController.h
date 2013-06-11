//
//  MapViewController.h
//  Prototype
//
//  Created by Matthew Liu on 6/10/13.
//  Copyright (c) 2013 Matthew Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

#define kGOOGLE_PLACES_API_KEY @"AIzaSyBaMoK7sjdLd41FcZf8zkkD_nE2d8ZmRw4"



//Ensure view controller conforms to CLLocationManagerDelegate
@interface MapViewController : UIViewController <CLLocationManagerDelegate>
{
    GMSMapView *mapView;
    CLLocationManager *locationManager;
    CLLocation *userLocation;
}

- (IBAction)changeMapType:(id)sender;

//Bar button action
- (IBAction)toolBarButtonPress:(id)sender;

- (void)fetchFromGooglePlaces:(NSString *)googleType;

- (void)parseGooglePlacesJson:(NSData *)responseData;

@end
