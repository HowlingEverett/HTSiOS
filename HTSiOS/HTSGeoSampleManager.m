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

@implementation HTSGeoSampleManager

+ (GeoSample *)sampleForLocation:(CLLocation *)aLocation onTrip:(Trip *)aTrip
{
    GeoSample *sample = [GeoSample MR_createEntity];
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
    [[NSManagedObjectContext MR_defaultContext] MR_save];
}

+ (void)createSamplesForLocations:(NSArray *)locations onTrip:(Trip *)aTrip;
{
    for (CLLocation *loc in locations) {
        [HTSGeoSampleManager sampleForLocation:loc onTrip:aTrip];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_save];
}

@end
