//
//  HTSGeoSampleManager.h
//  HTSiOS
//
//  Created by Justin Marrington on 22/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class Trip, GeoSample;
@interface HTSGeoSampleManager : NSObject

/**
 * Creates and saves a GeoSample for this location, using all the available information for
 *
 */
+ (void)createSampleForLocation:(CLLocation *)aLocation onTrip:(Trip *)aTrip;
+ (GeoSample *)sampleForLocation:(CLLocation *)aLocation onTrip:(Trip *)aTrip;
+ (void)createSamplesForLocations:(NSArray *)locations onTrip:(Trip *)aTrip;

@end
