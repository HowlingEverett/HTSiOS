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

@interface HTSTripMapViewController ()

@property (nonatomic, strong) MKPolylineView *tripOverlayView;
@end

@implementation HTSTripMapViewController
@synthesize mapView;
@synthesize tripOverlayView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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

- (void)centreMapOnTripOverlay
{
    MKMapRect mapRect = [[self.tripOverlayView overlay] boundingMapRect];
    [self.mapView setVisibleMapRect:mapRect edgePadding:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0) animated:YES];
}

#pragma mark MKMapViewDelegate methods
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay class] == [MKPolyline class]) {
        if (!self.tripOverlayView) {
            self.tripOverlayView = [[MKPolylineView alloc] initWithPolyline:overlay];
            [self.tripOverlayView setLineWidth:3.0];
            [self.tripOverlayView setStrokeColor:[UIColor purpleColor]];
            return self.tripOverlayView;
        } else {
            [self.tripOverlayView invalidatePath];
        }
    }
    
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    [self centreMapOnTripOverlay];
}

@end
