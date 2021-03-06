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
#import "HTSGeoSampleManager.h"
#import "AFHTTPRequestOperation.h"
#import "HTSTripMapViewController.h"

@interface HTSTripHistoryTableViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDictionary *transportDescriptions;

@end

@implementation HTSTripHistoryTableViewController
@synthesize fetchedResultsController = _fetchedResultsController, transportDescriptions;
@synthesize tourDate;
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

    self.transportDescriptions = [NSDictionary dictionaryWithObjectsAndKeys:@"own vehicle", @"C", @"walking", @"P", @"cycling", @"Cy", @"public transport", @"PT", @"taxi", @"T", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
	NSInteger count = [sectionInfo numberOfObjects];
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"History Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Trip *trip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSTimeInterval length = [trip.endTime timeIntervalSinceDate:trip.startTime] / 60;
    
    NSString *modeStr = @"";
    for (TransportMode *tm in trip.modes) {
        modeStr = [modeStr stringByAppendingFormat:@"%@, ", [self.transportDescriptions objectForKey:tm.mode]];
    }
    modeStr = [modeStr substringToIndex:modeStr.length - 2];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", trip.tripDescription, modeStr];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    
    
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@–%@: %d minute trip.", [df stringFromDate:trip.startTime], [df stringFromDate:trip.endTime], (int)length];
        
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
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.tourDate];
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
        
        NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (isActive == NO) AND(tripDescription != %@)", start, end, @"SignificantLocationChange"];
        [fetch setPredicate:predicateTemplate];
        // Sort using the timeStamp property..
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetch setSortDescriptors:sortDescriptors];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[NSManagedObjectContext defaultContext]  sectionNameKeyPath:nil cacheName:nil];
        [_fetchedResultsController setDelegate:self];
    }
    
    return _fetchedResultsController;
}

@end
