// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Trip.m instead.

#import "_Trip.h"

const struct TripAttributes TripAttributes = {
	.date = @"date",
	.duration = @"duration",
	.isExported = @"isExported",
	.sectionIdentifier = @"sectionIdentifier",
	.surveyId = @"surveyId",
	.tripDescription = @"tripDescription",
};

const struct TripRelationships TripRelationships = {
	.modes = @"modes",
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
	
	if ([key isEqualToString:@"durationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"duration"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"isExportedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isExported"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"surveyIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"surveyId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic date;






@dynamic duration;



- (float)durationValue {
	NSNumber *result = [self duration];
	return [result floatValue];
}

- (void)setDurationValue:(float)value_ {
	[self setDuration:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDurationValue {
	NSNumber *result = [self primitiveDuration];
	return [result floatValue];
}

- (void)setPrimitiveDurationValue:(float)value_ {
	[self setPrimitiveDuration:[NSNumber numberWithFloat:value_]];
}





@dynamic isExported;



- (BOOL)isExportedValue {
	NSNumber *result = [self isExported];
	return [result boolValue];
}

- (void)setIsExportedValue:(BOOL)value_ {
	[self setIsExported:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsExportedValue {
	NSNumber *result = [self primitiveIsExported];
	return [result boolValue];
}

- (void)setPrimitiveIsExportedValue:(BOOL)value_ {
	[self setPrimitiveIsExported:[NSNumber numberWithBool:value_]];
}





@dynamic sectionIdentifier;






@dynamic surveyId;



- (int16_t)surveyIdValue {
	NSNumber *result = [self surveyId];
	return [result shortValue];
}

- (void)setSurveyIdValue:(int16_t)value_ {
	[self setSurveyId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSurveyIdValue {
	NSNumber *result = [self primitiveSurveyId];
	return [result shortValue];
}

- (void)setPrimitiveSurveyIdValue:(int16_t)value_ {
	[self setPrimitiveSurveyId:[NSNumber numberWithShort:value_]];
}





@dynamic tripDescription;






@dynamic modes;

	
- (NSMutableSet*)modesSet {
	[self willAccessValueForKey:@"modes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"modes"];
  
	[self didAccessValueForKey:@"modes"];
	return result;
}
	

@dynamic samples;

	
- (NSMutableSet*)samplesSet {
	[self willAccessValueForKey:@"samples"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"samples"];
  
	[self didAccessValueForKey:@"samples"];
	return result;
}
	






@end
