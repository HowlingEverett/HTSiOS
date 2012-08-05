// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SurveyResponse.m instead.

#import "_SurveyResponse.h"

const struct SurveyResponseAttributes SurveyResponseAttributes = {
	.groupName = @"groupName",
	.questionResponse = @"questionResponse",
	.questionTitle = @"questionTitle",
};

const struct SurveyResponseRelationships SurveyResponseRelationships = {
};

const struct SurveyResponseFetchedProperties SurveyResponseFetchedProperties = {
};

@implementation SurveyResponseID
@end

@implementation _SurveyResponse

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SurveyResponse" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SurveyResponse";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SurveyResponse" inManagedObjectContext:moc_];
}

- (SurveyResponseID*)objectID {
	return (SurveyResponseID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic groupName;






@dynamic questionResponse;






@dynamic questionTitle;











@end
