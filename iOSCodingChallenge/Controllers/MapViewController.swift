//
//  MapViewController.swift
//  iOSCodingChallenge
//
//  Created by MAC MINI on 25/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private var cars: [VehicleMapViewModel] = [] 
    private let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view.
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerMap(on: userLocation.coordinate)
    }
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 3000
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        displayingVehicleInMap()
    }
    
    private func displayingVehicleInMap(){
        let coordinate = mapView.userLocation.coordinate
        guard coordinate.latitude != 0 && coordinate.longitude != 0 else {
            return
        }
        let image: UIImage
        image = UIImage(named: "carImage")!
        // 23.777176, 90.399452
        let tempCar = VehicleMapViewModel(coordinate: CLLocationCoordinate2D(latitude: 90.399452, longitude: 23.777176), name: "Lumburgini", image: image, fleeType: "Taxi")
        DispatchQueue.main.async {
            self.addAnnotations(model: tempCar)
        }
        
    }
    
    private func addAnnotations(model:VehicleMapViewModel) {
        
            let coordinate = CLLocationCoordinate2D(latitude: model.coordinate.latitude,
                                                    longitude: model.coordinate.longitude)
            let name = model.name
            
            let annotation = VehicleMapViewModel(coordinate: coordinate, name: name, image: UIImage(named: "carImage")!, fleeType: model.fleeType)
            mapView.addAnnotation(annotation)
        
    }
    
    public func mapView(_ mapView: MKMapView,
                        viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let viewModel = annotation as? VehicleMapViewModel else {
            return nil
        }
        
        let identifier = "vehicleView"
        let annotationView: MKAnnotationView
        if let existingView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = existingView
        } else {
            annotationView = MKAnnotationView(annotation: viewModel,
                                              reuseIdentifier: identifier)
        }
        annotationView.image = UIImage(named: "carImage")!
        annotationView.canShowCallout = true
        return annotationView
    }
}

