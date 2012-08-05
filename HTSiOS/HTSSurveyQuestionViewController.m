//
//  HTSSurveyQuestionViewController.m
//  atlas
//
//  Created by Justin Marrington on 3/08/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSSurveyQuestionViewController.h"
#import "HTSOtherInputViewController.h"
#import "SurveyResponse.h"

@interface HTSSurveyQuestionViewController () <HTSOtherInputViewControllerDelegate>

@property (nonatomic, strong) NSString *vehicleType;
@end

@implementation HTSSurveyQuestionViewController

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

    self.groupName = self.navigationItem.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OtherInput"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setSenderCell:cell];
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        NSString *question = [self.tableView.dataSource tableView:self.tableView titleForHeaderInSection:path.section];
        [[segue destinationViewController] setQuestion:question];
    } else if ([segue.identifier isEqualToString:@"Next"]) {
        [self persistResponses];
    }
}

- (void)persistResponses
{
    int numSections = [self.tableView.dataSource numberOfSectionsInTableView:self.tableView];
    for (int s = 0; s < numSections; s++) {
        int numRows = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:s];
        SurveyResponse *response = [SurveyResponse createEntity];
        response.questionTitle = [self.tableView.dataSource tableView:self.tableView titleForHeaderInSection:s];
        NSString *answers = @"";
        
        for (int r = 0; r < numRows; r++) {
            NSIndexPath *cellPath = [NSIndexPath indexPathForRow:r inSection:s];
            UITableViewCell *cell = [self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:cellPath];
            
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                if ([cell.reuseIdentifier isEqualToString:@"OtherEntryCellDetail"]) {
                    answers = [answers stringByAppendingString:[NSString stringWithFormat:@"%@, ", cell.detailTextLabel.text]];
                } else {
                    if (s == 0) {
                        self.vehicleType = cell.textLabel.text;
                    }
                    answers = [answers stringByAppendingString:[NSString stringWithFormat:@"%@, ", cell.textLabel.text]];
                }
            }
        }
        
        // Trim off the last comma, if there were any selected responses at all
        if (answers.length > 2) {
            answers = [answers substringToIndex:answers.length - 2];
        }
        response.questionResponse = answers;
        response.groupName = self.groupName;
        [[NSManagedObjectContext defaultContext] save];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *singleSelectionCellIdentifier = @"SingleSelectionCell";
    static NSString *multiSelectionCellIdentifier = @"MultiSelectionCell";
    static NSString *otherEntryCellIdentifier = @"OtherEntryCell";
    static NSString *otherEntryCellDetailIdentifier = @"OtherEntryCellDetail";
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:singleSelectionCellIdentifier]) {
        int rowCount = [self.tableView numberOfRowsInSection:indexPath.section];
        for (int i = 0; i < rowCount; i++) {
            if (i == indexPath.row)
                continue;
            
            NSIndexPath *rowIndex = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            UITableViewCell *otherCell = [self.tableView cellForRowAtIndexPath:rowIndex];
            if (![otherCell.reuseIdentifier isEqualToString:@"OtherCell"]) {
                otherCell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if ([cell.reuseIdentifier isEqualToString:multiSelectionCellIdentifier]) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else if ([cell.reuseIdentifier isEqualToString:otherEntryCellIdentifier] || [cell.reuseIdentifier isEqualToString:otherEntryCellDetailIdentifier]) {
        [self performSegueWithIdentifier:@"OtherInput" sender:cell];
    }
}

#pragma mark HTSOtherInputViewControllerDelegate methods
- (void)didEnterCustomReason:(NSString *)reason intoCell:(UITableViewCell *)cell
{
    if ([cell.reuseIdentifier isEqualToString:@"OtherEntryCell"]) {
        cell.textLabel.text = reason;
    } else {
        cell.detailTextLabel.text = reason;
    }
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (IBAction)saveVehicle:(id)sender {
    [self persistResponses];
    [self.delegate didCreateVehicleWithType:self.vehicleType];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
