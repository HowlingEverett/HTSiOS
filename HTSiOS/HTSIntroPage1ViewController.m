//
//  HTSIntroPage1ViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 12/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSIntroPage1ViewController.h"

@interface HTSIntroPage1ViewController ()

@end

@implementation HTSIntroPage1ViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)skipIntro:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"HTSFirstRunKey"];
    [defaults synchronize];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
