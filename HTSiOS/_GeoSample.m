// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GeoSample.m instead.

#import "_GeoSample.h"

const struct GeoSampleAttributes GeoSampleAttributes = {
	.heading = @"heading",
	.heading_accuracy = @"heading_accuracy",
	.latitude = @"latitude",
	.location_accuracy = @"location_accuracy",
	.longitude = @"longitude",
	.speed = @"speed",
	.timestamp = @"timestamp",
};

const struct GeoSampleRelationships GeoSampleRelationships = {
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
	if ([key isEqualToString:@"heading_accuracyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"heading_accuracy"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"location_accuracyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"location_accuracy"];
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



- (float)headingValue {
	NSNumber *result = [self heading];
	return [result floatValue];
}

- (void)setHeadingValue:(float)value_ {
	[self setHeading:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveHeadingValue {
	NSNumber *result = [self primitiveHeading];
	return [result floatValue];
}

- (void)setPrimitiveHeadingValue:(float)value_ {
	[self setPrimitiveHeading:[NSNumber numberWithFloat:value_]];
}





@dynamic heading_accuracy;



- (float)heading_accuracyValue {
	NSNumber *result = [self heading_accuracy];
	return [result floatValue];
}

- (void)setHeading_accuracyValue:(float)value_ {
	[self setHeading_accuracy:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveHeading_accuracyValue {
	NSNumber *result = [self primitiveHeading_accuracy];
	return [result floatValue];
}

- (void)setPrimitiveHeading_accuracyValue:(float)value_ {
	[self setPrimitiveHeading_accuracy:[NSNumber numberWithFloat:value_]];
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





@dynamic location_accuracy;



- (float)location_accuracyValue {
	NSNumber *result = [self location_accuracy];
	return [result floatValue];
}

- (void)setLocation_accuracyValue:(float)value_ {
	[self setLocation_accuracy:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLocation_accuracyValue {
	NSNumber *result = [self primitiveLocation_accuracy];
	return [result floatValue];
}

- (void)setPrimitiveLocation_accuracyValue:(float)value_ {
	[self setPrimitiveLocation_accuracy:[NSNumber numberWithFloat:value_]];
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



- (float)speedValue {
	NSNumber *result = [self speed];
	return [result floatValue];
}

- (void)setSpeedValue:(float)value_ {
	[self setSpeed:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveSpeedValue {
	NSNumber *result = [self primitiveSpeed];
	return [result floatValue];
}

- (void)setPrimitiveSpeedValue:(float)value_ {
	[self setPrimitiveSpeed:[NSNumber numberWithFloat:value_]];
}





@dynamic timestamp;











@end
