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
    self.title = @"Vehicle List";
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self getAllVehicles];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:window  animated:YES];
            [self.vehicleTableView reloadData];
        });
    });

}
-(void)getAllVehicles{
        
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"%@?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891",Constants.base_url];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"json: %@", json);
    
    
    if(error) { /* JSON was malformed, act appropriately here */ }
    
    if([json isKindOfClass:[NSDictionary class]])
    {
        NSArray *results = [json valueForKey:@"poiList"];
        _tableData = [[NSMutableArray alloc] init];
        for (int i = 0; i<results.count; i++) {
            Vehicle *object = [[Vehicle alloc] init];
            object.coordinate.latitude = [[[ [results objectAtIndex:i] valueForKey:@"coordinate"] valueForKey:@"latitude"] doubleValue];
            object.coordinate.longitude = [[[ [results objectAtIndex:i] valueForKey:@"coordinate"] valueForKey:@"longitude"] doubleValue];
            object.fleetType = [ [results objectAtIndex:i] valueForKey:@"fleetType"];
            object.heading = [ [results objectAtIndex:i] valueForKey:@"heading"];
            object.vehicleId = [[[results objectAtIndex:i] valueForKey:@"id"] integerValue];
            [_tableData addObject:object];
        }
        
    }
    else
    {

    }
    
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"VehicleListCell";
    
    VehicleListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VehicleListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Vehicle *tempVehicle = [_tableData objectAtIndex:indexPath.row];
    cell.vehicleId.text = [NSString stringWithFormat:@"%d",tempVehicle.vehicleId];
    cell.fleettype.text = [NSString stringWithFormat:@"%@",tempVehicle.fleetType];
    cell.heading.text = [NSString stringWithFormat:@"%@",tempVehicle.heading];
    cell.coordinate.text = [NSString stringWithFormat:@"Lat: %f Lon: %f ",tempVehicle.coordinate.latitude,tempVehicle.coordinate.longitude];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


@end
