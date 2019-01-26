//
//  VehicleViewModel.h
//  iOSCodingChallenge
//
//  Created by MAC MINI on 27/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOSCodingChallenge-Swift.h"
//#import "NetworkManager.swift"

NS_ASSUME_NONNULL_BEGIN

@interface VehicleViewModel : NSObject {
    void (^_completionHandler)(int param);
}
- (void) getAllVehicleListWithCompletionHandler:(void(^)(int))handler;

@end

NS_ASSUME_NONNULL_END
