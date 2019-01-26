//
//  VehicleListCell.h
//  iOSCodingChallenge
//
//  Created by MAC MINI on 27/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VehicleListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *vehicleId;
@property (weak, nonatomic) IBOutlet UILabel *fleettype;
@property (weak, nonatomic) IBOutlet UILabel *heading;
@property (weak, nonatomic) IBOutlet UILabel *coordinate;

@end

NS_ASSUME_NONNULL_END
