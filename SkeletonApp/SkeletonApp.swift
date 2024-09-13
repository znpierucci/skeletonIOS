//
//  SkeletonAppApp.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI

@main
struct SkeletonApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var navigationViewModel = NavigationViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(navigationViewModel)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
}
