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
                  success:(void(^)())success 
                  failure:(void(^)())failure;
- (void)registerWithUsername:(NSString *)username 
                    password:(NSString *)password 
                    andEmail:(NSString *)email 
                     success:(void(^)())success 
                     failure:(void(^)(NSString *errorMessage))failure;
- (void)logoutWithSuccess:(void(^)())success 
                  failure:(void(^)(NSError *error))failure;
- (BOOL)hasCredentials;
- (void)loginWithLocalCredentialsWithSuccess:(void(^)())success failure:(void(^)())failure;

- (void)batchUploadTrips:(NSArray *)tripsArray
            processStart:(void(^)())start
         processComplete:(void(^)())complete
             withSuccess:(void(^)())success
                 failure:(void(^)(NSError *error))failure
                progress:(void(^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress;

- (void)getActiveSurveysWithSuccess:(void(^)(NSArray *surveys))success failure:(void(^)())failure;

- (void)submitSurveyResponses:(NSArray *)responses
                  withSuccess:(void(^)())success
                      failure:(void(^)(NSError *error))failure;
@end
