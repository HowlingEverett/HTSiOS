//
//  HTSSurveyPickerViewController.m
//  HTSiOS
//
//  Created by Justin Marrington on 2/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSSurveyPickerViewController.h"

@interface HTSSurveyPickerViewController ()

@property (nonatomic, strong) NSArray *surveys;
@end

@implementation HTSSurveyPickerViewController
@synthesize surveys, delegate;

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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *surveyDict = [surveys objectAtIndex:row];
    
    [self.delegate didSelectSurveyWithId:[[surveyDict objectForKey:@"surveyId"] intValue] andTitle:[surveyDict objectForKey:@"surveyTitle"]];
    
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
    NSLog(@"%@", [surveys objectAtIndex:row]);
    return [[surveys objectAtIndex:row] objectForKey:@"surveyTitle"];
}

@end
