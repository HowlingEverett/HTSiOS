//
//  HTSRegisterViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 29/06/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSRegisterViewController.h"
#import "HTSAPIController.h"

@interface HTSRegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *repeatPassword;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation HTSRegisterViewController
@synthesize username;
@synthesize password;
@synthesize repeatPassword;
@synthesize email;
@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
    [self setRepeatPassword:nil];
    [self setEmail:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)registerParticipant:(id)sender {
    [[HTSAPIController sharedApi] registerWithUsername:self.username.text password:self.password.text andEmail:self.email.text success:^{
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HTSUserDidRegister" object:nil];
        }];
    } failure:^(NSString *errorMessage){
        NSLog(@"Error: %@", errorMessage);
    }];
}

#pragma mark Keyboard methods
- (void)keyboardWillShow:(NSNotification *)not
{
    [self moveScrollViewForKeyboard:not up:YES];
}

- (void)keyboardWillHide:(NSNotification *)not
{
    [self moveScrollViewForKeyboard:not up:NO];
}

- (void)moveScrollViewForKeyboard:(NSNotification *)not up:(BOOL)up
{
    NSDictionary *info = [not userInfo];
    
    
    CGRect keyboardEndFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    CGFloat scrollDistance = keyboardFrame.size.height * (up ? 1 : -1);
    [self.scrollView setContentOffset:CGPointMake(0.0, scrollDistance) animated:YES];
}

#pragma mark UITextFieldDelegate methods


@end
