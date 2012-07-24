//
//  HTSSurveyPickerViewController.h
//  HTSiOS
//
//  Created by Justin Marrington on 2/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTSSurveyPickerViewControllerDelegate;

@interface HTSSurveyPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id<HTSSurveyPickerViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *existingTitle;
@end

@protocol HTSSurveyPickerViewControllerDelegate
- (void)didSelectSurveyWithId:(NSInteger)surveyId andTitle:(NSString *)title;
@end