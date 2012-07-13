//
//  HTSGeoSampleManager.m
//  HTSiOS
//
//  Created by Justin Marrington on 22/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSGeoSampleManager.h"
#import "GeoSample.h"
#import "Trip.h"

@interface HTSGeoSampleManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation HTSGeoSampleManager
@synthesize locationManager;
@synthesize activeTrip;
@synthesize isLiveTracking;
@synthesize delegate;

+ (GeoSample *)sampleForLocation:(CLLocation *)aLocation onTrip:(Trip *)aTrip
{
    GeoSample *sample = [GeoSample createEntity];
    [sample setLatitudeValue:aLocation.coordinate.latitude];
    [sample setLongitudeValue:aLocation.coordinate.longitude];
    [sample setTimestamp:aLocation.timestamp];
    [sample setLocationAccuracyValue:aLocation.horizontalAccuracy];
    if (aLocation.course >= 0) {
        [sample setHeadingValue:aLocation.course];
    }
    [sample setSpeedValue:aLocation.speed];
    [sample setTrip:aTrip];
    
    return sample;
}

+ (void)createSampleForLocation:(CLLocation *)aLocation onTrip:(Trip *)aTrip;
{
    [HTSGeoSampleManager sampleForLocation:aLocation onTrip:aTrip];
    [[NSManagedObjectContext defaultContext] save];
}

+ (void)createSamplesForLocations:(NSArray *)locations onTrip:(Trip *)aTrip;
{
    for (CLLocation *loc in locations) {
        [HTSGeoSampleManager sampleForLocation:loc onTrip:aTrip];
    }
    
    [[NSManagedObjectContext defaultContext] save];
}

+ (HTSGeoSampleManager *)sharedManager
{
    static HTSGeoSampleManager *instance;
    if (!instance) {
        instance = [[HTSGeoSampleManager alloc] init];
        instance.locationManager = [[CLLocationManager alloc] init];
        [instance.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//        [instance.locationManager setDistanceFilter:10.0];
        [instance.locationManager setDelegate:instance];
        instance.isLiveTracking = NO;
    }
    
    return instance;
}

#pragma mark instance methods
- (void)startCapturingSamples
{
    if (activeTrip) {
        [self.locationManager stopMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
        if ([CLLocationManager headingAvailable]) {
            [self.locationManager startUpdatingHeading];
        }
        self.isLiveTracking = YES;
    } else {
        NSLog(@"No active trip. Can't start capturing samples.");
    }
}

- (void)stopCapturingSamples
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
    [self.locationManager startMonitoringSignificantLocationChanges];
    self.isLiveTracking = NO;
}

- (void)monitorForSignificantLocationChanges
{
    [self.locationManager startMonitoringSignificantLocationChanges];
    self.isLiveTracking = NO;
}

- (void)askUserToStartTracking
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif) {
        localNotif.alertBody = @"Start tracking this trip in ATLAS?";
        localNotif.alertAction = @"Start tracking";
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    }
}

#pragma mark - CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > 55.0) return;
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    if (self.isLiveTracking) {
        // And update the trip's distance
        CLLocationDistance dist = [newLocation distanceFromLocation:oldLocation];
        self.activeTrip.distanceValue = self.activeTrip.distanceValue + dist;
        
        // Otherwise, create and save a GeoSample
        [HTSGeoSampleManager createSampleForLocation:newLocation onTrip:self.activeTrip];
        [self.delegate geosampleManager:self didCaptureSampleAtLocation:newLocation];
    } else {
        [self askUserToStartTracking];
    }
    
}

@end
