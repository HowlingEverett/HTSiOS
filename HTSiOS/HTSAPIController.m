//
//  HTSAPIController.m
//  HTSiOS
//
//  Created by Justin Marrington on 20/06/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSAPIController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "Trip.h"
#import "GeoSample.h"

@interface HTSAPIController ()

@property (nonatomic, strong) AFHTTPClient *client;
@end

@implementation HTSAPIController

#define kAPIBase @"http://localhost:8000/"

+ (HTSAPIController *)sharedApi
{
    static HTSAPIController *instance;
    if (!instance) {
        instance = [[HTSAPIController alloc] init];
        instance.client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBase]];
        [instance.client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    
    return instance;
}

- (void)batchUploadTrips:(NSArray *)tripsArray
             withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
                progress:(void(^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
{
    
    
    dispatch_queue_t tripProcessQueue = dispatch_queue_create("com.lovelyhead.tripProcessQueue", 0);
    dispatch_async(tripProcessQueue, ^{
        // First, create the JSON-encoded body for the request out of trips and samples
        NSMutableArray *tripsArray = [NSMutableArray array];
        for (Trip *trip in tripsArray) {
            NSDictionary *tripDict = [trip toDict];
            NSMutableArray *samples = [[NSMutableArray alloc] initWithCapacity:trip.samples.count];
            for (GeoSample *sample in trip.samples) {
                [samples addObject:[sample toDict]];
            }
            
            [tripsArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:tripDict, @"trip", samples, @"samples", nil]];
        }
        
        NSDictionary *payloadDict = [NSDictionary dictionaryWithObject:tripsArray forKey:@"trips"];
        //NSError *error;
        //NSData *payloadJSON = [NSJSONSerialization dataWithJSONObject:payloadDict options:nil error:&error];
        
        [self.client setParameterEncoding:AFJSONParameterEncoding];
        NSMutableURLRequest *request = [self.client requestWithMethod:@"POST" path:@"/api/batch_upload/" parameters:payloadDict];
        
        //[self.client postPath:@"/api/batch_upload/" parameters:payloadDict success:success failure:failure];
        AFJSONRequestOperation *jsonOperation = [[AFJSONRequestOperation alloc] initWithRequest:request];
        [jsonOperation setUploadProgressBlock:progress];
        [jsonOperation setCompletionBlockWithSuccess:success failure:failure];
        
        [jsonOperation start];
    });
    
}

@end
