//
//  HTSPage6ViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 12/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSPage6ViewController.h"

@interface HTSPage6ViewController ()

@end

@implementation HTSPage6ViewController

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

- (IBAction)finish:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
