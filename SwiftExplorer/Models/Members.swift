//
//  Members.swift
//  SwiftExplorer
//
//  Created by Home on 2/3/21.
//

import Foundation

//var urlPath = "http://www.idzeropoint.com/"
var urlPath = "http://3.92.12.25/"

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
