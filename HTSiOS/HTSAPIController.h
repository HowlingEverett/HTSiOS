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

- (void)batchUploadTrips:(NSArray *)tripsArray
             withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
                progress:(void(^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress;
@end
