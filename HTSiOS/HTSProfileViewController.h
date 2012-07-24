//
//  HTSProfileViewController.h
//  HTSiOS
//
//  Created by Justin Marrington on 2/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTSSurveyPickerViewController.h"

@protocol HTSSurveyPickerViewControllerDelegate;
@interface HTSProfileViewController : UITableViewController <UITableViewDelegate, HTSSurveyPickerViewControllerDelegate>

- (void)selectSurvey:(UITableViewCell *)surveyCell;
@end
