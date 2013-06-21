//
//  AppDelegate.m
//  Prototype
//
//  Created by Matthew Liu on 6/10/13.
//  Copyright (c) 2013 Matthew Liu. All rights reserved.
//

#import "AppDelegate.h"

#import "TwitterViewController.h"

#import <GoogleMaps/GoogleMaps.h>
#import "MapViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //Create Facebook auth view
    UIViewController *facebookController = [[UIViewController alloc] init];
    [[facebookController view] setBackgroundColor:[UIColor clearColor]];
    
    //Create Twitter post view
    TwitterViewController *twitterController = [[TwitterViewController alloc] init];
    [[twitterController view] setBackgroundColor:[UIColor clearColor]];
    
    //Create map view
    [GMSServices provideAPIKey:kGOOGLE_IOS_API_KEY];
    MapViewController *mapController = [[MapViewController alloc] init];
    
    //Create and load UITabBarController
    UITabBarController *mainController = [[UITabBarController alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:facebookController, twitterController, mapController, nil];
    [mainController setViewControllers:viewControllers];
    [self.window setRootViewController:mainController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
