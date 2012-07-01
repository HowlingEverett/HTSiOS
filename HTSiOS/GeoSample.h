#import <CoreLocation/CoreLocation.h>

#import "_GeoSample.h"

@interface GeoSample : _GeoSample {}
// Custom logic goes here.

- (BOOL)isCloseToLocation:(CLLocation *)location distanceThreshold:(float)distanceInMetres;

- (NSDictionary *)toDict;

@end
