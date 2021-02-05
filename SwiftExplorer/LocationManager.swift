//
//  LocationManager.swift
//  SwiftExplorer
//
//  Created by Home on 1/31/21.
//
// https://drive.google.com/drive/my-drive
// https://drive.google.com/file/d/15lPZZUkqFLMQUZmORpCuxyMnJ8cy-vGy/view?usp=sharing

import Foundation
import GoogleMaps

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation = CLLocation(latitude: 33.6938, longitude: 73.0652) // Zeropoint
    @Published var heading: CLHeading?
    @Published var marker = GMSMarker()
    private var path = GMSMutablePath()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.headingAvailable() {
            locationManager.headingFilter = 5
            locationManager.startUpdatingHeading()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        marker.position = location.coordinate
        path.addLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude)
        if(path.count() > 20) {
            path.removeCoordinate(at: 0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading
    }
    
    func addPolyline(view: GMSMapView) {
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.geodesic = true
        polyline.strokeColor = .blue
        polyline.map = view
    }
}
