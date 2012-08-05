#import "SurveyResponse.h"

@implementation SurveyResponse

// Custom logic goes here.
- (NSDictionary *)toDict
{
    return @{ @"group_name" : self.groupName, @"question": self.questionTitle, @"answer": self.questionResponse };
}

@end
