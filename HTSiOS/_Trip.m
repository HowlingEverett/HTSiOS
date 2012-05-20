// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Trip.m instead.

#import "_Trip.h"

const struct TripAttributes TripAttributes = {
	.date = @"date",
	.transportType = @"transportType",
	.tripDescription = @"tripDescription",
};

const struct TripRelationships TripRelationships = {
	.samples = @"samples",
};

const struct TripFetchedProperties TripFetchedProperties = {
};

@implementation TripID
@end

@implementation _Trip

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Trip";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Trip" inManagedObjectContext:moc_];
}

- (TripID*)objectID {
	return (TripID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic date;






@dynamic transportType;






@dynamic tripDescription;






@dynamic samples;

	
- (NSMutableSet*)samplesSet {
	[self willAccessValueForKey:@"samples"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"samples"];
  
	[self didAccessValueForKey:@"samples"];
	return result;
}
	






@end
