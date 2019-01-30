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
    
    @objc public class func sharedInstance() -> Singleton {
        return Singleton._singletonInstance
    }
    @objc public func showAlert(controllerTitle:String, alertCancelTitle:String, alertMessage:String) -> Void {
        
        let alert = UIAlertController(title: controllerTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: alertCancelTitle, style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

    }
    
    @objc public func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
