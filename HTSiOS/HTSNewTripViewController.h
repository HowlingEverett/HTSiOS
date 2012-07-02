//
//  HTSNewTripViewController.h
//  HTSiOS
//
//  Created by Justin Marrington on 2/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTSSurveyPickerViewController.h"

@class Trip;
@protocol HTSNewTripViewControllerDelegate;

@interface HTSNewTripViewController : UITableViewController <HTSSurveyPickerViewControllerDelegate>
@property (nonatomic, weak) id<HTSNewTripViewControllerDelegate> delegate;
@end

@protocol HTSNewTripViewControllerDelegate
- (void)didCreateNewTrip:(Trip *)trip;
@end