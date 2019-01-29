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
    private var geofenceRegionCenter: CLLocationCoordinate2D!
    private var tableData: Array<Vehicle>!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let merc = SphericalMercator()
        
        locationManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view.
        locationManager.stopUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 5.0;
//        locationManager.startUpdatingLocation()
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        locationManager.pausesLocationUpdatesAutomatically = false
        

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
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
////        let geocoder = CLGeocoder()
////        geocoder.reverseGeocodeLocation(locationManager.location!) { (placemarksArray, error) in
////
////            if (placemarksArray?.count)! > 0 {
////                let placemark = placemarksArray?.first
////                print(placemark?.locality ?? "Humberg")
////            }
////        }
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        geofenceRegionCenter = locValue
//        geofenceRegionCenter?.latitude = (locationManager.location!.coordinate.latitude)
//        geofenceRegionCenter?.longitude = (locationManager.location!.coordinate.longitude)
//        print(geofenceRegionCenter!)
//    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//            MBProgressHUD.showAdded(to: window, animated: true)
//        }
        print("calling")
        DispatchQueue.main.async {
            guard let _: CLLocationCoordinate2D = self.locationManager.location?.coordinate else { return }
            self.centerMap(on: (self.locationManager.location?.coordinate)!)
            
            let northEast = mapView.convert(CGPoint(x: mapView.bounds.width, y: 0), toCoordinateFrom: mapView)
            let southWest = mapView.convert(CGPoint(x: 0, y: mapView.bounds.height), toCoordinateFrom: mapView)
            
            print("Northest : \(northEast) and Southwest: \(southWest)")
            
            let url_string = "https://fake-poi-api.mytaxi.com/?p2Lat=\(northEast.latitude)&p1Lon=\(northEast.longitude)&p1Lat=\(southWest.latitude)&p2Lon=\(southWest.longitude)"
            
            let myUrl = NSURL(string: url_string)
            let request = NSMutableURLRequest(url: myUrl! as URL)
            request.httpMethod = "GET"
            
            // Excute HTTP Request
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
                        
                        // Print out dictionary
//                        print(convertedJsonIntoDict)
                        guard let locValue: CLLocationCoordinate2D = self.locationManager.location?.coordinate else { return }
                        self.geofenceRegionCenter = locValue
                        self.centerMap(on: self.geofenceRegionCenter)
                        
                        
                        let results = convertedJsonIntoDict["poiList"] as! [NSDictionary]
                        self.tableData = [Vehicle]()
                        for object in results{
                            let vehicle = Vehicle()
                            let dic = object["coordinate"] as! NSDictionary
                            vehicle.coordinate.latitude =  dic["latitude"] as! Double
                            vehicle.coordinate.longitude = dic["longitude"] as! Double
                            self.tableData.append(vehicle)
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
        locationManager.stopUpdatingLocation()
    }
    

    private func centerMap(on coordinate: CLLocationCoordinate2D) {
//        let regionRadius: CLLocationDistance = 5000
//        let coordinateRegion = MKCoordinateRegion(center: coordinate,
//                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//        mapView.setRegion(coordinateRegion, animated: true)
        
        let serialQueue = DispatchQueue(label: "com.test.mySerialQueue")
        serialQueue.sync {
            // code
            displayingVehicleInMap()
        }
    }
    
    private func displayingVehicleInMap(){
//        let coordinate = mapView.userLocation.coordinate
//        guard coordinate.latitude != 0 && coordinate.longitude != 0 else {
//            return
//        }
//        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//            MBProgressHUD.hide(for: window, animated: true)
//        }
        if self.tableData != nil {
            var coords = NSMutableArray.init() as! [CLLocation]
            for object:Vehicle in self.tableData {
//                print("\(object.coordinate.latitude) \(object.coordinate.longitude) ")
                let lat: Double = Double("\(object.coordinate.latitude)")!
                let lon: Double = Double("\(object.coordinate.longitude)")!
                coords.append(CLLocation(latitude: lat, longitude:lon))
            }
            addAnnotations(coords: coords)
        }
        
    }
    func addAnnotations(coords: [CLLocation]){
        DispatchQueue.main.async {

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
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil;
        }else{
//            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//                MBProgressHUD.hide(for: window, animated: true)
//            }
            self.locationManager.stopUpdatingLocation()
            let pinIdent = "Pin";
            var pinView: MKPinAnnotationView;
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation;
                pinView = dequeuedView;
            }else{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent);
                
            }
            pinView.image = UIImage(named:"carImage")

            return pinView;
        }
    }
}

