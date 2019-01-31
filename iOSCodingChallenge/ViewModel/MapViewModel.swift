//
//  MapViewModel.swift
//  iOSCodingChallenge
//
//  Created by MAC MINI on 30/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import Foundation
import CoreLocation


@objc public class MapViewModel: NSObject {
    
    
    func tableDataSorting(dictionaryData: [NSDictionary]) -> [Vehicle] {
        var tableData = [Vehicle]()
        for object in dictionaryData{
            let vehicle = Vehicle()
            let dic = object["coordinate"] as! NSDictionary
            vehicle.coordinate.latitude =  dic["latitude"] as! Double
            vehicle.coordinate.longitude = dic["longitude"] as! Double
            vehicle.fleetType = object["fleetType"] as! String
            vehicle.heading = object["heading"] as! Double
            vehicle.vehicleId = object["id"] as! Double
            tableData.append(vehicle)
        }
        return tableData
    }
    
}

