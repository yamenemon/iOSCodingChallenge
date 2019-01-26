//
//  VehicleListCell.m
//  iOSCodingChallenge
//
//  Created by MAC MINI on 27/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import "VehicleListCell.h"

@implementation VehicleListCell
@synthesize vehicleId,fleettype,heading,coordinate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
