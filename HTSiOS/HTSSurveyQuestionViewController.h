//
//  HTSSurveyQuestionViewController.h
//  atlas
//
//  Created by Justin Marrington on 3/08/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreatedVehicleDelegate
@optional
- (void)didCreateVehicleWithType:(NSString *)vehicleType;
@end

@interface HTSSurveyQuestionViewController : UITableViewController

@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, weak) id<CreatedVehicleDelegate> delegate;
@end
