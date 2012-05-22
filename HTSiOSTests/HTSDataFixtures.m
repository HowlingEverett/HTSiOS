//
//  HTSDataFixtures.m
//  HTSiOS
//
//  Created by Justin Marrington on 21/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSDataFixtures.h"
#import "GeoSample.h"
#import "Trip.h"

@implementation HTSDataFixtures

+ (NSArray *)geoSamples
{
    GeoSample *sample1 = [GeoSample MR_createEntity];
    sample1.longitudeValue = 51.261921;
    sample1.latitudeValue = 30.236042;
    sample1.timestamp = [NSDate date];
    
    GeoSample *sample2 = [GeoSample MR_createEntity];
    sample2.longitudeValue = 51.261926;
    sample2.latitudeValue = 30.236043;
    sample2.timestamp = [[NSDate date] dateByAddingTimeInterval:60];
    
    GeoSample *sample3 = [GeoSample MR_createEntity];
    sample1.longitudeValue = 51.261926;
    sample1.latitudeValue = 30.236045;
    sample1.timestamp = [[NSDate date] dateByAddingTimeInterval:120];
    
    return [NSArray arrayWithObjects:sample1, sample2, sample3, nil];
}

+ (Trip *)tripWithSamples:(NSArray *)samples
{
    Trip *trip = [Trip MR_createEntity];
    trip.date = [NSDate date];
    trip.tripDescription = @"Off to work!";
    trip.transportType = @"C";
    [trip addSamples:[NSSet setWithArray:samples]];
    
    return trip;
}

@end
