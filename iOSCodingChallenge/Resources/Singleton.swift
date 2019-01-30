//
//  Singleton.swift
//  iOSCodingChallenge
//
//  Created by Binate Solutions on 27/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import Foundation

@objc class Singleton: NSObject {
    
    static var locationArray: Array<Any>?
  
    static let _singletonInstance = Singleton()
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }
    
    public class func sharedInstance() -> Singleton {
        return Singleton._singletonInstance
    }

}
