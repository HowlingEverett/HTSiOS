//
//  HTSTourHistoryViewController.m
//  atlas
//
//  Created by Justin Marrington on 14/08/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSTourHistoryViewController.h"
#import "HTSTripHistoryTableViewController.h"
#import "Trip.h"
#import "HTSAPIController.h"

@interface HTSTourHistoryViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *tripsDict;
@property (nonatomic, strong) UIProgressView *uploadProgressView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exportButton;
@end

@implementation HTSTourHistoryViewController

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
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.uploadProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateHistory];
    [self enableExportIfApplicable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Tour"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *cellPath = [self.tableView indexPathForCell:cell];
        NSArray *rows = [self sortedDateKeys];
        NSArray *tripsAtRow = [self.tripsDict objectForKey:[rows objectAtIndex:cellPath.row]];
        Trip *firstTrip = [tripsAtRow objectAtIndex:0];
        NSDate *tourDate = firstTrip.date;
        [segue.destinationViewController setTourDate:tourDate];
    }
}

- (void)updateHistory
{
    self.tripsDict = [[NSMutableDictionary alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isActive == NO) AND (tripDescription != %@)", @"SignificantLocationChange"];
    NSArray *trips = [Trip findAllWithPredicate:predicate];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    for (Trip *trip in trips) {
        NSDateComponents *components = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:trip.date];
        [components setHour:0];
        [components setMinute:0];
        [components setSecond:0];
        [components setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *d = [cal dateFromComponents:components];
        if ([self.tripsDict objectForKey:d]) {
            NSMutableArray *tripsAtDate = [self.tripsDict objectForKey:d];
            [tripsAtDate addObject:trip];
        } else {
            NSMutableArray *tripsAtDate = [[NSMutableArray alloc] init];
            [tripsAtDate addObject:trip];
            [self.tripsDict setObject:tripsAtDate forKey:d];
        }
    }
    
    [self.tableView reloadData];
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
        [self updateHistory];
        [self enableExportIfApplicable];
    } failure:^(NSError *error) {
        // -400 error means we stopped because there was nothing to upload. Silently reset in this case
        if (error && error.code != -400) {
            NSLog(@"Upload failure: error was %@", error);
            
            UIAlertView *uploadFailed = [[UIAlertView alloc] initWithTitle:@"Couldn't export trips" message:@"We weren't able to upload to the server: have you got a data connection?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [uploadFailed show];
        }
        
        [self.navigationItem setTitleView:nil];
        [self.navigationItem setTitle:@"Trip History"];
        
        [self updateHistory];
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
    for (NSDate *dateKey in self.tripsDict) {
        NSArray *tripsAtDate = [self.tripsDict objectForKey:dateKey];
        for (Trip *trip in tripsAtDate) {
            if (![trip isExported]) {
                [unexported addObject:trip];
            }
        }
    }
    
    return unexported;
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
    return [self.tripsDict count];
}

- (NSArray *)sortedDateKeys
{
    return [[self.tripsDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *d1 = (NSDate *)obj1;
        NSDate *d2 = (NSDate *)obj2;
        return [d1 compare:d2];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"History Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *rows = [self sortedDateKeys];
    NSArray *tripsAtRow = [self.tripsDict objectForKey:[rows objectAtIndex:indexPath.row]];
    Trip *firstTrip = [tripsAtRow objectAtIndex:0];
    
    // Configure the cell...
    cell.textLabel.text = [[HTSTourHistoryViewController shortDateFormatter] stringFromDate:firstTrip.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d trips", [tripsAtRow count]];
    
    BOOL allExported = YES;
    for (Trip *trip in tripsAtRow) {
        if (!trip.isExported) {
            allExported = NO;
            break;
        }
    }
    
    if (allExported) {
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

+ (NSDateFormatter *)shortDateFormatter
{
    static NSDateFormatter *instance;
    if (!instance) {
        instance = [[NSDateFormatter alloc] init];
        [instance setDateStyle:NSDateFormatterFullStyle];
    }
    
    return instance;
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
        [self.tableView beginUpdates];
        NSArray *rows = [self sortedDateKeys];
        NSArray *tripsAtRow = [self.tripsDict objectForKey:[rows objectAtIndex:indexPath.row]];
        for (Trip *trip in tripsAtRow) {
            [trip deleteEntity];
        }
        [self.tripsDict removeObjectForKey:[rows objectAtIndex:indexPath.row]];
        [[NSManagedObjectContext defaultContext] save];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

@end
