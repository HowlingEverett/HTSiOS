#import "GeoSample.h"

@implementation GeoSample

// Custom logic goes here.
- (BOOL)isCloseToLocation:(CLLocation *)location distanceThreshold:(float)distanceInMetres
{
    CLLocation *thisLoc = [[CLLocation alloc] initWithLatitude:[self latitudeValue] longitude:[self longitudeValue]];
    return ([thisLoc distanceFromLocation:location] < distanceInMetres);
}

- (NSDictionary *)toDict
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSMutableDictionary *sampleDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.latitude, @"latitude", self.longitude, @"longitude",
                                       [df stringFromDate:self.timestamp], @"timestamp",
                                       self.locationAccuracy, @"location_accuracy",
                                       nil];
    if (self.speed) {
        [sampleDict setObject:self.speed forKey:@"speed"];
    }
    
    if (self.heading && self.headingAccuracy) {
        [sampleDict setObject:self.heading forKey:@"heading"];
        [sampleDict setObject:self.headingAccuracy forKey:@"heading_accuracy"];
    }
    
    return sampleDict;
}

@end
