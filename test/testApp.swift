//
//  testApp.swift
//  test
//
//  Created by Rohit Nikam on 9/7/24.
//

import SwiftUI
import UserNotifications

@main
struct testApp: App {
    
    
    init() {
            // Request notification permission
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted {
                    print("Permission granted")
                } else {
                    print("Permission denied")
                }
            }
        }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
