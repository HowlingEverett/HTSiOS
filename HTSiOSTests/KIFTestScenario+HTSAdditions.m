//
//  KIFTestScenario+HTSAdditions.m
//  HTSiOS
//
//  Created by Justin Marrington on 17/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "KIFTestScenario+HTSAdditions.h"
#import "KIFTestStep.h"

@implementation KIFTestScenario (HTSAdditions)

+ (id)scenarioToSwitchToTabTwo
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can switch between the two basic tabs."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Item 2"]];
    
    // Verify that switch succeeded
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"It's working!"]];
    
    return scenario;
}

@end
