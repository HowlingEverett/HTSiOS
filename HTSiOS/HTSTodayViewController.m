//
//  HTSTodayViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 20/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSTodayViewController.h"
#import "Trip.h"
#import "GeoSample.h"
#import "TransportMode.h"
#import "HTSTripDetailViewController.h"
#import "HTSTripMapViewController.h"
#import "HTSGeoSampleManager.h"
#import "HTSAPIController.h"

@interface HTSTodayViewController ()

// Data objects
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDictionary *transportDescriptions;
@property (nonatomic, assign) BOOL loggingEnabled;
@property (nonatomic, strong) Trip *activeTrip;

// Outlets
@property (weak, nonatomic) IBOutlet UIView *tripMapView;
@property (weak, nonatomic) IBOutlet UILabel *tripNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

// Actions
- (IBAction)startStop:(id)sender;
- (IBAction)openCurrentTrip:(id)sender;

// Child View Controllers
@property (nonatomic, strong) HTSTripMapViewController *tripMapViewController;
@end

@implementation HTSTodayViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize tripMapView = _tripMapView;
@synthesize tripNameLabel = _tripNameLabel;
@synthesize startStopButton = _startStopButton;
@synthesize activeTrip = _activeTrip;
@synthesize transportDescriptions;
@synthesize loggingEnabled;
@synthesize tripMapViewController;

- (void)awakeFromNib
{
    self.transportDescriptions = [NSDictionary dictionaryWithObjectsAndKeys:@"by car", @"C", @"on foot", @"P", @"cycling", @"Cy", @"on public transport", @"PT", @"by taxi", @"T", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = [self editButtonItem];
    
    // Add and configure child view controller for trip map
    [self addTripMapSubviewController];
    
    // Tapping on current trip map should open full view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCurrentTrip:)];
    [self.tripMapView addGestureRecognizer:tap];
    
    // Check if login is required
    if (![[HTSAPIController sharedApi] hasCredentials]) {
        [self performSegueWithIdentifier:@"Show Login" sender:self];
    } else {
        [[HTSAPIController sharedApi] loginWithLocalCredentialsWithFailureBlock:^{
            [self performSegueWithIdentifier:@"Show Login" sender:self];
        }];
    }
}

- (void)addTripMapSubviewController
{
    self.tripMapViewController = [[HTSTripMapViewController alloc] initWithNibName:@"HTSTripMapViewController" bundle:nil];
    self.tripMapViewController.view.frame = self.tripMapView.bounds;
    [self.tripMapViewController.view setClipsToBounds:YES];
    [self.tripMapView addSubview:self.tripMapViewController.view];
    [self.tripMapViewController didMoveToParentViewController:self];
    [self.tripMapViewController.mapView setZoomEnabled:NO];
    [self.tripMapViewController.mapView setScrollEnabled:NO];
    [self addChildViewController:self.tripMapViewController];
}

- (void)viewDidUnload
{
    [self setTripNameLabel:nil];
    [self setStartStopButton:nil];
    [self setTripMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"View Current Trip"]) {
        HTSTripDetailViewController *detailViewController = (HTSTripDetailViewController *)detailViewController;
        [detailViewController setTrip:self.activeTrip];
        [detailViewController.tripMapViewController setTripActive:YES];
    } else if ([segue.identifier isEqualToString:@"View Historical Trip"]) {
        NSIndexPath *cellPath  = [self.tableView indexPathForCell:sender];
        Trip *trip = [self.fetchedResultsController objectAtIndexPath:cellPath];
        [[segue destinationViewController] setTrip:trip];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Trip Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Trip *trip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSDate *start = [trip.samplesSet valueForKeyPath:@"@min.timestamp"];
    NSDate *end = [trip.samplesSet valueForKeyPath:@"@max.timestamp"];
    NSTimeInterval length = [end timeIntervalSinceDate:start] / 60;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", trip.tripDescription];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@–%@: %d minute trip", [df stringFromDate:start], [df stringFromDate:end], (int)length];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        Trip *t = [self.fetchedResultsController objectAtIndexPath:indexPath];
        for (GeoSample *sample in t.samplesSet) {
            [context deleteObject:sample];
        }
        [context deleteObject:t];
        [context MR_save];
        [NSFetchedResultsController deleteCacheWithName:@"TripCache"];
        [self.fetchedResultsController performFetch:nil];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


#pragma mark Auto-intanstiating accessors

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        // Fetch all trips made today
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Trip"];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        [components setHour:0];
        [components setMinute:0];
        [components setSecond:0];
        NSDate *start = [cal dateFromComponents:components];
        [components setHour:23];
        [components setMinute:59];
        [components setSecond:59];
        NSDate *end = [cal dateFromComponents:components];
        NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", start, end];
        //[predicateTemplate predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:start, @"DATE_START", end, @"DATE_END", nil]];
        [fetch setPredicate:predicateTemplate];
        [fetch setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[NSManagedObjectContext MR_defaultContext]  sectionNameKeyPath:nil cacheName:@"TripCache"];
        [_fetchedResultsController performFetch:nil];
    }
    
    return _fetchedResultsController;
}

- (IBAction)startStop:(id)sender {
    HTSGeoSampleManager *geosampleManger = [HTSGeoSampleManager sharedManager];
    if (!self.loggingEnabled) {
        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self.startStopButton setBackgroundImage:[[UIImage imageNamed:@"buttonbackgroundred.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [[self.startStopButton titleLabel] setTextColor:[UIColor whiteColor]];
        
        if (self.activeTrip) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"You have an active trip. Would you like to record onto this trip or start a new one?" delegate:self cancelButtonTitle:@"Existing Trip" destructiveButtonTitle:@"New Trip" otherButtonTitles: nil];
            [sheet showInView:[[UIApplication sharedApplication] keyWindow]];
        } else {
            [self newTrip];
            self.tripNameLabel.text = self.activeTrip.tripDescription;
        }
        
        [geosampleManger setActiveTrip:self.activeTrip];
        [self.tripMapViewController setTripActive:YES];
        [geosampleManger setDelegate:self.tripMapViewController];
        [geosampleManger startCapturingSamples];
        
        NSLog(@"Started updating locations.");
    } else {
        [geosampleManger stopCapturingSamples];
        [geosampleManger setDelegate:nil];
        [self.tripMapViewController setTripActive:NO];
        
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.startStopButton setBackgroundImage:[[UIImage imageNamed:@"buttonbackgroundgreen.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [[self.startStopButton titleLabel] setTextColor:[UIColor whiteColor]];
        
        
        [self insertTripIntoHistory];
        
        NSLog(@"Stopped updating locations.");
        // Clear trip property so a new one gets created next start
    }
    
    self.loggingEnabled = !self.loggingEnabled;
}
- (IBAction)openCurrentTrip:(id)sender {
    [self performSegueWithIdentifier:@"View Current Trip" sender:sender];
}

- (void)newTrip
{
    self.activeTrip = [Trip MR_createEntity];
    self.activeTrip.date = [NSDate date];
    self.activeTrip.tripDescription = @"New trip";
    self.activeTrip.surveyIdValue = 1;
    TransportMode *tm = [TransportMode MR_createEntity];
    tm.mode = @"C";
    [self.activeTrip.modesSet addObject:tm];
    [[NSManagedObjectContext MR_defaultContext] MR_save];
}

- (void)insertTripIntoHistory
{
    [self.fetchedResultsController performFetch:nil];
    NSArray *indexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
    [self.tripNameLabel setText:@"— no trip —"];
    [self.tripMapViewController clearPlot];
}

#pragma mark UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self newTrip];
    }
    
    self.tripNameLabel.text = self.activeTrip.tripDescription;
}

@end
