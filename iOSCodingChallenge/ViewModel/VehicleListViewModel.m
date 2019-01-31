//
//  VehicleListViewModel.m
//  iOSCodingChallenge
//
//  Created by MAC MINI on 31/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import "VehicleListViewModel.h"
#import "Vehicle.h"

@implementation VehicleListViewModel


-(NSMutableArray*) tableDataSoring:(NSDictionary*)dictionaryData {
    
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    NSMutableArray *taxiData = [[NSMutableArray alloc] init];
    NSMutableArray *poolingData = [[NSMutableArray alloc] init];
    for (id object in dictionaryData) {
        
        Vehicle *vehicle = [[Vehicle alloc] init];
        NSDictionary *dic = [object valueForKey:@"coordinate"];
        vehicle.coordinate.latitude = [[dic valueForKey:@"latitude"] doubleValue];
        vehicle.coordinate.longitude = [[dic valueForKey:@"longitude"] doubleValue];
        vehicle.heading = [[object valueForKey:@"heading"] doubleValue];
        vehicle.vehicleId = [[object valueForKey:@"id"] doubleValue];
        vehicle.fleetType = [object valueForKey:@"fleetType"];
        if ([vehicle.fleetType isEqualToString:@"TAXI"]) {
            [taxiData addObject:vehicle];
        }else {
            [poolingData addObject:vehicle];
        }
    }
    [tableData insertObject:taxiData atIndex:0];
    [tableData insertObject:poolingData atIndex:1];
    return tableData;
}
@end
