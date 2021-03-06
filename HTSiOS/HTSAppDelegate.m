//
//  HTSAppDelegate.m
//  HTSiOS
//
//  Created by Justin Marrington on 17/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSAppDelegate.h"
#import "HTSGeoSampleManager.h"
#import "HTSTodayViewController.h"

@implementation HTSAppDelegate

@synthesize window = _window;

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set up testflight
    [TestFlight takeOff:@"c0bef500bc85976253479df0c319add5_MTAyNzc1MjAxMi0wNi0yMSAyMjo1NzoxMS44NTE0MDg"];
#define TESTING 1
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    
    [MagicalRecord setupCoreDataStack];
    
    // If we're coming up for location events, restart significant location changes
    
//    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
//        [[[HTSGeoSampleManager sharedManager] locationManager] startMonitoringSignificantLocationChanges];
//    }
    
    // Handle launching from a user tapping the local notification
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        HTSTodayViewController *today = (HTSTodayViewController *)[[(UITabBarController *)[self.window rootViewController] viewControllers] objectAtIndex:0];
        
        if ([localNotif.alertAction isEqualToString:@"Start Tracking"]) {
            [today newTrip:today];
        } else if ([localNotif.alertAction isEqualToString:@"Stop Tracking"]) {
            [today stopUpdates:today];
        }
    }
    
    [self configureAppearance];
    
    // Set ourselves up with default notification styles
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
    
    return YES;
}

- (void)configureAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.6 green:0.4 blue:0.2 alpha:1.0]];
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithRed:1.0 green:0.9921568627450981 blue:0.9764705882352941 alpha:1.0]];
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
    if (![[HTSGeoSampleManager sharedManager] isLiveTracking]) {
        [[[HTSGeoSampleManager sharedManager] locationManager] startMonitoringSignificantLocationChanges];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}

@end
