//
//  HTSLoginViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 29/06/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSLoginViewController.h"
#import "HTSAPIController.h"
#import "HTSProfileViewController.h"

@interface HTSLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation HTSLoginViewController
@synthesize username;
@synthesize password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.username becomeFirstResponder];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)performLogin:(id)sender {
    [[HTSAPIController sharedApi] loginWithUsername:username.text andPassword:password.text success:^{
        [self dismissModalViewControllerAnimated:YES];
        UITabBarController *tabBar = (UITabBarController *)[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
        [tabBar setSelectedIndex:2];
        HTSProfileViewController *profileViewController = (HTSProfileViewController *)[[(UINavigationController *)[tabBar selectedViewController] viewControllers] objectAtIndex:0];
        UITableViewCell *cell = [profileViewController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [profileViewController selectSurvey:cell];
    } failure:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't log in" message:@"Was your username or password incorrect?" delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil];
        [alert show];
        [self.username becomeFirstResponder];
    }];
}

- (IBAction)cancelLogin:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
