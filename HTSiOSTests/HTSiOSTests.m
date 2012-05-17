//
//  HTSiOSTests.m
//  HTSiOSTests
//
//  Created by Justin Marrington on 17/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSiOSTests.h"
#import "GeoSample.h"

@implementation HTSiOSTests

- (void)setUp
{
    [super setUp];
    // Set-up code here.
    [MagicalRecordHelpers setDefaultModelForTestCase:[GeoSample class]];
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
}

- (void)tearDown
{
    // Tear-down code here.
    [MagicalRecordHelpers cleanUp];
    
    [super tearDown];
}

- (void)testBasicGeoSampleDistanceComparison
{
    GeoSample *mySample = [GeoSample MR_createEntity];
    mySample.longitudeValue = 51.261926;
    mySample.latitudeValue = 30.236045;
    mySample.timestamp = [NSDate date];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:50.0 longitude:30.0];
    STAssertFalse([mySample isCloseToLocation:loc distanceThreshold:1000.0], @"These distant points should not be detected as being quite close.");
    
}

@end
