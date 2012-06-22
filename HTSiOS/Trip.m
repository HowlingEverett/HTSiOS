#import "Trip.h"
#import "TransportMode.h"
#import "GeoSample.h"

@implementation Trip

// Custom logic goes here.
- (NSDictionary *)toDict
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSMutableArray *modes = [NSMutableArray arrayWithCapacity:self.modes.count];
    for (TransportMode *mode in self.modes) {
        [modes addObject:mode.mode];
    }
    
    NSMutableDictionary *tripDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [df stringFromDate:self.date], @"date",
                                     self.description, @"description",
                                     self.duration, @"duration",
                                     modes, @"transport_modes",
                                     self.surveyId, @"survey_id", nil];
    
    return tripDict;
}

@end
