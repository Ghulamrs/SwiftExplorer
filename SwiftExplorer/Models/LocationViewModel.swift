//
//  LocationViewModel.swift
//  SwiftExplorer
//
//  Created by Home on 2/16/21.
//

import Foundation
import GoogleMaps
import CoreLocation
import Combine

// To remove duplicate items data
extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}

class LocationViewModel: ObservableObject {
    @Published var locs = LocationEx(loc: [])
    @Published var markers = [GMSMarker]()

    private var map: GMSMapView?
    private var cancellable = Set<AnyCancellable>()
    let color: [UIColor] = [.red, .green, .blue, .orange, .magenta, .cyan, .yellow, .purple, .systemGreen, .systemTeal]
    var location = CLLocation(latitude: 33.6938, longitude: 73.0652) // August 8, 2021
    var last: CLLocation { return location } // last stored location by publish function inside GMapsView.swift
    var accColor: UIColor { return color[Int(UserPreference.shared.uid > 0 ? UserPreference.shared.uid-1 : 0)] }
    var markersInitialized = false
    
    init() {
        self.location = UserPreference.shared.lox
        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    func fetchUsers(map: GMSMapView) {
        let url = URL(string: UserPreference.shared.url + "/" + "gloginx.php")
        var request = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        let postString = String("name=name") + String("&pswd=pswd")
        request.httpBody = postString.data(using: .utf8, allowLossyConversion: true)
        request.httpMethod = "POST"
        
        self.map = map // from arg1
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Info.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished: // success
                    self.setupMarkers()
                }
            }) { [self] info in
                let members = info.members.sorted(by: { UInt($0.id)! < UInt($1.id)! } )
                for member in members {
                    let user = Location(id: member.id, lat: location.coordinate.latitude, lng: location.coordinate.longitude, name: member.name)
                    locs.lox.append(user)
                }
            }
            .store(in: &cancellable)
    }

    func publish(loc: CLLocation, _ proceed: Int32) {
        let url = URL(string: UserPreference.shared.url + "/" + "setLocationi.php")
        var request = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        request.httpMethod = "POST"

        location = loc // August 8, 2021
        let postString = String("pid=\(UserPreference.shared.uid!)") + String("&par=\(loc.coordinate.latitude),\(loc.coordinate.longitude),\(loc.altitude),\(loc.speed),\(proceed)")
        request.httpBody = postString.data(using: .utf8, allowLossyConversion: true)
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: LocationEx.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished: // success
                    if(self.markersInitialized) { self.updateMarkers() }
                    else { self.setupMarkers() }
                }
            }) { locs in
                self.locs.lox.removeAll()
                self.locs = locs
                self.locs.lox.removeDuplicates()
            }
            .store(in: &cancellable)
    }

    func setupMarkers() {
        var i = 0
        markers.removeAll()
        for lux in self.locs.lox {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(lux.lat, lux.lng)
            marker.icon = GMSMarker.markerImage(with: color[i%10])
            marker.title = lux.name
            marker.snippet = lux.id
            if(lux.id == String(UserPreference.shared.uid)) { marker.zIndex = 2 }
            marker.map = self.map
            markers.append(marker)
            i = i + 1
        }
        markersInitialized = true
    }

    // August 16, 2021
    func updateMarkers() {
        self.locs.lox.removeDuplicates()
        for lux in self.locs.lox {
            let id = markers.firstIndex(where: { marker in return marker.snippet==lux.id })!
            if id < markers.count {
                markers[id].position = CLLocationCoordinate2DMake(lux.lat, lux.lng)
            }
        }
    }
    
    @objc func update() {
        publish(loc: self.location, 0) // don't publish(send to backend), only bring data from backend
    }
}
