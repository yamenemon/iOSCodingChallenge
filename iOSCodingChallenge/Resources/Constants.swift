//
//  Constants.swift
//  iOSCodingChallenge
//
//  Created by MAC MINI on 25/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import Foundation

@objc class Constants: NSObject {
    
    @objc public static var base_url = "https://fake-poi-api.mytaxi.com/"
    @objc public static var VEHICAL_LIST_TITLE = "Nearby Vehicles"
    //https://fake-poi-api.mytaxi.com/?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891
    @objc public static var LAT1 = 53.394655
    @objc public static var LON1 = 9.757589
    @objc public static var LAT2 = 53.694865
    @objc public static var LON2 = 10.099891
    @objc public static var TABLE_CELL_IDENTIFIER = "VehicleListCell"
    @objc public static var DEGREE_SIGN = "\u{00B0}"
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }
    
}
