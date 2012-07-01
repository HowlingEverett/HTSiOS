//
//  HTSTripHistoryTableViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 22/06/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSTripHistoryTableViewController.h"
#import "Trip.h"
#import "HTSAPIController.h"
#import "HTSGeoSampleManager.h"
#import "AFHTTPRequestOperation.h"

@interface HTSTripHistoryTableViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UIView *uploadProgressView;

@end

@implementation HTSTripHistoryTableViewController
@synthesize fetchedResultsController = _fetchedResultsController, uploadProgressView = _uploadProgressView;
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
    [self.fetchedResultsController performFetch:nil];
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
    
    // Configure the cell...
    Trip *trip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [trip tripDescription];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[NSManagedObjectContext MR_defaultContext]  sectionNameKeyPath:@"sectionIdentifier" cacheName:@"TripHistoryCache"];
        [_fetchedResultsController setDelegate:self];
    }
    
    return _fetchedResultsController;
}

- (IBAction)exportTrips:(id)sender
{
    NSArray *unexported = [self _unexportedTrips];

    [[HTSAPIController sharedApi] batchUploadTrips:unexported withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Couldn't upload samples. Network error: %@, body: %@", error, [operation responseString]);
    } progress:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Uploaded %lld bytes of %lld", totalBytesWritten, totalBytesExpectedToWrite);
    }];
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

@end
