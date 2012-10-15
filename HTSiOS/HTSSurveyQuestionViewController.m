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

@interface HTSSurveyQuestionViewController () <HTSOtherInputViewControllerDelegate, UIAlertViewDelegate>

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
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self selectExistingResponses];
}

- (void)selectExistingResponses
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int numSections = [self.tableView.dataSource numberOfSectionsInTableView:self.tableView];
    for (int i = 0; i < numSections; i++) {
        NSString *questionTitle = [self.tableView.dataSource tableView:self.tableView titleForHeaderInSection:i];
        id responseObject = [defaults objectForKey:questionTitle];
        if (responseObject) {
            NSArray *indexes = (NSArray *)responseObject;
            for (NSNumber *index in indexes) {
                int responseIndex = [index intValue];
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:responseIndex inSection:i];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//                [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
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
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (int s = 0; s < numSections; s++) {
        int numRows = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:s];
        NSString *questionTitle = [self.tableView.dataSource tableView:self.tableView titleForHeaderInSection:s];
        SurveyResponse *response = [SurveyResponse findFirstByAttribute:@"questionTitle" withValue:questionTitle];
        
        if (!response) {
            response = [SurveyResponse createEntity];
        }
        
        response.questionTitle = questionTitle;
        NSString *answers = @"";
//        NSMutableArray *answerIndexes = [[NSMutableArray alloc] init];
        
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
//                [answerIndexes addObject:@(r)];
            }
        }
//        [defaults setObject:answerIndexes forKey:questionTitle];
        
        // Trim off the last comma, if there were any selected responses at all
        if (answers.length > 2) {
            answers = [answers substringToIndex:answers.length - 2];
        }
        response.questionResponse = answers;
        response.groupName = self.groupName;
        [[NSManagedObjectContext defaultContext] save];
    }
//    [defaults synchronize];
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

- (void)cancel:(id)sender
{
    UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:@"Cancel demographic survey?" message:@"Your responses won't be submitted to the survey." delegate:self cancelButtonTitle:@"No, Wait" otherButtonTitles:@"Do it", nil];
    [cancelAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
