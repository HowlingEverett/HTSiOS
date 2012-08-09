//
//  HTSAPIController.m
//  HTSiOS
//
//  Created by Justin Marrington on 20/06/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSAPIController.h"
#import "AFHTTPClient.h"
#import "LFCGzipUtility.h"
#import "AFJSONRequestOperation.h"
#import "Trip.h"
#import "GeoSample.h"
#import "SurveyResponse.h"

@interface HTSAPIController ()

@property (nonatomic, strong) AFHTTPClient *client;
@end

@implementation HTSAPIController
@synthesize client;
#define kAPIBase @"http://againstdragons.usdlc.net/"

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

- (BOOL)hasCredentials
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"HTSUsernameKey"] && [defaults objectForKey:@"HTSPasswordKey"])
        return YES;
    return NO;
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password success:(void(^)())success failure:(void(^)())failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.client postPath:@"/api/login/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully logged in. Response body: %@", responseObject);
        NSString *email = [responseObject valueForKeyPath:@"success.fields.email"];
        [defaults setObject:email forKey:@"HTSEmailKey"];
        [defaults setObject:username forKey:@"HTSUsernameKey"];
        [defaults setObject:password forKey:@"HTSPasswordKey"];
        [defaults synchronize];
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Couldn't log in: error %@", error);
        [defaults removeObjectForKey:@"HTSUsernameKey"];
        [defaults removeObjectForKey:@"HTSPasswordKey"];
        [defaults synchronize];
        if (failure) {
            failure();
        }
    }];
}

- (void)logoutWithSuccess:(void(^)())success 
                  failure:(void(^)(NSError *error))failure
{
    [self.client postPath:@"/api/logout/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"HTSUsernameKey"];
        [defaults removeObjectForKey:@"HTSPasswordKey"];
        [defaults removeObjectForKey:@"HTSEmailKey"];
        [defaults removeObjectForKey:@"HTSActiveSurveyDictKey"];
        [defaults synchronize];
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)registerWithUsername:(NSString *)username 
                    password:(NSString *)password 
                    andEmail:(NSString *)email 
                     success:(void(^)())success 
                     failure:(void(^)(NSString *errorMessage))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", email, @"email", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self.client postPath:@"/api/register/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully registered. Response body: %@", responseObject);
        NSString *email = [responseObject valueForKeyPath:@"success.fields.email"];
        [defaults setObject:email forKey:@"HTSEmailKey"];
        [defaults setObject:username forKey:@"HTSUsernameKey"];
        [defaults setObject:password forKey:@"HTSPasswordKey"];
        [defaults synchronize];
        
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorMessage;
        if (operation.response.statusCode == 400) {
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            errorMessage = [errorDict objectForKey:@"error"];
        } else {
            NSLog(@"Error: %@, %@", error, operation.responseString);
            errorMessage = @"Request couldn't be completed. We probably had no internet, cap'n!";
        }
        
        if (failure) {
            failure(errorMessage);
        }
    }];
}

- (void)loginWithLocalCredentialsWithSuccess:(void(^)())success failure:(void(^)())failure
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"HTSUsernameKey"];
    NSString *password = [defaults objectForKey:@"HTSPasswordKey"];
    [self loginWithUsername:username andPassword:password success:success failure:failure];
}

- (void)batchUploadTrips:(NSArray *)tripsArray
            processStart:(void(^)())start
         processComplete:(void(^)())complete
             withSuccess:(void(^)())success
                 failure:(void(^)(NSError *error))failure
                progress:(void(^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
{
    // Don't try to upload if 
    if ([tripsArray count] == 0) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No trips to export" forKey:@"NSLocalizedDescriptionKey"];
        NSError *error = [[NSError alloc] initWithDomain:@"HTSAPIDomain" code:-400 userInfo:userInfo];
        failure(error);
        return;
    }
    
    start();
    
    dispatch_queue_t tripProcessQueue = dispatch_queue_create("com.lovelyhead.tripProcessQueue", 0);
    dispatch_async(tripProcessQueue, ^{
        // First, create the JSON-encoded body for the request out of trips and samples
        NSMutableArray *trips = [NSMutableArray array];
        for (Trip *trip in tripsArray) {
            NSDictionary *tripDict = [trip toDict];
            NSLog(@"%@", tripDict);
            NSMutableArray *samples = [[NSMutableArray alloc] initWithCapacity:trip.samples.count];
            for (GeoSample *sample in trip.samples) {
                [samples addObject:[sample toDict]];
            }
            
            [trips addObject:[NSDictionary dictionaryWithObjectsAndKeys:tripDict, @"trip", samples, @"samples", nil]];
        }
        
        NSDictionary *payloadDict = [NSDictionary dictionaryWithObject:trips forKey:@"trips"];
        NSData *payload =  [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:nil];
        // Compress upload with gzip
        payload = [LFCGzipUtility gzipData:payload];
        NSMutableURLRequest *request = [self.client multipartFormRequestWithMethod:@"POST" path:@"/api/batch_upload/" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:payload name:@"payload" fileName:@"payload.gz" mimeType:@"application/gzip"];
        }];
        
        complete();
        
        AFJSONRequestOperation *jsonOperation = [[AFJSONRequestOperation alloc] initWithRequest:request];
        [jsonOperation setUploadProgressBlock:progress];
        [jsonOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            for (Trip *trip in tripsArray) {
                trip.isExportedValue = YES;
            }
            
            [[NSManagedObjectContext contextForCurrentThread] save:nil];
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Couldn't upload data. responseBody: %@", operation.responseString);
            
            failure(error);
        }];
        
        [jsonOperation start];
    });
    
}

- (void)getActiveSurveysWithSuccess:(void(^)(NSArray *surveys))success failure:(void(^)())failure
{
    [self.client getPath:@"/api/surveys/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) { 
        NSArray *surveysRaw = responseObject;
        NSMutableArray *surveys = [NSMutableArray arrayWithCapacity:surveysRaw.count];
        for (NSDictionary *surveyDict in surveysRaw) {
            [surveys addObject:[NSDictionary dictionaryWithObjectsAndKeys:[surveyDict valueForKeyPath:@"fields.title"], @"surveyTitle", [surveyDict valueForKeyPath:@"pk"], @"surveyId", nil]];
        }
        
        success([surveys copy]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure();
    }];
}

- (void)submitSurveyResponses:(NSArray *)responses
                  withSuccess:(void(^)())success
                      failure:(void(^)(NSError *error))failure
{
    NSMutableArray *responsesArray = [[NSMutableArray alloc] init];
    for (SurveyResponse *response in responses) {
        [responsesArray addObject:[response toDict]];
    }
    NSDictionary *payloadDict = @{ @"responses" : responsesArray };
    NSData *payload = [NSJSONSerialization dataWithJSONObject:payloadDict options:0 error:nil];
    payload = [LFCGzipUtility gzipData:payload];
    NSURLRequest *request = [self.client multipartFormRequestWithMethod:@"POST" path:@"/api/submit_survey/" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:payload name:@"payload" fileName:@"payload.gz" mimeType:@"application/gzip"];
    }];
    
    AFJSONRequestOperation *jsonOperation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [jsonOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
        failure(error);
    }];
    
    [jsonOperation start];
}

@end
