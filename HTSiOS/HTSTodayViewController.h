//
//  HTSTodayViewController.h
//  HTSiOS
//
//  Created by Justin Marrington on 20/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "HTSNewTripViewController.h"

@interface HTSTodayViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIActionSheetDelegate, HTSNewTripViewControllerDelegate>

- (void)newTrip:(id)sel;
- (void)stopUpdates:(id)sel;
@end
