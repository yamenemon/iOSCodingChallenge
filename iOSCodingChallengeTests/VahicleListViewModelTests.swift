//
//  VahicleListViewModelTests.swift
//  iOSCodingChallengeTests
//
//  Created by MAC MINI on 31/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import XCTest
import CoreLocation
@testable import iOSCodingChallenge

class VahicleListViewModelTests: XCTestCase {

    var webservice: Webservice!
    var vehicleListModel: VehicleListViewModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        webservice = Webservice()
        vehicleListModel = VehicleListViewModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testValidJsonFormatOfAPI() {
        //https://fake-poi-api.mytaxi.com/?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891
        //        let promise = expectation(description: "Status code: 200")
        
        webservice.loadVehicleWhileUserChangePosition(northEast: CLLocationCoordinate2D(latitude: 53.394655,longitude: 9.757589), southWest: CLLocationCoordinate2D(latitude: 53.694865,longitude: 10.099891), onSuccess: { (response) in
            let data = self.vehicleListModel.tableDataSoring(response as! [AnyHashable : Any])
            XCTAssertTrue(data.count>0)
        }) { (err) in
            XCTFail("Error: \(err!.localizedDescription)")
        }
    }
    
}
