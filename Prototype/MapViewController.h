//
//  MapViewController.h
//  Prototype
//
//  Created by Matthew Liu on 6/10/13.
//  Copyright (c) 2013 Matthew Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>


@interface MapViewController : UIViewController
{
    GMSMapView *mapView;
}

- (IBAction)changeMapType:(id)sender;


@end
