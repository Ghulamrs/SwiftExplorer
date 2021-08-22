//
//  LocationData.swift
//  SwiftExplorer
//
//  Created by Home on 2/16/21.
//

import Foundation

class LocationEx : Codable {
    var  lox : [Location]
    init(loc : [Location]) {
        self.lox = loc
    }
}

struct Location : Codable, Hashable {
    static func == (lhs: Location, rhs: Location) -> Bool { // support Hashable
        Int(lhs.id) == Int(rhs.id)
    }
    
    var id:   String
    var lat:  Double
    var lng:  Double
    var name: String?

    init(id: String, lat: Double, lng: Double, name: String) {
        self.id   = id
        self.lat  = lat
        self.lng  = lng
        self.name = name
    }
    
    init(id: String, lat: Double, lng: Double) {
        self.init(id: id, lat: lat, lng: lng, name: "")
    }
}

// Groups & Members Data
struct Member: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var of: String
}

// Info group/members data
struct Info: Codable, Hashable {
    var result: Int
    var group: [Member]
    var members: [Member]
    
    init() {
        result = 0
        group = []
        members = []
    }
}

