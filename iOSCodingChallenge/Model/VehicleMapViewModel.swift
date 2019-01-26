//
//  VehicleMapViewModel.swift
//  iOSCodingChallenge
//
//  Created by MAC MINI on 25/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import Foundation
import MapKit

public class VehicleMapViewModel: NSObject {
    
    public let coordinate: CLLocationCoordinate2D
    public let name: String
    public let carImage: UIImage
    public let fleeType: String
    
    public init(coordinate: CLLocationCoordinate2D,
                         name: String,
                         image: UIImage,
                         fleeType: String) {
        self.coordinate = coordinate
        self.name = name
        self.carImage = image
        self.fleeType = fleeType
    }
}

extension VehicleMapViewModel: MKAnnotation {
    
    public var title: String? {
        return name
    }
    
    public var subtitle: String? {
        return fleeType
    }
}
