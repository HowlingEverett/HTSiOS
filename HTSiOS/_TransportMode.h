// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TransportMode.h instead.

#import <CoreData/CoreData.h>


extern const struct TransportModeAttributes {
	__unsafe_unretained NSString *mode;
} TransportModeAttributes;

extern const struct TransportModeRelationships {
	__unsafe_unretained NSString *trip;
} TransportModeRelationships;

extern const struct TransportModeFetchedProperties {
} TransportModeFetchedProperties;

@class Trip;



@interface TransportModeID : NSManagedObjectID {}
@end

@interface _TransportMode : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TransportModeID*)objectID;




@property (nonatomic, strong) NSString* mode;


//- (BOOL)validateMode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Trip* trip;

//- (BOOL)validateTrip:(id*)value_ error:(NSError**)error_;





@end

@interface _TransportMode (CoreDataGeneratedAccessors)

@end

@interface _TransportMode (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveMode;
- (void)setPrimitiveMode:(NSString*)value;





- (Trip*)primitiveTrip;
- (void)setPrimitiveTrip:(Trip*)value;


@end
