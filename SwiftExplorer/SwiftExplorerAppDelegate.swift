//
//  SwiftExplorerAppDelegate.swift
//  SwiftExplorer
//
//  Created by Home on 1/30/21.
//

import UIKit
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("")

        return true
    }
}
