//
//  LeftMenuViewModel.swift
//  SwiftExplorer
//
//  Created by Home on 2/2/21.
//

import Foundation
import Combine

class LeftMenuViewModel: ObservableObject {
    @Published var members = [Member]()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        setupPublisher()
    }
    
    private func setupPublisher() {
        let url = URL(string: urlPath + "/gloginx.php")
        var request = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        request.httpMethod = "POST"

        let postString = String("name=name") + String("&pswd=pswd")
        request.httpBody = postString.data(using: .utf8, allowLossyConversion: true)
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Info.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { info in
//                self.info = info
                self.members = info.members.sorted(by: {UInt($0.id)! < UInt($1.id)!} )
            })
            .store(in: &cancellable)
    }

}
