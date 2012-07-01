//
//  HTSTripMapViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 22/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSTripMapViewController.h"
#import "Trip.h"
#import "GeoSample.h"
#import "HTSTripPath.h"
#import "HTSTripPathView.h"

@interface HTSTripMapViewController ()

@property (nonatomic, strong) HTSTripPath *tripPath;
@property (nonatomic, strong) HTSTripPathView *tripPathView;

@end

@implementation HTSTripMapViewController
@synthesize mapView;
@synthesize tripActive = _tripActive;
@synthesize tripPath;
@synthesize tripPathView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // When the view is about to become active, set us as the delegate for the sample manager
    // so that we can update ourself based on location updates.
    [[HTSGeoSampleManager sharedManager] setDelegate:self];
    [self.mapView setDelegate:self];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark MKMapViewDelegate methods
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay class] == [HTSTripPath class]) {
        if (!self.tripPathView) {
            self.tripPathView = [[HTSTripPathView alloc] initWithOverlay:overlay];
        }
        return self.tripPathView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    // If the trip is historical, adding an overlay means the whole thing has just been drawn.
    // So in this case centre the map to display the whole overlay
    if (!self.tripActive) {
        [self centreMapOnTripOverlay];
    }
}

#pragma mark Trip mapping and tracking methods
- (void)plotTrip:(Trip *)aTrip
{
    NSSet *samples = [aTrip samples];
    int numSamples = [samples count];
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * numSamples);
    int i = 0;
    for (GeoSample *sample in samples) {
        coords[i] = CLLocationCoordinate2DMake(sample.latitudeValue, sample.longitudeValue);
        i++;
    }
    MKPolyline *poly = [MKPolyline polylineWithCoordinates:coords count:numSamples];
    [self.mapView addOverlay:poly];
    
    free(coords);
}

- (void)clearPlot
{
    [self.mapView removeOverlays:self.mapView.overlays];
    self.tripPath = nil;
}

- (void)centreMapOnTripOverlay
{
    MKMapRect mapRect = [[self.tripPathView overlay] boundingMapRect];
    [self.mapView setVisibleMapRect:mapRect edgePadding:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0) animated:YES];
}

#pragma mark HTSGeoSampleManager delegate methods
- (void)geosampleManager:(HTSGeoSampleManager *)manager didCaptureSampleAtLocation:(CLLocation *)aLocation
{
    if (!tripPath) {
        tripPath = [[HTSTripPath alloc] initWithCenterCoordinate:aLocation.coordinate];
        [self.mapView addOverlay:tripPath];
        
        // On the first location update, zoom to the user location
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(aLocation.coordinate, 2000, 2000);
        [self.mapView setRegion:region animated:YES];
    } else {
        MKMapRect updateRect = [tripPath addCoordinate:aLocation.coordinate];
        
        if (!MKMapRectIsNull(updateRect)) {
            // There is a non-null Map update rect
            // Compute the currently visible map scale
            MKZoomScale currentScale = (CGFloat)(self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width);
            // Find out the line width at this zoom scale and outset the updateRect by that amount.
            CGFloat lineWidth = MKRoadWidthAtZoomScale(currentScale);
            updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
            
            // Ask the overlay view to update just the changed area
            [self.tripPathView setNeedsDisplayInMapRect:updateRect];
        }
    }
}

- (void)geoSampleManager:(HTSGeoSampleManager *)manager didStopCapturingWithError:(NSError *)error
{
    
}

- (void)setTripActive:(BOOL)tripActive
{
    if (tripActive) {
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    } else {
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
        [self.mapView setShowsUserLocation:NO];
    }
    _tripActive = tripActive;
}

@end
