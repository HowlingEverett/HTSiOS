//
//  HTSOtherPurposeViewController.m
//  atlas
//
//  Created by Justin Marrington on 24/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSOtherPurposeViewController.h"

@interface HTSOtherPurposeViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *purposeText;

@end

@implementation HTSOtherPurposeViewController
@synthesize purposeText;
@synthesize delegate;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.purposeText becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.delegate didEnterCustomPurpose:self.purposeText.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPurposeText:nil];
    [super viewDidUnload];
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}
@end
