//
//  SwiftExplorerApp.swift
//  SwiftExplorer
//
//  Created by Home on 1/30/21.
//

import SwiftUI

@main
struct SwiftExplorerApp: App {
    @StateObject private var alert = AlertSignal()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let userPreferences = UserPreference.shared

    init() {
//        userPreferences.saveUserInfo() // used for one time only - comment for 2nd time use to avoid re-init again & again
        if userPreferences.loadUserInfo() == nil {
            print("Error: No prior user home information found!")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(alert)
        }
    }
}
