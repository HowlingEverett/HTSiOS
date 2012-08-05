// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SurveyResponse.h instead.

#import <CoreData/CoreData.h>


extern const struct SurveyResponseAttributes {
	__unsafe_unretained NSString *groupName;
	__unsafe_unretained NSString *questionResponse;
	__unsafe_unretained NSString *questionTitle;
} SurveyResponseAttributes;

extern const struct SurveyResponseRelationships {
} SurveyResponseRelationships;

extern const struct SurveyResponseFetchedProperties {
} SurveyResponseFetchedProperties;






@interface SurveyResponseID : NSManagedObjectID {}
@end

@interface _SurveyResponse : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SurveyResponseID*)objectID;




@property (nonatomic, strong) NSString* groupName;


//- (BOOL)validateGroupName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* questionResponse;


//- (BOOL)validateQuestionResponse:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* questionTitle;


//- (BOOL)validateQuestionTitle:(id*)value_ error:(NSError**)error_;






@end

@interface _SurveyResponse (CoreDataGeneratedAccessors)

@end

@interface _SurveyResponse (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveGroupName;
- (void)setPrimitiveGroupName:(NSString*)value;




- (NSString*)primitiveQuestionResponse;
- (void)setPrimitiveQuestionResponse:(NSString*)value;




- (NSString*)primitiveQuestionTitle;
- (void)setPrimitiveQuestionTitle:(NSString*)value;




@end
