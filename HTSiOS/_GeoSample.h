// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GeoSample.h instead.

#import <CoreData/CoreData.h>


extern const struct GeoSampleAttributes {
	__unsafe_unretained NSString *heading;
	__unsafe_unretained NSString *heading_accuracy;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *location_accuracy;
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


@property float headingValue;
- (float)headingValue;
- (void)setHeadingValue:(float)value_;

//- (BOOL)validateHeading:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* heading_accuracy;


@property float heading_accuracyValue;
- (float)heading_accuracyValue;
- (void)setHeading_accuracyValue:(float)value_;

//- (BOOL)validateHeading_accuracy:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* latitude;


@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* location_accuracy;


@property float location_accuracyValue;
- (float)location_accuracyValue;
- (void)setLocation_accuracyValue:(float)value_;

//- (BOOL)validateLocation_accuracy:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* longitude;


@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* speed;


@property float speedValue;
- (float)speedValue;
- (void)setSpeedValue:(float)value_;

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

- (float)primitiveHeadingValue;
- (void)setPrimitiveHeadingValue:(float)value_;




- (NSNumber*)primitiveHeading_accuracy;
- (void)setPrimitiveHeading_accuracy:(NSNumber*)value;

- (float)primitiveHeading_accuracyValue;
- (void)setPrimitiveHeading_accuracyValue:(float)value_;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSNumber*)primitiveLocation_accuracy;
- (void)setPrimitiveLocation_accuracy:(NSNumber*)value;

- (float)primitiveLocation_accuracyValue;
- (void)setPrimitiveLocation_accuracyValue:(float)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




- (NSNumber*)primitiveSpeed;
- (void)setPrimitiveSpeed:(NSNumber*)value;

- (float)primitiveSpeedValue;
- (void)setPrimitiveSpeedValue:(float)value_;




- (NSDate*)primitiveTimestamp;
- (void)setPrimitiveTimestamp:(NSDate*)value;





- (Trip*)primitiveTrip;
- (void)setPrimitiveTrip:(Trip*)value;


@end
