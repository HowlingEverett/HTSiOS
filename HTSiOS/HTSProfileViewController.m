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
@property (nonatomic, strong) IBOutlet UILabel *surveyTitle;
@property (nonatomic, strong) IBOutlet UILabel *username;
@property (nonatomic, strong) IBOutlet UILabel *email;
@end

@implementation HTSProfileViewController
@synthesize ai, surveys, surveyTitle, username, email;

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
        UITableViewCell *cell = (UITableViewCell *)sender;
        [[segue destinationViewController] setExistingTitle:cell.textLabel.text];
        [[segue destinationViewController] setDelegate:self];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"HTSActiveSurveyDictKey"]) {
        surveyTitle.text = [[defaults objectForKey:@"HTSActiveSurveyDictKey"] objectForKey:@"surveyTitle"];
    } else {
        surveyTitle.text = @"Select survey";
    }
    
    if ([defaults objectForKey:@"HTSUsernameKey"]) {
        self.username.text = [defaults objectForKey:@"HTSUsernameKey"];
        self.email.text = [defaults objectForKey:@"HTSEmailKey"];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([[cell reuseIdentifier] isEqualToString:@"Survey Cell"]) {
        [self selectSurvey:cell];
    }
}

- (void)selectSurvey:(UITableViewCell *)cell
{
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if (!self.ai) {
        self.ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
    }
    [cell setAccessoryView:self.ai];
    [ai startAnimating];
    
    [[HTSAPIController sharedApi] getActiveSurveysWithSuccess:^(NSArray *surveyArray) {
        self.surveys = surveyArray;
        [self performSegueWithIdentifier:@"Select Survey" sender:cell];
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

- (void)didSelectSurveyWithId:(NSInteger)surveyId andTitle:(NSString *)title
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDictionary dictionaryWithObjectsAndKeys:title, @"surveyTitle", [NSNumber numberWithInt:surveyId], @"surveyId", nil] forKey:@"HTSActiveSurveyDictKey"];
    [defaults synchronize];
    surveyTitle.text = title;
}

- (IBAction)logOut:(id)sender {
    [[HTSAPIController sharedApi] logoutWithSuccess:^{
        self.username.text = nil;
        self.email.text = nil;
        self.surveyTitle.text = @"No survey";
    } failure:^(NSError *error) {
        NSLog(@"Couldn't log you out. Failure message: %@", error);
    }];
}


@end
