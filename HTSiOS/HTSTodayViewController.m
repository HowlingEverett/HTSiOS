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

@interface HTSTodayViewController () <NSFetchedResultsControllerDelegate>

// Data objects
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDictionary *transportDescriptions;
@property (nonatomic, strong) Trip *activeTrip;

// Outlets
@property (weak, nonatomic) IBOutlet UIView *tripMapView;
@property (weak, nonatomic) IBOutlet UILabel *tripNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripModesLabel;

// Bar items
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) UIBarButtonItem *stopButton;
@property (nonatomic, strong) UIBarButtonItem *loginButton;

// Child View Controllers
@property (nonatomic, strong) HTSTripMapViewController *tripMapViewController;

@property (nonatomic, strong) NSTimer *tripDurationTimer;
@end

@implementation HTSTodayViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize tripMapView = _tripMapView;
@synthesize tripNameLabel = _tripNameLabel;
@synthesize tripDistanceLabel;
@synthesize tripDurationLabel;
@synthesize tripModesLabel;
@synthesize activeTrip = _activeTrip;
@synthesize transportDescriptions;
@synthesize tripMapViewController;
@synthesize addButton, stopButton, loginButton;
@synthesize tripDurationTimer;

- (void)awakeFromNib
{
    self.transportDescriptions = [NSDictionary dictionaryWithObjectsAndKeys:@"own vehicle", @"C", @"walking", @"P", @"cycling", @"Cy", @"public transport", @"PT", @"taxi", @"T", nil];
    
    // Instantiate bar button items
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newTrip:)];
    self.stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(stopUpdates:)];
    self.loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Log in" style:UIBarButtonItemStyleBordered target:self action:@selector(showLogin:)];
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
        
    [self.navigationItem setRightBarButtonItem:self.addButton];
    
    // Check if login is required
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"HTSFirstRunKey"]) {
        // First time launch
        [self performSegueWithIdentifier:@"First Run" sender:self];
    } else {
        if (![[HTSAPIController sharedApi] hasCredentials]) {
            [self showLogin:self];
            
        } else {
            [[HTSAPIController sharedApi] loginWithLocalCredentialsWithSuccess:nil failure:^{
                [self showLogin:self];
            }];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggingCanceled:) name:@"HTSLiveLoggingStoppedNotification" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![[HTSAPIController sharedApi] hasCredentials]) {
        [self.navigationItem setLeftBarButtonItem:self.loginButton];
    } else {
        [self.navigationItem setLeftBarButtonItem:nil];
    }
    
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

- (void)addTripMapSubviewController
{
    self.tripMapViewController = [[HTSTripMapViewController alloc] initWithNibName:@"HTSTripMapViewController" bundle:nil];
    self.tripMapViewController.view.frame = self.tripMapView.bounds;
    [self.tripMapViewController.view setClipsToBounds:YES];
    [self.tripMapView addSubview:self.tripMapViewController.view];
    [self.tripMapViewController didMoveToParentViewController:self];
    [self.tripMapViewController.mapView setZoomEnabled:YES];
    [self.tripMapViewController.mapView setScrollEnabled:YES];
    [self addChildViewController:self.tripMapViewController];
}


- (void)viewDidUnload
{
    [self setTripNameLabel:nil];
    [self setTripMapView:nil];
    [self setTripDistanceLabel:nil];
    [self setTripDurationLabel:nil];
    [self setTripModesLabel:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HTSLiveLoggingStoppedNotification" object:nil];
    
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
        HTSTripDetailViewController *detailViewController = (HTSTripDetailViewController *)[segue destinationViewController];
        [detailViewController setTrip:self.activeTrip];
        [detailViewController setTripActive:YES];;
    } else if ([segue.identifier isEqualToString:@"View Historical Trip"]) {
        NSIndexPath *cellPath  = [self.tableView indexPathForCell:sender];
        Trip *trip = [self.fetchedResultsController objectAtIndexPath:cellPath];
        [[segue destinationViewController] setTrip:trip];
        [[[segue destinationViewController] navigationItem] setTitle:trip.tripDescription];
    } else if ([segue.identifier isEqualToString:@"New Trip"]) {
        NSLog(@"%@", [segue destinationViewController]);
        HTSNewTripViewController *dest = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        [dest setDelegate:self];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Previous trips today";
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
    
    NSString *modeStr = @"";
    for (TransportMode *tm in trip.modes) {
        modeStr = [modeStr stringByAppendingFormat:@"%@, ", [transportDescriptions objectForKey:tm.mode]];
    }
    modeStr = [modeStr substringToIndex:modeStr.length - 2];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", trip.tripDescription, modeStr];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    
    
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@–%@: %d minute trip.", [df stringFromDate:start], [df stringFromDate:end], (int)length];
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
        Trip *t = [self.fetchedResultsController objectAtIndexPath:indexPath];
        for (GeoSample *sample in t.samplesSet) {
            [context deleteObject:sample];
        }
        [context deleteObject:t];
        [context save];
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
        [components setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *start = [cal dateFromComponents:components];
        [components setHour:23];
        [components setMinute:59];
        [components setSecond:59];
        [components setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *end = [cal dateFromComponents:components];
        NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (isActive == NO)", start, end];
        [fetch setPredicate:predicateTemplate];
        [fetch setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[NSManagedObjectContext defaultContext]  sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        [_fetchedResultsController performFetch:nil];
    }
    
    return _fetchedResultsController;
}

#pragma mark Actions
- (void)showLogin:(id)sender {
    [self performSegueWithIdentifier:@"Show Login" sender:self];
}

- (IBAction)openCurrentTrip:(id)sender {
    [self performSegueWithIdentifier:@"View Current Trip" sender:sender];
}

- (void)insertTripIntoHistory
{
//    NSArray *indexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.activeTrip.isActiveValue = NO;
    if (self.activeTrip.samples.count < 2) {
        [self.activeTrip deleteEntity];
        UIAlertView *noTripAlert = [[UIAlertView alloc] initWithTitle:@"Trip not saved" message:@"This trip didn't have enough samples to record in the survey." delegate:self cancelButtonTitle:@"Whoops" otherButtonTitles:nil];
        [noTripAlert show];
    }
    [[NSManagedObjectContext contextForCurrentThread] save];
    
    
    self.activeTrip = nil;
    [self.tripMapViewController clearPlot];
    [self.tripMapViewController setTripActive:NO];
    
    [self.tripNameLabel setText:@"— no trip —"];
    [self.tripModesLabel setText:@"— —"];
    [self.tripDurationLabel setText:@""];
    [self.tripDistanceLabel setText:@""];
}

# pragma mark HTSNewTripViewController delegate methods
- (void)didCreateNewTrip:(Trip *)trip
{
    [self setActiveTrip:trip];
    [self.tripNameLabel setText:trip.tripDescription];
    NSString *modeStr = @"";
    for (TransportMode *tm in trip.modes) {
        modeStr = [modeStr stringByAppendingFormat:@"%@, ", [transportDescriptions objectForKey:tm.mode]];
    }
    modeStr = [modeStr substringToIndex:modeStr.length - 2];
    [self.tripModesLabel setText:modeStr];
    [self.tripDistanceLabel setText:@"0km 0m"];
    [self.tripDurationLabel setText:@"00h00m00s"];
    
    HTSGeoSampleManager *geosampleManger = [HTSGeoSampleManager sharedManager];
    [geosampleManger setActiveTrip:self.activeTrip];
    [self.tripMapViewController clearPlot];
    
    [self.tripMapViewController setTripActive:YES];
    [geosampleManger setDelegate:self.tripMapViewController];
    [geosampleManger startCapturingSamples];
    self.tripDurationTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.tripDurationTimer forMode:NSDefaultRunLoopMode];
    
    [self.navigationItem setRightBarButtonItem:self.stopButton];
}

#pragma mark Button Item methods
- (void)newTrip:(id)sel
{
    [self performSegueWithIdentifier:@"New Trip" sender:sel];
}

- (void)loggingCanceled:(NSNotification *)not
{
    [self stopUpdates:self];
}

- (void)stopUpdates:(id)sel
{
    HTSGeoSampleManager *geosampleManger = [HTSGeoSampleManager sharedManager];
    [geosampleManger stopCapturingSamples];
    [geosampleManger setDelegate:nil];
    [self.tripMapViewController setTripActive:NO];
    [self.tripDurationTimer invalidate];
    self.tripDurationTimer = nil;
    [self insertTripIntoHistory];
    
    [self.navigationItem setRightBarButtonItem:self.addButton];
}

# pragma mark Timer updates
- (void)updateCounter:(id)sel
{
    if (self.activeTrip) {
        NSDate *now = [NSDate date];
        NSDate *start = self.activeTrip.date;
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *conversion = [cal components:unitFlags fromDate:start toDate:now options:0];
        
        [self.tripDurationLabel setText:[NSString stringWithFormat:@"%2dh%2dm%2ds", [conversion hour], [conversion minute], [conversion second]]];
        [self.tripDistanceLabel setText:[NSString stringWithFormat:@"%.2lfkm", (self.activeTrip.distanceValue / 1000.0)]];
    }
}

#pragma mark NSFetchedResultsControllerDelegate methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end
