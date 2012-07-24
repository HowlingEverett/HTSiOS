//
//  HTSTripMapViewController.h
//  HTSiOS
//
//  Created by Justin Marrington on 22/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "HTSGeoSampleManager.h"

@class Trip;
@interface HTSTripMapViewController : UIViewController <MKMapViewDelegate, HTSGeoSampleManagerDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) BOOL tripActive;

- (void)plotTrip:(Trip *)aTrip;
- (void)clearPlot;
- (void)centreMapOnTripOverlay;
@end
