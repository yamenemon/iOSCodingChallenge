//
//  VehicleListViewController.m
//  iOSCodingChallenge
//
//  Created by MAC MINI on 26/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import "VehicleListViewController.h"
#import <iOSCodingChallenge-Swift.h>
#import "VehicleListCell.h"
#import "MBProgressHUD.h"


@interface VehicleListViewController()
@property (weak, nonatomic) IBOutlet UITableView *vehicleTableView;
@property (strong, nonatomic) NSMutableArray *tableData;
@end

@implementation VehicleListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = Constants.VEHICAL_LIST_TITLE;
    [self getAllVehicles];
    
}
-(void)getAllVehicles{
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    Webservice *service = [[Webservice alloc] init];
    [service loadVehicleWhileUserChangePositionWithNorthEast:CLLocationCoordinate2DMake(Constants.LAT1, Constants.LON1) southWest:CLLocationCoordinate2DMake(Constants.LAT2, Constants.LON2) onSuccess:^(id dataArr) {
        VehicleListViewModel *modelClass = [[VehicleListViewModel alloc] init];
        self.tableData = [modelClass tableDataSoring:dataArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:window  animated:YES];
            [self.vehicleTableView reloadData];
        });
    } onFailure:^(NSError * err) {
        if (err) {
            NSLog(@"Error occured");
            Singleton *global = [Singleton sharedInstance];
            [global showAlertWithControllerTitle:Constants.ALERT_SERVER_ERROR alertCancelTitle:Constants.ALERT_SERVER_OK alertMessage:Constants.ALERT_SERVER_MESSAGE];
        }
    }];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    VehicleListCell *cell = [tableView dequeueReusableCellWithIdentifier:Constants.TABLE_CELL_IDENTIFIER];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:Constants.TABLE_CELL_IDENTIFIER owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSMutableArray *temp = [_tableData objectAtIndex:indexPath.section];
    Vehicle *tempVehicle = [temp objectAtIndex:indexPath.row];
    cell.vehicleId.text = [NSString stringWithFormat:@"%.00f",tempVehicle.vehicleId];
    cell.fleettype.text = [NSString stringWithFormat:@"%@",tempVehicle.fleetType];
    cell.heading.text = [NSString stringWithFormat:@"%f",tempVehicle.heading];
    cell.coordinate.text = [NSString stringWithFormat:@"Lat: %f %@  Lon: %f %@  ",tempVehicle.coordinate.latitude,Constants.DEGREE_SIGN,tempVehicle.coordinate.longitude,Constants.DEGREE_SIGN];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_tableData objectAtIndex:section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Constants.TABLEVIEW_CELL_HEIGHT;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Singleton *global = [Singleton sharedInstance];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,40)];
    headerView.backgroundColor = [global hexStringToUIColorWithHex:@"0facd3b"];
    UILabel *headerTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width - 10, 40)];
    headerTextLabel.backgroundColor = [global hexStringToUIColorWithHex:@"0facd3b"];
    headerTextLabel.textColor = [UIColor whiteColor];
    headerTextLabel.font = [UIFont boldSystemFontOfSize:18];
    NSMutableArray *temp = [_tableData objectAtIndex:section];
    Vehicle *tempVehicle = [temp objectAtIndex:0];
    headerTextLabel.text = [NSString stringWithFormat:@"Vehicle Type : %@",tempVehicle.fleetType];
    [headerView addSubview:headerTextLabel];
    return headerView;
}
@end
