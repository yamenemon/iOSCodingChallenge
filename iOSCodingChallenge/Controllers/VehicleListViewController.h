//
//  VehicleListViewController.h
//  iOSCodingChallenge
//
//  Created by MAC MINI on 26/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicle.h"
#import "VehicleListViewModel.h"
@class Constants;
@class Extension;
@class Webservice;

NS_ASSUME_NONNULL_BEGIN

@interface VehicleListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@end

NS_ASSUME_NONNULL_END
