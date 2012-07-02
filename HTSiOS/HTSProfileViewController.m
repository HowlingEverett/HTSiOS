//
//  HTSProfileViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 2/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSProfileViewController.h"
#import "HTSAPIController.h"

@interface HTSProfileViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *ai;
@property (nonatomic, strong) NSArray *surveys;
@end

@implementation HTSProfileViewController
@synthesize ai, surveys;

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
}

- (void)viewDidUnload
{
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
    if ([[segue identifier] isEqualToString:@"Select Survey"]) {
        [[segue destinationViewController] setSurveys:self.surveys];
    }
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
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([[cell reuseIdentifier] isEqualToString:@"Survey Cell"]) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        if (!self.ai) {
            self.ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
        }
        [cell setAccessoryView:self.ai];
        [ai startAnimating];
        
        [[HTSAPIController sharedApi] getActiveSurveysWithSuccess:^(NSArray *surveyArray) {
            self.surveys = surveyArray;
            [self performSegueWithIdentifier:@"Select Survey" sender:self];
            [ai stopAnimating];
            cell.accessoryView = nil;
            [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        } failure:^{
            [ai stopAnimating];
            cell.accessoryView = nil;
            [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't get surveys" message:@"We couldn't find any surveys for you to participate in." delegate:self cancelButtonTitle:@"Sorry" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)didSelectSurveyWithId:(NSInteger)surveyId andTitle:(NSString *)title
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDictionary dictionaryWithObjectsAndKeys:title, @"surveyTitle", [NSNumber numberWithInt:surveyId], @"surveyId", nil] forKey:@"HTSActiveSurveyDictKey"];
    [defaults synchronize];
}

@end
