//
//  Vehicle.m
//  iOSCodingChallenge
//
//  Created by MAC MINI on 26/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import "Vehicle.h"

@implementation Vehicle
@synthesize coordinate;
@synthesize fleetType;
@synthesize heading;
@synthesize vehicleId;

-(id)init{
    self = [super init];
    if (self) {
        coordinate = [[Coordinate alloc] init];
    }
    return self;
}

@end
