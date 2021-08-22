//
//  AlertView.swift
//  SwiftExplorer
//
//  Created by Home on 8/9/21.
//

import Foundation

class AlertSignal: ObservableObject {
    @Published var signal: UInt32 = 0
    
    func signaled() {
        signal = signal + 1
    }
    
    func cleared() {
        signal = 0
    }
}
