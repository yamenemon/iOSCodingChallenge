//
//  Vehicle.h
//  iOSCodingChallenge
//
//  Created by MAC MINI on 26/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coordinate.h"
NS_ASSUME_NONNULL_BEGIN

@interface Vehicle : NSObject
@property (retain) Coordinate *coordinate;
@property (retain) NSString* fleetType;
@property (retain) NSString* heading;
@property (assign) double vehicleId;
@end

NS_ASSUME_NONNULL_END
