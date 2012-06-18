//
//  HTSTripDetailViewController.h
//  HTSiOS
//
//  Created by Justin Marrington on 25/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trip;
@class HTSTripMapViewController;

@interface HTSTripDetailViewController : UIViewController
@property (nonatomic, strong) HTSTripMapViewController *tripMapViewController;
@property (nonatomic, weak) Trip *trip;
@end
