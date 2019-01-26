//
//  VehicleListViewController.m
//  iOSCodingChallenge
//
//  Created by MAC MINI on 26/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import "VehicleListViewController.h"
#import "iOSCodingChallenge-Swift.h"

@interface VehicleListViewController(){
    NSMutableArray *jsonDataArr;
}
@property (weak, nonatomic) IBOutlet UITableView *vehicleTableView;
@property (strong, nonatomic) NSMutableArray *tableData;
@end

@implementation VehicleListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self getAllVehicles];
    _tableData = [NSMutableArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    

}
-(void)getAllVehicles{
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://fake-poi-api.mytaxi.com/?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891"];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    NSLog(@"json: %@", json);
    
    
    if(error) { /* JSON was malformed, act appropriately here */ }
    
    // the originating poster wants to deal with dictionaries;
    // assuming you do too then something like this is the first
    // validation step:
    if([json isKindOfClass:[NSDictionary class]])
    {
        NSArray *results = [json valueForKey:@"poiList"];
//        NSLog(@"%@",results);
        jsonDataArr = [[NSMutableArray alloc] init];
        for (int i = 0; i<results.count; i++) {
            Vehicle *object = [[Vehicle alloc] init];
//            object.coordinate.latitude = [[ [results objectAtIndex:i] valueForKey:@"coordinate"] valueForKey:@"latitude"];
            object.fleetType = [ [results objectAtIndex:i] valueForKey:@"fleetType"];
            object.heading = [ [results objectAtIndex:i] valueForKey:@"heading"];
//            object.vehicleId = (int)[results valueForKey:@"id"];
            [jsonDataArr addObject:object];
        }
        NSLog(@"%@",jsonDataArr);
        
        /* proceed with results as you like; the assignment to
         an explicit NSDictionary * is artificial step to get
         compile-time checking from here on down (and better autocompletion
         when editing). You could have just made object an NSDictionary *
         in the first place but stylistically you might prefer to keep
         the question of type open until it's confirmed */
        
    }
    else
    {
        /* there's no guarantee that the outermost object in a JSON
         packet will be a dictionary; if we get here then it wasn't,
         so 'object' shouldn't be treated as an NSDictionary; probably
         you need to report a suitable error condition */
    }
    
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [jsonDataArr objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [jsonDataArr count];
}



@end
