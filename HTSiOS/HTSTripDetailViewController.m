//
//  HTSTripDetailViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 25/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSTripDetailViewController.h"
#import "HTSTripMapViewController.h"
#import "Trip.h"
#import "GeoSample.h"

@interface HTSTripDetailViewController ()

// IBOutlets
@property (weak, nonatomic) IBOutlet UIView *tripMapView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end

@implementation HTSTripDetailViewController
@synthesize tripMapView;
@synthesize distanceLabel;
@synthesize durationLabel;
@synthesize tripMapViewController;
@synthesize trip = _trip, tripActive;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)addTripMapSubviewController
{
    self.tripMapViewController = [[HTSTripMapViewController alloc] initWithNibName:@"HTSTripMapViewController" bundle:nil];
    self.tripMapViewController.view.frame = self.tripMapView.bounds;
    [self.tripMapViewController.view setClipsToBounds:YES];
    [self.tripMapView addSubview:self.tripMapViewController.view];
    [self.tripMapViewController didMoveToParentViewController:self];
    [self addChildViewController:self.tripMapViewController];
    
    if (self.trip) {
        [self.tripMapViewController plotTrip:self.trip];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDate *startDate = [self.trip date];
        NSDate *endDate = [startDate dateByAddingTimeInterval:(self.trip.durationValue * 60.0)];
        NSDateComponents *conversion = [cal components:unitFlags fromDate:startDate toDate:endDate options:0];
        [self.durationLabel setText:[NSString stringWithFormat:@"%2dh%2dm%2ds", [conversion hour], [conversion minute], [conversion second]]];
        [self.distanceLabel setText:[NSString stringWithFormat:@"%.2lfkm", (self.trip.distanceValue / 1000.0)]];
        [self.tripMapViewController centreMapOnTripOverlay];
    }
    
    if (self.tripActive) {
        [self.tripMapViewController setTripActive:YES];
    }
}

- (void)awakeFromNib
{
//    [self addTripMapSubviewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addTripMapSubviewController];
}

- (void)viewDidUnload
{
    [self setTripMapView:nil];
    [self setDistanceLabel:nil];
    [self setDurationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
