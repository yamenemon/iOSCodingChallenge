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
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }
    
}
