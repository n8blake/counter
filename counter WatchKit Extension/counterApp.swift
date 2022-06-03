//
//  counterApp.swift
//  counter WatchKit Extension
//
//  Created by Nathan Blake on 6/3/22.
//

import SwiftUI

@main
struct counterApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
