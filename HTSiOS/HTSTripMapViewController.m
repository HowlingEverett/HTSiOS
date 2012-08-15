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
@property (nonatomic, strong) MKPolylineView *existingPath;

@end

@implementation HTSTripMapViewController
@synthesize mapView;
@synthesize tripActive = _tripActive;
@synthesize tripPath;
@synthesize tripPathView, existingPath;

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[HTSGeoSampleManager sharedManager] setDelegate:nil];
    [self.mapView setDelegate:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark MKMapViewDelegate methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation class] == [MKPointAnnotation class]) {
        static NSString *pinIdentifier = @"Pin View Identifier";
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
        }
        [pinView setCanShowCallout:YES];
        
        if ([[annotation title] isEqualToString:@"Origin"]) {
            [pinView setPinColor:MKPinAnnotationColorGreen];
        } else if ([[annotation title] isEqualToString:@"Destination"]) {
            [pinView setPinColor:MKPinAnnotationColorRed];
        }
        
        return pinView;
    }
    
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay class] == [HTSTripPath class]) {
        if (!self.tripPathView) {
            self.tripPathView = [[HTSTripPathView alloc] initWithOverlay:overlay];
        }
        return self.tripPathView;
    } else if ([overlay class] == [MKPolyline class]) {
        if (!self.existingPath) {
            self.existingPath = [[MKPolylineView alloc] initWithPolyline:overlay];
            [self.existingPath setStrokeColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.5f]];
            [self.existingPath setLineJoin:kCGLineJoinRound];
            [self.existingPath setLineCap:kCGLineCapRound];

        }
        return self.existingPath;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{

}

#pragma mark Trip mapping and tracking methods
- (void)plotTrip:(Trip *)aTrip
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    NSArray *samples = [[aTrip samples] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    int numSamples = [samples count];
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * numSamples);
    int i = 0;
    for (GeoSample *sample in samples) {
        coords[i] = CLLocationCoordinate2DMake(sample.latitudeValue, sample.longitudeValue);
        i++;
    }
    MKPolyline *poly = [MKPolyline polylineWithCoordinates:coords count:numSamples];
    [self.mapView addOverlay:poly];
    
    MKPointAnnotation *origin = [[MKPointAnnotation alloc] init];
    origin.coordinate = coords[0];
    [origin setTitle:@"Origin"];
    [self.mapView addAnnotation:origin];
    
    free(coords);
}

- (void)clearPlot
{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.tripPath = nil;
}

- (void)centreMapOnTripOverlay
{
    MKMapRect mapRect = [[self.existingPath overlay] boundingMapRect];
    [self.mapView setVisibleMapRect:mapRect edgePadding:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0) animated:YES];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *annotationView in views) {
        if ([annotationView.annotation isEqual:self.mapView.userLocation]) {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            
            span.latitudeDelta=0.03;
            span.longitudeDelta=0.03;
            
            CLLocationCoordinate2D location=self.mapView.userLocation.coordinate;
            
            region.span=span;
            region.center=location;
            
            [self.mapView setRegion:region animated:TRUE];
            [self.mapView regionThatFits:region];
        }
    }
}

#pragma mark HTSGeoSampleManager delegate methods
- (void)geosampleManager:(HTSGeoSampleManager *)manager didCaptureSampleAtLocation:(CLLocation *)aLocation
{
    if (!tripPath) {
        tripPath = [[HTSTripPath alloc] initWithCenterCoordinate:aLocation.coordinate];
        [self.mapView addOverlay:tripPath];
        MKPointAnnotation *origin = [[MKPointAnnotation alloc] init];
        origin.coordinate = aLocation.coordinate;
        [origin setTitle:@"Origin"];
        [self.mapView addAnnotation:origin];
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
