//
//  HTSAppDelegate.h
//  HTSiOS
//
//  Created by Justin Marrington on 17/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
