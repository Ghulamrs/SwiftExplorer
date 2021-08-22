//
//  ContentView.swift
//  SwiftExplorer
//
//  Created by Home on 1/30/21.
// 

import SwiftUI
import UserNotifications

struct ContentView: View {
    @EnvironmentObject var alert: AlertSignal // - tells when leaving home circle
    @StateObject var delegate = NotificationDelegate()
    
    var body: some View {

        GoogleMapsView()
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (_, _) in
                }
                UNUserNotificationCenter.current().delegate = delegate
            })
            .onChange(of: alert.signal) { count in
                if(count == 1) { setNotification() }
            }
    }

    func setNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Crossing home bounds ..."
        content.subtitle = " - please note - "
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
