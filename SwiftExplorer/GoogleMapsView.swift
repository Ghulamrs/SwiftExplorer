//
//  GoogleMapsView.swift
//  SwiftExplorer
//
//  Created by Home on 1/30/21.
//

import SwiftUI
import GoogleMaps

struct GoogleMapsView: UIViewRepresentable {
    @ObservedObject var manager = LocationManager()
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let location = manager.location // Zeropoint
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.isTrafficEnabled = true
//        mapView.mapType = .terrain

        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.animate(toLocation: manager.location.coordinate)
        manager.marker.map = mapView
        manager.addPolyline(view: mapView)
        
        if(manager.heading != nil) {
            mapView.animate(toBearing: manager.heading!.trueHeading)
        }
    }
}
