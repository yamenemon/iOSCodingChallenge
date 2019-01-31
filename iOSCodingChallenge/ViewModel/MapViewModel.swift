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
    
    @objc public func loadVehicleWhileUserChangePosition(northEast: CLLocationCoordinate2D, southWest: CLLocationCoordinate2D, onSuccess success: @escaping (_ JSON: Any) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        
            print("Northest : \(northEast) and Southwest: \(southWest)")
            var tableData = [Vehicle]()
        let url_string = "\(Constants.base_url)?p2Lat=\(northEast.latitude)&p1Lon=\(northEast.longitude)&p1Lat=\(southWest.latitude)&p2Lon=\(southWest.longitude)"
            print(url_string)
            let myUrl = NSURL(string: url_string)
            let request = NSMutableURLRequest(url: myUrl! as URL)
            request.httpMethod = "GET"
            // Excute HTTP Request
        
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                // Check for error
                if error != nil
                {
                    print("error=\(String(describing: error))")
                    return
                }
                
                // Convert server json response to NSDictionary
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
//                        print(convertedJsonIntoDict)
                        let results = convertedJsonIntoDict["poiList"] as! [NSDictionary]
                        for object in results{
                            let vehicle = Vehicle()
                            let dic = object["coordinate"] as! NSDictionary
                            vehicle.coordinate.latitude =  dic["latitude"] as! Double
                            vehicle.coordinate.longitude = dic["longitude"] as! Double
                            vehicle.fleetType = object["fleetType"] as! String
                            vehicle.heading = object["heading"] as! Double
                            vehicle.vehicleId = object["id"] as! Double
                            tableData.append(vehicle)
                        }
                        success(tableData)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    failure(error)
                }
            }
            task.resume()
        }
    }
    
//    @objc public func tableDataSorting(data: [NSDictionary]) -> [NSMutableArray]{
//        
//        var sortedArr = [AnyObject]()
////        for object in data{
////            if object["fleetType"] as? String == "TAXI" {
////                temp1.append(object as! Vehicle)
////            }
////            else{
////                temp2.append(object as! Vehicle)
////            }
////        }
////        sortedArr.insert(temp1 as AnyObject, at: 0)
////        sortedArr.insert(temp2 as AnyObject, at: 1)
////
////        return sortedArr as! [NSMutableArray]
//        
//        for object in data{
//            let text = object["fleetType"] as! String
//            if text == "TAXI" {
//                sortedArr.insert(object, at: 0)
//            }
//            else {
//                sortedArr.insert(object, at: 1)
//            }
//        }
//        return sortedArr as! [NSMutableArray]
//    }
}

