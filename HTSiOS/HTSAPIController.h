//
//  HTSAPIController.h
//  HTSiOS
//
//  Created by Justin Marrington on 20/06/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface HTSAPIController : NSObject

+ (HTSAPIController *)sharedApi;

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password 
             failureBlock:(void(^)())failure;
- (BOOL)hasCredentials;
- (void)loginWithLocalCredentialsWithFailureBlock:(void(^)())failure;

- (void)batchUploadTrips:(NSArray *)tripsArray
             withSuccess:(void(^)())success
                 failure:(void(^)())failure
                progress:(void(^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress;
@end
