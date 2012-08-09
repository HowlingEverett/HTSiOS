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
#import "HTSOtherPurposeViewController.h"

@interface HTSNewTripViewController () <HTSOtherPurposeDelegate>
@property (nonatomic, strong) NSArray *transportModes;
@property (nonatomic, strong) NSMutableSet *selectedModes;
@property (nonatomic, weak) NSArray *surveys;

@property (nonatomic, strong) NSString *tripPurpose;
@end

@implementation HTSNewTripViewController
@synthesize transportModes, selectedModes, delegate, surveys, tripPurpose;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.transportModes = [NSArray arrayWithObjects:@"C", @"Cy", @"PT", @"P", @"T", nil];
    self.selectedModes = [NSMutableSet set];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([indexPath section] == 0) {
        int rowCount = [self.tableView numberOfRowsInSection:0];
        for (int i = 0; i < rowCount; i++) {
            
            NSIndexPath *rowIndex = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *otherCell = [self.tableView cellForRowAtIndexPath:rowIndex];
            if (![otherCell.reuseIdentifier isEqualToString:@"Other Row"]) {
                otherCell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                if (otherCell.accessoryType == UITableViewCellAccessoryCheckmark) {
                    otherCell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
        
        if (![cell.reuseIdentifier isEqualToString:@"Other Row"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        self.tripPurpose = cell.textLabel.text;
    } else {
        NSString *modeValue = [self.transportModes objectAtIndex:indexPath.row];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            for (NSString *selectedMode in [self.selectedModes copy]) {
                if ([selectedMode isEqualToString:modeValue]) {
                    [self.selectedModes removeObject:selectedMode];
                }
            }
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedModes addObject:modeValue];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Select Survey For Trip"]) {
        [[segue destinationViewController] setSurveys:self.surveys];
        [[segue destinationViewController] setDelegate:self];
    } else if ([segue.identifier isEqualToString:@"Select Custom Purpose"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (IBAction)startNewTrip:(id)sender
{
    if ([selectedModes count] == 0 || !self.tripPurpose) {
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
    
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    Trip *trip = [Trip createInContext:context];
    trip.tripDescription = self.tripPurpose;
    trip.date = [NSDate date];
    
    trip.surveyId = surveyId;
    for (NSString *selectedMode in self.selectedModes) {
        TransportMode *tm = [TransportMode createEntity];
        tm.mode = selectedMode;
        [trip.modesSet addObject:tm];
    }
    trip.isActiveValue = TRUE;
    
    [context save];
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

#pragma mark -
#pragma mark HTSOtherPurposeDelegate methods
- (void)didEnterCustomPurpose:(NSString *)purpose
{
    NSIndexPath *otherPath = [NSIndexPath indexPathForRow:6 inSection:0];
    UITableViewCell *otherPurposeCell = [self.tableView cellForRowAtIndexPath:otherPath];
    otherPurposeCell.textLabel.text = purpose;
    otherPurposeCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.tripPurpose = purpose;
}

@end