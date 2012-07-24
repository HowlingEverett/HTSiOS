//
//  HTSSurveyPickerViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 2/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSSurveyPickerViewController.h"

@interface HTSSurveyPickerViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) NSArray *surveys;
@property (weak, nonatomic) IBOutlet UILabel *surveyTitle;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation HTSSurveyPickerViewController
@synthesize picker;
@synthesize surveyTitle;
@synthesize surveys, delegate, selectedIndex, existingTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedIndex = 0;
    self.surveyTitle.text = existingTitle;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setSurveyTitle:nil];
    [self setPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSDictionary *surveyDict = [surveys objectAtIndex:selectedIndex];
    [self.delegate didSelectSurveyWithId:[[surveyDict objectForKey:@"surveyId"] intValue] andTitle:[surveyDict objectForKey:@"surveyTitle"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
    self.surveyTitle.text = [[self.surveys objectAtIndex:row] objectForKey:@"surveyTitle"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [surveys count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[surveys objectAtIndex:row] objectForKey:@"surveyTitle"];
}

@end
