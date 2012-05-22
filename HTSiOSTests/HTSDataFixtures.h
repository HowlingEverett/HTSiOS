//
//  HTSDataFixtures.h
//  HTSiOS
//
//  Created by Justin Marrington on 21/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Trip;
@interface HTSDataFixtures : NSObject

+ (NSArray *)geoSamples;
+ (Trip *)tripWithSamples:(NSArray *)samples;
@end
