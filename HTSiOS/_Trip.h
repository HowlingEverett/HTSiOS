// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Trip.h instead.

#import <CoreData/CoreData.h>


extern const struct TripAttributes {
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *transportType;
	__unsafe_unretained NSString *tripDescription;
} TripAttributes;

extern const struct TripRelationships {
	__unsafe_unretained NSString *samples;
} TripRelationships;

extern const struct TripFetchedProperties {
} TripFetchedProperties;

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




@property (nonatomic, strong) NSString* transportType;


//- (BOOL)validateTransportType:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* tripDescription;


//- (BOOL)validateTripDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* samples;

- (NSMutableSet*)samplesSet;





@end

@interface _Trip (CoreDataGeneratedAccessors)

- (void)addSamples:(NSSet*)value_;
- (void)removeSamples:(NSSet*)value_;
- (void)addSamplesObject:(GeoSample*)value_;
- (void)removeSamplesObject:(GeoSample*)value_;

@end

@interface _Trip (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSString*)primitiveTransportType;
- (void)setPrimitiveTransportType:(NSString*)value;




- (NSString*)primitiveTripDescription;
- (void)setPrimitiveTripDescription:(NSString*)value;





- (NSMutableSet*)primitiveSamples;
- (void)setPrimitiveSamples:(NSMutableSet*)value;


@end
