//
//  Webservice.swift
//  iOSCodingChallenge
//
//  Created by MAC MINI on 31/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import Foundation
import CoreLocation


@objc public class Webservice: NSObject {
    
    @objc public func loadVehicleWhileUserChangePosition(northEast: CLLocationCoordinate2D, southWest: CLLocationCoordinate2D, onSuccess success: @escaping (_ JSONArray: Any) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        
        print("Northest : \(northEast) and Southwest: \(southWest)")
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
                        success(results)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    failure(error)
                }
            }
            task.resume()
        }
    }
}


