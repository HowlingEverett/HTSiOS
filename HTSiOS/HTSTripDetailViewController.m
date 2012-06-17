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

@property (nonatomic, strong) HTSTripMapViewController *tripMapViewController;

// IBOutlets
@property (weak, nonatomic) IBOutlet UIView *tripMapView;
@end

@implementation HTSTripDetailViewController
@synthesize tripMapView;
@synthesize tripMapViewController;
@synthesize trip;

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addTripMapSubviewController];
    [[self tripMapViewController] plotTrip:self.trip];
}

- (void)viewDidUnload
{
    [self setTripMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
