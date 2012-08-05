//
//  HTSOtherInputViewController.h
//  atlas
//
//  Created by Justin Marrington on 3/08/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTSOtherInputViewControllerDelegate;

@interface HTSOtherInputViewController : UIViewController

@property (nonatomic, weak) UITableViewCell *senderCell;
@property (nonatomic, weak) id<HTSOtherInputViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *question;
@end


@protocol HTSOtherInputViewControllerDelegate

- (void)didEnterCustomReason:(NSString *)reason intoCell:(UITableViewCell *)cell;

@end
