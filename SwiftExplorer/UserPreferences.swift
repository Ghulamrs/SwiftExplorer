//
//  UserPreferences.swift
//  SwiftExplorer
//
//  Created by Home on 8/18/21.
//  self.lox = CLLocation(latitude: 33.6938, longitude: 73.0652) // zero point, Islamabad
//

import Foundation
import GoogleMaps

final class UserPreference {
    var uid :  UInt!
    var name:  String!
    var lat:   Double! // home
    var long:  Double! // home
    var alt:   Double! // home

    let COUNT = 10
//    let url = "http://3.92.12.25"
    let url = "https://idzeropoint.com"
    var lox: CLLocation!
    static var shared = UserPreference()
    
    init() {
        self.uid = 5
        self.name = "gra1"
        self.lox = CLLocation(coordinate: CLLocationCoordinate2DMake(33.63285, 72.91366), altitude: 568.0, horizontalAccuracy: kCLLocationAccuracyBest, verticalAccuracy: 0.1, timestamp: Date())
    }

    func saveUserInfo() {
        self.lat  = self.lox.coordinate.latitude
        self.long = self.lox.coordinate.longitude
        self.alt  = self.lox.altitude

        let userDefaults = UserDefaults.standard
        userDefaults.set(self.uid,   forKey: "uid")
        userDefaults.set(self.name,  forKey: "name")
        
        userDefaults.set(self.lat,   forKey: "lat")
        userDefaults.set(self.long,  forKey: "long")
        userDefaults.set(self.alt,   forKey: "alt")
        
        userDefaults.synchronize()
    }

    func loadUserInfo() -> Optional<Any> {
        if let key = UserDefaults.standard.object(forKey: "uid") {
            self.uid   = key as? UInt
            self.name  = (UserDefaults.standard.object(forKey: "name")  as! String)
            
            self.lat   = (UserDefaults.standard.object(forKey: "lat")   as! Double)
            self.long  = (UserDefaults.standard.object(forKey: "long")  as! Double)
            self.alt   = (UserDefaults.standard.object(forKey: "alt")   as! Double)
            
            self.lox   = CLLocation(coordinate: CLLocationCoordinate2DMake(self.lat, self.long), altitude: self.alt, horizontalAccuracy: kCLLocationAccuracyBest, verticalAccuracy: 0.1, timestamp: Date())
            
            return self.uid
        }

        return nil
    }

    func update(loc: CLLocation) {
        self.lox  =  loc
    }
}
