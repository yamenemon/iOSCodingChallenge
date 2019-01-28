//
//  MapViewController.swift
//  iOSCodingChallenge
//
//  Created by MAC MINI on 25/1/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD
import Alamofire

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
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
        locationManager.stopUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 5.0;
        locationManager.startUpdatingLocation()
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        locationManager.pausesLocationUpdatesAutomatically = false
        displayingVehicleInMap()
    }
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
    }
    func startReceivingSignificantLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The service is not available.
            return
        }
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locationManager.location!) { (placemarksArray, error) in
        
            if (placemarksArray?.count)! > 0 {
                let placemark = placemarksArray?.first
                print(placemark?.locality ?? "Humberg")
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            MBProgressHUD.showAdded(to: window, animated: true)
        }
//        getUserCurrentCity()
        displayingVehicleInMap()

    }
    
    func getUserCurrentCity() {
        
        let _: String = "your_server_url"
        
//        Alamofire.request(todosEndpoint, method: .get, encoding: JSONEncoding.default)
//            .responseJSON { response in
//                debugPrint(response)
//
//                if let data = response.result.value{
//                    // Response type-1
//                    if  (data as? [[String : AnyObject]]) != nil{
//                        print("data_1: \(data)")
//                    }
//                    // Response type-2
//                    if  (data as? [String : AnyObject]) != nil{
//                        print("data_2: \(data)")
//                    }
//                }
//        }
    }
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 3000
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        displayingVehicleInMap()
    }
    
    private func displayingVehicleInMap(){
//        let coordinate = mapView.userLocation.coordinate
//        guard coordinate.latitude != 0 && coordinate.longitude != 0 else {
//            return
//        }
        
        let coords = [  CLLocation(latitude: 53.44176110543172, longitude: 9.780926262977344),
                        CLLocation(latitude: 53.44176110543172, longitude: 9.863625795728705),
                        CLLocation(latitude: 53.45114443968461, longitude:10.01379149784659),
                        CLLocation(latitude: 53.54326771329314, longitude:9.802020967514203),
                        CLLocation(latitude: 53.58529295190684, longitude:9.802418494033601)
        ];
        addAnnotations(coords: coords)
        
    }
    func addAnnotations(coords: [CLLocation]){
        for coord in coords{
            let CLLCoordType = CLLocationCoordinate2D(latitude: coord.coordinate.latitude,
                                                      longitude: coord.coordinate.longitude);
            let anno = MKPointAnnotation()
            
            anno.coordinate = CLLCoordType
            anno.title = "Test annotation"
            self.mapView.addAnnotation(anno)
        }
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil;
        }else{
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                MBProgressHUD.hide(for: window, animated: true)
            }
            let pinIdent = "Pin";
            var pinView: MKPinAnnotationView;
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation;
                pinView = dequeuedView;
            }else{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent);
                
            }
            return pinView;
        }
    }
}

