//
//  HTSPage2ViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 12/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSPage2ViewController.h"

@interface HTSPage2ViewController ()

@end

@implementation HTSPage2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Welcome" style:UIBarButtonItemStyleBordered target:nil action:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextPage:) name:@"HTSUserDidRegister" object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HTSUserDidRegister" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)nextPage:(NSNotification *)not
{
    [self performSegueWithIdentifier:@"Show Tour" sender:self];
}

@end
