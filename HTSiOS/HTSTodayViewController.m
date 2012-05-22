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
#import "HTSGeoSampleManager.h"

@interface HTSTodayViewController ()

// Data objects
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDictionary *transportDescriptions;
@property (nonatomic, assign) BOOL loggingEnabled;
@property (nonatomic, strong) Trip *activeTrip;

// Outlets
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *tripNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

// Actions
- (IBAction)startStop:(id)sender;
- (IBAction)openCurrentTrip:(id)sender;
@end

@implementation HTSTodayViewController
@synthesize locationManager = _locationManager;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize mapView = _mapView;
@synthesize tripNameLabel = _tripNameLabel;
@synthesize startStopButton = _startStopButton;
@synthesize activeTrip = _activeTrip;
@synthesize transportDescriptions;
@synthesize loggingEnabled;

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
    
    // Tapping on current trip map should open full view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCurrentTrip:)];
    [self.mapView addGestureRecognizer:tap];
}

- (void)viewDidUnload
{
    [self setTripNameLabel:nil];
    [self setMapView:nil];
    [self setStartStopButton:nil];
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
        
    } else if ([segue.identifier isEqualToString:@"View Historical Trip"]) {
        
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
    cell.textLabel.text = [NSString stringWithFormat:@"%.2f minute trip %@", length, [self.transportDescriptions objectForKey:trip.transportType]];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@–%@: %@", [df stringFromDate:start], [df stringFromDate:end], trip.tripDescription];
    
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
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [_locationManager setDelegate:self];
    }
    
    return _locationManager;
}

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
    if (!self.loggingEnabled) {
        [self.locationManager startUpdatingLocation];
        if ([CLLocationManager headingAvailable]) {
            [self.locationManager startUpdatingHeading];
        }        
        [self.locationManager stopMonitoringSignificantLocationChanges];
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
        
        NSLog(@"Started updating locations.");
    } else {
        [self.locationManager stopUpdatingLocation];
        if ([CLLocationManager headingAvailable]) {
            [self.locationManager stopUpdatingHeading];
        }
        [self.locationManager startMonitoringSignificantLocationChanges];
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.startStopButton setBackgroundImage:[[UIImage imageNamed:@"buttonbackgroundgreen.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [[self.startStopButton titleLabel] setTextColor:[UIColor whiteColor]];
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
    [[NSManagedObjectContext MR_defaultContext] MR_save];
}

#pragma mark CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    // Otherwise, create and save a GeoSample
    [HTSGeoSampleManager createSampleForLocation:newLocation onTrip:self.activeTrip];
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
