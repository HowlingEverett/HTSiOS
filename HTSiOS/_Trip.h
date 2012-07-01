// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Trip.h instead.

#import <CoreData/CoreData.h>


extern const struct TripAttributes {
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *duration;
	__unsafe_unretained NSString *isExported;
	__unsafe_unretained NSString *sectionIdentifier;
	__unsafe_unretained NSString *surveyId;
	__unsafe_unretained NSString *transportType;
	__unsafe_unretained NSString *tripDescription;
} TripAttributes;

extern const struct TripRelationships {
	__unsafe_unretained NSString *modes;
	__unsafe_unretained NSString *samples;
} TripRelationships;

extern const struct TripFetchedProperties {
} TripFetchedProperties;

@class TransportMode;
@class GeoSample;









@interface TripID : NSManagedObjectID {}
@end

@interface _Trip : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TripID*)objectID;




@property (nonatomic, strong) NSDate* date;


//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* duration;


@property float durationValue;
- (float)durationValue;
- (void)setDurationValue:(float)value_;

//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* isExported;


@property BOOL isExportedValue;
- (BOOL)isExportedValue;
- (void)setIsExportedValue:(BOOL)value_;

//- (BOOL)validateIsExported:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* sectionIdentifier;


//- (BOOL)validateSectionIdentifier:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* surveyId;


@property int16_t surveyIdValue;
- (int16_t)surveyIdValue;
- (void)setSurveyIdValue:(int16_t)value_;

//- (BOOL)validateSurveyId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* transportType;


//- (BOOL)validateTransportType:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* tripDescription;


//- (BOOL)validateTripDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* modes;

- (NSMutableSet*)modesSet;




@property (nonatomic, strong) NSSet* samples;

- (NSMutableSet*)samplesSet;





@end

@interface _Trip (CoreDataGeneratedAccessors)

- (void)addModes:(NSSet*)value_;
- (void)removeModes:(NSSet*)value_;
- (void)addModesObject:(TransportMode*)value_;
- (void)removeModesObject:(TransportMode*)value_;

- (void)addSamples:(NSSet*)value_;
- (void)removeSamples:(NSSet*)value_;
- (void)addSamplesObject:(GeoSample*)value_;
- (void)removeSamplesObject:(GeoSample*)value_;

@end

@interface _Trip (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSNumber*)primitiveDuration;
- (void)setPrimitiveDuration:(NSNumber*)value;

- (float)primitiveDurationValue;
- (void)setPrimitiveDurationValue:(float)value_;




- (NSNumber*)primitiveIsExported;
- (void)setPrimitiveIsExported:(NSNumber*)value;

- (BOOL)primitiveIsExportedValue;
- (void)setPrimitiveIsExportedValue:(BOOL)value_;




- (NSString*)primitiveSectionIdentifier;
- (void)setPrimitiveSectionIdentifier:(NSString*)value;




- (NSNumber*)primitiveSurveyId;
- (void)setPrimitiveSurveyId:(NSNumber*)value;

- (int16_t)primitiveSurveyIdValue;
- (void)setPrimitiveSurveyIdValue:(int16_t)value_;




- (NSString*)primitiveTransportType;
- (void)setPrimitiveTransportType:(NSString*)value;




- (NSString*)primitiveTripDescription;
- (void)setPrimitiveTripDescription:(NSString*)value;





- (NSMutableSet*)primitiveModes;
- (void)setPrimitiveModes:(NSMutableSet*)value;



- (NSMutableSet*)primitiveSamples;
- (void)setPrimitiveSamples:(NSMutableSet*)value;


@end
