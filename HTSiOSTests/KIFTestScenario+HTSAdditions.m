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

+ (id)scenarioToStartNewTrip
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that when a user taps the Start button that trip logging is enabled."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Today"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Trip Start Button"]];
    
    // Verify that location services has started by catching the notification
    [scenario addStep:[KIFTestStep stepToWaitForNotificationName:@"new_location_found" object:nil]];
    // Verify that the Start/Stop button has switched to "Stop"
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Trip Start Button" value:<#(NSString *)#> traits:<#(UIAccessibilityTraits)#>
    
    return scenario;
}

@end
