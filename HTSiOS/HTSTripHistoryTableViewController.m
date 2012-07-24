//
//  HTSTripHistoryTableViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 22/06/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSTripHistoryTableViewController.h"
#import "Trip.h"
#import "TransportMode.h"
#import "HTSAPIController.h"
#import "HTSGeoSampleManager.h"
#import "AFHTTPRequestOperation.h"
#import "HTSTripMapViewController.h"

@interface HTSTripHistoryTableViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UIProgressView *uploadProgressView;
@property (nonatomic, strong) NSDictionary *transportDescriptions;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exportButton;

@end

@implementation HTSTripHistoryTableViewController
@synthesize exportButton = _exportButton;
@synthesize fetchedResultsController = _fetchedResultsController, uploadProgressView = _uploadProgressView, transportDescriptions;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.transportDescriptions = [NSDictionary dictionaryWithObjectsAndKeys:@"own vehicle", @"C", @"walking", @"P", @"cycling", @"Cy", @"public transport", @"PT", @"taxi", @"T", nil];
    
    [self.fetchedResultsController performFetch:nil];
    self.uploadProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    
    [self enableExportIfApplicable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
	NSInteger count = [sectionInfo numberOfObjects];
	return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    /*
     Section information derives from an event's sectionIdentifier, which is a string representing the number (year * 1000) + month.
     To display the section title, convert the year and month components to a string representation.
     */
    static NSArray *monthSymbols = nil;
    
    if (!monthSymbols) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setCalendar:[NSCalendar currentCalendar]];
        monthSymbols = [formatter monthSymbols];
    }
    
    NSInteger numericSection = [[theSection name] integerValue];
    
	NSInteger year = numericSection / 1000000;
	NSInteger month = (numericSection - (year * 1000000)) / 1000;
    NSInteger day = (numericSection - (year * 1000000) - (month * 1000));
	
	NSString *titleString = [NSString stringWithFormat:@"%@ %d, %d", [monthSymbols objectAtIndex:month-1], day, year];
	
	return titleString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"History Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Trip *trip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSDate *start = [trip.samplesSet valueForKeyPath:@"@min.timestamp"];
    NSDate *end = [trip.samplesSet valueForKeyPath:@"@max.timestamp"];
    NSTimeInterval length = [end timeIntervalSinceDate:start] / 60;
    
    NSString *modeStr = @"";
    for (TransportMode *tm in trip.modes) {
        modeStr = [modeStr stringByAppendingFormat:@"%@, ", [self.transportDescriptions objectForKey:tm.mode]];
    }
    modeStr = [modeStr substringToIndex:modeStr.length - 2];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", trip.tripDescription, modeStr];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    
    
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@–%@: %d minute trip.", [df stringFromDate:start], [df stringFromDate:end], (int)length];
    if (trip.isExported) {
        cell.imageView.image = [UIImage imageNamed:@"done.png"];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"cloud_upload.png"];
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.detailTextLabel.textColor = [UIColor darkTextColor];
    }
        
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show History Map"]) {
        NSIndexPath *cellPath  = [self.tableView indexPathForCell:sender];
        Trip *trip = [self.fetchedResultsController objectAtIndexPath:cellPath];
        [[segue destinationViewController] setTrip:trip];
        [[[segue destinationViewController] navigationItem] setTitle:trip.tripDescription];
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        // Fetch all trips made today
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Trip"];
        // Set the batch size to a suitable number.
        [fetch setFetchBatchSize:20];
        
        // Sort using the timeStamp property..
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetch setSortDescriptors:sortDescriptors];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[NSManagedObjectContext defaultContext]  sectionNameKeyPath:@"sectionIdentifier" cacheName:@"TripHistoryCache"];
        [_fetchedResultsController setDelegate:self];
    }
    
    return _fetchedResultsController;
}

- (IBAction)exportTrips:(id)sender
{
    self.exportButton.enabled = NO;
    NSArray *unexported = [self _unexportedTrips];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [[HTSAPIController sharedApi] batchUploadTrips:unexported processStart:^{
        self.navigationItem.titleView = activity;
        [activity startAnimating];
    } processComplete:^{
        [activity stopAnimating];
        self.navigationItem.titleView = self.uploadProgressView;
    } withSuccess:^{
        [self.navigationItem setTitleView:nil];
        [self.navigationItem setTitle:@"Trip History"];
        [self.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
        
        [self enableExportIfApplicable];
    } failure:^(NSError *error) {
        // -400 error means we stopped because there was nothing to upload. Silently reset in this case
        if (error && error.code != -400) {
            NSLog(@"Upload failure: error was %@", error);
        }
        
        [self.navigationItem setTitleView:nil];
        [self.navigationItem setTitle:@"Trip History"];
        
        [self enableExportIfApplicable];
    } progress:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        [self.uploadProgressView setProgress:totalBytesWritten / (float)totalBytesExpectedToWrite];
    }];
    
}

- (void)enableExportIfApplicable
{
    if ([[self _unexportedTrips] count] == 0) {
        self.exportButton.enabled = NO;
    } else {
        self.exportButton.enabled = YES;
    }
}

- (NSArray *)_unexportedTrips
{
    NSMutableArray *unexported = [NSMutableArray array];
    for (id<NSFetchedResultsSectionInfo> sectioninfo in self.fetchedResultsController.sections) {
        for (Trip *trip in [sectioninfo objects]) {
            if (![trip isExported]) {
                [unexported addObject:trip];
            }
        }
    }
    
    return unexported;
}

//- (UIView *)uploadProgressView
//{
//    if (_uploadProgressView)
//        return _uploadProgressView;
//    
//    _uploadProgressView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x + (self.view.bounds.size.width / 2) - 100.0, self.view.bounds.origin.y + (self.view.bounds.size.height / 2) - 19.0, 200.0, 38.0)];
//    [_uploadProgressView setBackgroundColor:[UIColor blackColor]];
//    UIProgressView *progressView = [
//}

- (void)viewDidUnload {
    [self setExportButton:nil];
    [super viewDidUnload];
}
@end
