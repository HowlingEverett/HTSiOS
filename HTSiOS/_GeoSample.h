// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GeoSample.h instead.

#import <CoreData/CoreData.h>


extern const struct GeoSampleAttributes {
	__unsafe_unretained NSString *heading;
	__unsafe_unretained NSString *headingAccuracy;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *locationAccuracy;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *speed;
	__unsafe_unretained NSString *timestamp;
} GeoSampleAttributes;

extern const struct GeoSampleRelationships {
	__unsafe_unretained NSString *trip;
} GeoSampleRelationships;

extern const struct GeoSampleFetchedProperties {
} GeoSampleFetchedProperties;

@class Trip;









@interface GeoSampleID : NSManagedObjectID {}
@end

@interface _GeoSample : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (GeoSampleID*)objectID;




@property (nonatomic, strong) NSNumber* heading;


@property double headingValue;
- (double)headingValue;
- (void)setHeadingValue:(double)value_;

//- (BOOL)validateHeading:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* headingAccuracy;


@property double headingAccuracyValue;
- (double)headingAccuracyValue;
- (void)setHeadingAccuracyValue:(double)value_;

//- (BOOL)validateHeadingAccuracy:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* latitude;


@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* locationAccuracy;


@property double locationAccuracyValue;
- (double)locationAccuracyValue;
- (void)setLocationAccuracyValue:(double)value_;

//- (BOOL)validateLocationAccuracy:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* longitude;


@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* speed;


@property double speedValue;
- (double)speedValue;
- (void)setSpeedValue:(double)value_;

//- (BOOL)validateSpeed:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate* timestamp;


//- (BOOL)validateTimestamp:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Trip* trip;

//- (BOOL)validateTrip:(id*)value_ error:(NSError**)error_;





@end

@interface _GeoSample (CoreDataGeneratedAccessors)

@end

@interface _GeoSample (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveHeading;
- (void)setPrimitiveHeading:(NSNumber*)value;

- (double)primitiveHeadingValue;
- (void)setPrimitiveHeadingValue:(double)value_;




- (NSNumber*)primitiveHeadingAccuracy;
- (void)setPrimitiveHeadingAccuracy:(NSNumber*)value;

- (double)primitiveHeadingAccuracyValue;
- (void)setPrimitiveHeadingAccuracyValue:(double)value_;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSNumber*)primitiveLocationAccuracy;
- (void)setPrimitiveLocationAccuracy:(NSNumber*)value;

- (double)primitiveLocationAccuracyValue;
- (void)setPrimitiveLocationAccuracyValue:(double)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




- (NSNumber*)primitiveSpeed;
- (void)setPrimitiveSpeed:(NSNumber*)value;

- (double)primitiveSpeedValue;
- (void)setPrimitiveSpeedValue:(double)value_;




- (NSDate*)primitiveTimestamp;
- (void)setPrimitiveTimestamp:(NSDate*)value;





- (Trip*)primitiveTrip;
- (void)setPrimitiveTrip:(Trip*)value;


@end
