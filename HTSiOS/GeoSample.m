#import "GeoSample.h"

@implementation GeoSample

// Custom logic goes here.
- (BOOL)isCloseToLocation:(CLLocation *)location distanceThreshold:(float)distanceInMetres
{
    CLLocation *thisLoc = [[CLLocation alloc] initWithLatitude:[self latitudeValue] longitude:[self longitudeValue]];
    return ([thisLoc distanceFromLocation:location] < distanceInMetres);
}

@end
