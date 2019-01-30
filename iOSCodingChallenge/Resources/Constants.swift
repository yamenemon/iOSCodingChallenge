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
    @objc public static var LAT1 = 53.394655
    @objc public static var LON1 = 9.757589
    @objc public static var LAT2 = 53.694865
    @objc public static var LON2 = 10.099891
    @objc public static var TABLE_CELL_IDENTIFIER = "VehicleListCell"
    @objc public static var DEGREE_SIGN = "\u{00B0}"
    @objc public static var TABLEVIEW_CELL_HEIGHT = 100
    
    //MAP VIEW
    @objc public static var MAP_VIEW_TITLE = "Map"
    
    //Alert controller Message
    @objc public static var ALERT_SERVER_ERROR = "Server Error!"
    @objc public static var ALERT_SERVER_MESSAGE = "Maintanence Time.Please try again after some moments"
    @objc public static var ALERT_SERVER_OK = "OK"
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }
    
}
