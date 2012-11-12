#import "Trip.h"
#import "TransportMode.h"
#import "GeoSample.h"

@implementation Trip
@dynamic primitiveSectionIdentifier;

// Custom logic goes here.
- (NSDictionary *)toDict
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    NSMutableArray *modes = [NSMutableArray arrayWithCapacity:self.modes.count];
    for (TransportMode *mode in self.modes) {
        [modes addObject:mode.mode];
    }
    
    NSDictionary *tripDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [df stringFromDate:self.date], @"date",
                                     self.tripDescription, @"description",
                                     [df stringFromDate:self.startTime], @"start_time",
                                     [df stringFromDate:self.endTime], @"end_time",
                                     self.distance, @"distance",
                                     modes, @"transport_modes",
                                     self.surveyId, @"survey_id", nil];
    
    return tripDict;
}

- (void)setDate:(NSDate *)newDate {
    
    // If the time stamp changes, the section identifier become invalid.
    [self willChangeValueForKey:@"date"];
    [self setPrimitiveDate:newDate];
    [self didChangeValueForKey:@"date"];
    
    [self setPrimitiveSectionIdentifier:nil];
}

- (NSString *)sectionIdentifier
{
    // Create and cache the section identifier on demand.
    
    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];
    
    if (!tmp) {
        /*
         Sections are organized by month and year. Create the section identifier as a string representing the number (year * 1000) + month; this way they will be correctly ordered chronologically regardless of the actual name of the month.
         */
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[self date]];
        tmp = [NSString stringWithFormat:@"%d", ([components year] * 1000000) + ([components month] * 1000) + [components day]];
        [self setPrimitiveSectionIdentifier:tmp];
    }
    return tmp;
}

+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    // If the value of date changes, the section identifier may change as well.
    return [NSSet setWithObject:@"date"];
}

@end
