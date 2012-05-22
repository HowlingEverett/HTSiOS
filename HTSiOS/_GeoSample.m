// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GeoSample.m instead.

#import "_GeoSample.h"

const struct GeoSampleAttributes GeoSampleAttributes = {
	.heading = @"heading",
	.headingAccuracy = @"headingAccuracy",
	.latitude = @"latitude",
	.locationAccuracy = @"locationAccuracy",
	.longitude = @"longitude",
	.speed = @"speed",
	.timestamp = @"timestamp",
};

const struct GeoSampleRelationships GeoSampleRelationships = {
	.trip = @"trip",
};

const struct GeoSampleFetchedProperties GeoSampleFetchedProperties = {
};

@implementation GeoSampleID
@end

@implementation _GeoSample

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"GeoSample" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"GeoSample";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"GeoSample" inManagedObjectContext:moc_];
}

- (GeoSampleID*)objectID {
	return (GeoSampleID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"headingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"heading"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"headingAccuracyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"headingAccuracy"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"locationAccuracyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"locationAccuracy"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"speedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"speed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic heading;



- (double)headingValue {
	NSNumber *result = [self heading];
	return [result doubleValue];
}

- (void)setHeadingValue:(double)value_ {
	[self setHeading:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveHeadingValue {
	NSNumber *result = [self primitiveHeading];
	return [result doubleValue];
}

- (void)setPrimitiveHeadingValue:(double)value_ {
	[self setPrimitiveHeading:[NSNumber numberWithDouble:value_]];
}





@dynamic headingAccuracy;



- (double)headingAccuracyValue {
	NSNumber *result = [self headingAccuracy];
	return [result doubleValue];
}

- (void)setHeadingAccuracyValue:(double)value_ {
	[self setHeadingAccuracy:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveHeadingAccuracyValue {
	NSNumber *result = [self primitiveHeadingAccuracy];
	return [result doubleValue];
}

- (void)setPrimitiveHeadingAccuracyValue:(double)value_ {
	[self setPrimitiveHeadingAccuracy:[NSNumber numberWithDouble:value_]];
}





@dynamic latitude;



- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}





@dynamic locationAccuracy;



- (double)locationAccuracyValue {
	NSNumber *result = [self locationAccuracy];
	return [result doubleValue];
}

- (void)setLocationAccuracyValue:(double)value_ {
	[self setLocationAccuracy:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLocationAccuracyValue {
	NSNumber *result = [self primitiveLocationAccuracy];
	return [result doubleValue];
}

- (void)setPrimitiveLocationAccuracyValue:(double)value_ {
	[self setPrimitiveLocationAccuracy:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude;



- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}





@dynamic speed;



- (double)speedValue {
	NSNumber *result = [self speed];
	return [result doubleValue];
}

- (void)setSpeedValue:(double)value_ {
	[self setSpeed:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveSpeedValue {
	NSNumber *result = [self primitiveSpeed];
	return [result doubleValue];
}

- (void)setPrimitiveSpeedValue:(double)value_ {
	[self setPrimitiveSpeed:[NSNumber numberWithDouble:value_]];
}





@dynamic timestamp;






@dynamic trip;

	






@end
