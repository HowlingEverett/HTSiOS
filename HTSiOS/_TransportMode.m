// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TransportMode.m instead.

#import "_TransportMode.h"

const struct TransportModeAttributes TransportModeAttributes = {
	.mode = @"mode",
};

const struct TransportModeRelationships TransportModeRelationships = {
	.trip = @"trip",
};

const struct TransportModeFetchedProperties TransportModeFetchedProperties = {
};

@implementation TransportModeID
@end

@implementation _TransportMode

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TransportMode" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TransportMode";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TransportMode" inManagedObjectContext:moc_];
}

- (TransportModeID*)objectID {
	return (TransportModeID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic mode;






@dynamic trip;

	






@end
