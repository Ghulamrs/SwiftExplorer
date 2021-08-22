//
//  LocationManager.swift
//  SwiftExplorer
//
//  Created by Home on 1/31/21.
//

import Foundation
import GoogleMaps
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation = CLLocation(latitude: 33.6938, longitude: 73.0652) // Zeropoint
    @Published var heading: CLHeading?
    @Published var crossed: Bool = false

    private var path = GMSMutablePath()
    let homeRadius = 100000.0

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 35.0

        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.headingAvailable() {
            locationManager.headingFilter = 10.0
            locationManager.startUpdatingHeading()
        }
        
        self.location = UserPreference.shared.lox
        let region = CLCircularRegion(center: self.location.coordinate, radius: homeRadius, identifier: "home")
        locationManager.startMonitoring(for: region)
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
        path.addLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude)
        if(path.count() > 2) {
            path.removeCoordinate(at: 0)
            UserPreference.shared.update(loc: location) // home update service
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading
    }
    // August 8, 2021
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        crossed.toggle()
    }
    
    func addPolyline(view: GMSMapView, color: UIColor) {
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.geodesic = true
        polyline.strokeColor = color
        polyline.map = view
    }
}
