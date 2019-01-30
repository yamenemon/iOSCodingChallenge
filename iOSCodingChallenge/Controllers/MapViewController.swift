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
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    private var cars: [VehicleMapViewModel] = [] 
    private var locationManager = CLLocationManager()
    private var geofenceRegionCenter: CLLocationCoordinate2D!
    private var tableData: Array<Vehicle>!
    var previousPosition:CLLocation! = nil
    var currentPosition: CLLocation! = nil
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
            mapView.isZoomEnabled = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.MAP_VIEW_TITLE;

        determineCurrentLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    func determineCurrentLocation()
    {
        // 2. setup locationManager
        locationManager.delegate = self;
//        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.distanceFilter = 100.0;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestAlwaysAuthorization()
        
        

        // 3. setup mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        // 4. setup test data
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        }
        guard let _: CLLocationCoordinate2D = locationManager.location?.coordinate else {return}
        let userLocation:CLLocation = locationManager.location!
        currentPosition = userLocation
    }
    
    // 1. user enter region
    private func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter \(region.identifier)")
    }
    
    // 2. user exit region
    private func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit \(region.identifier)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        guard let _: CLLocationCoordinate2D = self.locationManager.location?.coordinate else { return }

        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        if currentPosition == nil {
            currentPosition = userLocation
        }
        let coordinate0 = currentPosition
        let coordinate1 = userLocation
        let distanceInMeters = coordinate0!.distance(from: coordinate1)
        print(distanceInMeters)

//        if distanceInMeters > 5 {
//            let regionRadius = distanceInMeters
        let regions = CLCircularRegion(center: center, radius: CLLocationDistance(mapView.bounds.width), identifier: "Your Location")
            locationManager.startMonitoring(for: regions)
            
            let mapViewModel = MapViewModel()
            
            guard let _: CLLocationCoordinate2D = self.locationManager.location?.coordinate else { return }
            self.centerMap(on: (self.locationManager.location?.coordinate)!)
            
            let northEast = mapView.convert(CGPoint(x: mapView.bounds.width, y: 0), toCoordinateFrom: mapView)
            let southWest = mapView.convert(CGPoint(x: 0, y: mapView.bounds.height), toCoordinateFrom: mapView)
            
            mapViewModel.loadVehicleWhileUserChangePosition(northEast: northEast, southWest: southWest
                , onSuccess: { (data) in
                    self.tableData = (data as! Array<Vehicle>)
                    DispatchQueue.main.sync {
                        self.displayingVehicleInMap()
                    }
            }) { (err) in
                print("URL is not responding \(String(describing: err))")
            }
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print(region)
        if region.notifyOnExit {
            locationManager.startUpdatingLocation()
            currentPosition = manager.location
        }
        else{
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

    }
    

    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        
        let serialQueue = DispatchQueue(label: "com.test.mySerialQueue")
        serialQueue.sync {
            // code
            displayingVehicleInMap()
        }
    }
    
    private func displayingVehicleInMap(){
        if self.tableData != nil {
            var coords = NSMutableArray.init() as! [CLLocation]
            for object:Vehicle in self.tableData {
                let lat: Double = Double("\(object.coordinate.latitude)")!
                let lon: Double = Double("\(object.coordinate.longitude)")!
                coords.append(CLLocation(latitude: lat, longitude:lon))
            }
            addAnnotations(coords: coords)
        }
    }
    func addAnnotations(coords: [CLLocation]){
        DispatchQueue.main.async {
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
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

