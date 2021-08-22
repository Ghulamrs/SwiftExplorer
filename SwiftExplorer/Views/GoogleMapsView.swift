//
//  GoogleMapsView.swift
//  SwiftExplorer
//
//  Created by Home on 1/30/21.
//

import SwiftUI
import GoogleMaps

struct GoogleMapsView: UIViewRepresentable {
    @EnvironmentObject var alert: AlertSignal
    @ObservedObject var loxView = LocationViewModel()
    @ObservedObject var manager = LocationManager()

    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: manager.location.coordinate.latitude,
                                               longitude: manager.location.coordinate.longitude, zoom: 10)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.isTrafficEnabled = true
        mapView.mapType = .hybrid
        
        loxView.fetchUsers(map: mapView)
        drawCircle(mapView)

        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        if(manager.heading != nil) {
            mapView.animate(toBearing: manager.heading!.trueHeading)
        }
        if( loxView.last.coordinate.latitude  == manager.location.coordinate.latitude && // August 08, 2021
            loxView.last.coordinate.longitude == manager.location.coordinate.longitude) { return }
        
        mapView.animate(toLocation: manager.location.coordinate)
        loxView.publish(loc: manager.location, 2)
        manager.addPolyline(view: mapView, color: loxView.accColor)
        if(manager.crossed) { alert.signaled() }
    }
    
    func drawCircle(_ mapView: GMSMapView) {
        let circle = GMSCircle()
        circle.radius   = manager.homeRadius
        circle.position  = manager.location.coordinate
        circle.fillColor  = UIColor(red: 0, green: 0.3, blue: 0, alpha: 0.2)
        circle.strokeColor = UIColor.green
        circle.strokeWidth  = 2

        circle.map = mapView
    }
}
