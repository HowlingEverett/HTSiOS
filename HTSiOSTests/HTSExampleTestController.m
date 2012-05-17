//
//  HTSExampleTestController.m
//  HTSiOS
//
//  Created by Justin Marrington on 17/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSExampleTestController.h"
#import "KIFTestScenario+HTSAdditions.h"

@implementation HTSExampleTestController

- (void)initializeScenarios
{
    [self addScenario:[KIFTestScenario scenarioToSwitchToTabTwo]];
}

@end
