//
//  VehicleViewModel.m
//  iOSCodingChallenge
//
//  Created by MAC MINI on 27/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import "VehicleViewModel.h"

@implementation VehicleViewModel

- (void) getAllVehicleListWithCompletionHandler:(void(^)(int))handler
{

    _completionHandler = [handler copy];
    
    // Do stuff, possibly asynchronously...
    int result = 5 + 3;
    
    // Call completion handler.
    _completionHandler(result);
    
    // Clean up.
    _completionHandler = nil;
    
}

@end
