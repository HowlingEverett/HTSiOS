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
@protocol HTSGeoSampleManagerDelegate;

@interface HTSGeoSampleManager : NSObject <CLLocationManagerDelegate>
@property (nonatomic, strong) Trip *activeTrip;
@property (nonatomic, assign) id<HTSGeoSampleManagerDelegate> delegate;

@property (nonatomic, assign) BOOL isLiveTracking;
/**
 *  Singleton instance of this manager. Encapsulates location updates for the application into geosamples,
 *  which are wrapped CLLocations that filter bad updates and have persistance.
 */
+ (HTSGeoSampleManager *)sharedManager;

- (void)startCapturingSamples;
- (void)stopCapturingSamples;
- (void)monitorForSignificantLocationChanges;
- (void)askUserToStartTracking;

/** Static methods for creating samples directly. Normally, you'll just use startCapturingSamples */
/**
 * Creates and saves a GeoSample for this location, using all the available information for
 *
 */
+ (void)createSampleForLocation:(CLLocation *)aLocation onTrip:(Trip *)aTrip;
+ (GeoSample *)sampleForLocation:(CLLocation *)aLocation onTrip:(Trip *)aTrip;
+ (void)createSamplesForLocations:(NSArray *)locations onTrip:(Trip *)aTrip;

@end

@protocol HTSGeoSampleManagerDelegate

- (void)geosampleManager:(HTSGeoSampleManager *)manager didCaptureSampleAtLocation:(CLLocation *)aLocation;

@optional
- (void)geoSampleManager:(HTSGeoSampleManager *)manager didStopCapturingWithError:(NSError *)error;

@end