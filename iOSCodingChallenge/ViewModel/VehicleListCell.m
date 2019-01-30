//
//  VehicleListCell.m
//  iOSCodingChallenge
//
//  Created by MAC MINI on 27/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import "VehicleListCell.h"
#import <iOSCodingChallenge-Swift.h>

@implementation VehicleListCell
@synthesize vehicleId,fleettype,heading,coordinate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.backgroundColor = UIColor.clearColor.CGColor;
    self.cellImage.layer.cornerRadius = CGRectGetWidth(self.cellImage.frame)/6.0f;
    Singleton *global = [Singleton sharedInstance];
    self.cellImage.layer.borderColor = [global hexStringToUIColorWithHex:@"0x454756"].CGColor;
    self.cellImage.layer.borderWidth = 1.5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
