//
//  HTSOtherInputViewController.m
//  atlas
//
//  Created by Justin Marrington on 3/08/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSOtherInputViewController.h"

@interface HTSOtherInputViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerText;
@end

@implementation HTSOtherInputViewController
@synthesize questionLabel;
@synthesize answerText;

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
    [self.questionLabel setText:self.question];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.answerText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.delegate didEnterCustomReason:answerText.text intoCell:self.senderCell];
}

- (void)viewDidUnload {
    [self setQuestionLabel:nil];
    [self setAnswerText:nil];
    [super viewDidUnload];
}
@end
