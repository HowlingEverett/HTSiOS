//
//  HTSNewTripViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 2/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSNewTripViewController.h"
#import "Trip.h"
#import "TransportMode.h"
#import "HTSAPIController.h"

@interface HTSNewTripViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tripPurpose;
@property (nonatomic, strong) NSArray *transportModes;
@property (nonatomic, weak) NSArray *surveys;
@end

@implementation HTSNewTripViewController
@synthesize tripPurpose, transportModes, delegate, surveys;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.transportModes = [NSArray arrayWithObjects:@"C", @"Cy", @"PT", @"P", @"T", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTripPurpose:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Select Survey For Trip"]) {
        [[segue destinationViewController] setSurveys:self.surveys];
        [[segue destinationViewController] setDelegate:self];
    }
}

- (IBAction)startNewTrip:(id)sender
{
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    if ([selectedRows count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No transport selected" message:@"You must select at least one mode of transport for this trip." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *surveyId;
    if (![defaults objectForKey:@"HTSActiveSurveyDictKey"]) {
        // User must select a survey before they can start a new trip
        [[HTSAPIController sharedApi] getActiveSurveysWithSuccess:^(NSArray *theSurveys) {
            self.surveys  = theSurveys;
            [self performSegueWithIdentifier:@"Select Survey For Trip" sender:self];
        } failure:nil];
        
        return;
    } else {
        surveyId = [[defaults objectForKey:@"HTSActiveSurveyDictKey"] objectForKey:@"surveyId"];
    }
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    Trip *trip = [Trip MR_createInContext:context];
    trip.tripDescription = self.tripPurpose.text;
    trip.date = [NSDate date];
    
    trip.surveyId = surveyId;
    for (NSIndexPath *indexPath in selectedRows) {
        TransportMode *tm = [TransportMode MR_createEntity];
        tm.mode = [self.transportModes objectAtIndex:indexPath.row];
        [trip.modesSet addObject:tm];
    }
    
    [context MR_save];
    [self.delegate didCreateNewTrip:trip];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didSelectSurveyWithId:(NSInteger)surveyId andTitle:(NSString *)title
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDictionary dictionaryWithObjectsAndKeys:title, @"surveyTitle", [NSNumber numberWithInt:surveyId], @"surveyId", nil] forKey:@"HTSActiveSurveyDictKey"];
    
    [self startNewTrip:self];
    [defaults synchronize];
}

@end
