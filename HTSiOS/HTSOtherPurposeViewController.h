//
//  HTSOtherPurposeViewController.h
//  atlas
//
//  Created by Justin Marrington on 24/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTSOtherPurposeDelegate
- (void)didEnterCustomPurpose:(NSString *)purpose;
@end

@interface HTSOtherPurposeViewController : UIViewController

@property (nonatomic, weak) id<HTSOtherPurposeDelegate> delegate;
@end
