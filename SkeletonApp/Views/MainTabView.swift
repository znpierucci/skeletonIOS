//
//  MainTabView.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var selectedTabIndex = 1  // Set to the index of the Report tab
    @State private var isSubscribed: Bool = UserDefaults.standard.bool(forKey: "isSubscribed")
    
    var body: some View {
        if isSubscribed {
            TabView(selection: $navigationViewModel.selectedTabIndex) {
                TabView1()
                    .tabItem {
                        Label("Daily", systemImage: navigationViewModel.selectedTabIndex == 0 ? "sunrise.fill" : "sunrise")
                            .foregroundColor(navigationViewModel.selectedTabIndex == 0 ? .blue : .white)
                    }
                    .tag(0)
                TabView2()
                    .tabItem {
                        Label("My Report", systemImage: navigationViewModel.selectedTabIndex == 1 ? "chart.bar.fill" : "chart.bar")
                            .foregroundColor(navigationViewModel.selectedTabIndex == 1 ? .blue : .white)
                    }
                    .tag(1)
                TabView3()
                    .tabItem {
                        Label("Settings", systemImage: navigationViewModel.selectedTabIndex == 2 ? "gearshape.fill" : "gearshape")
                            .foregroundColor(navigationViewModel.selectedTabIndex == 2 ? .blue : .white)
                    }
                    .tag(2)
            }
            .accentColor(.blue)  // This sets the overall accent color for selected items
            .background(Color.black.edgesIgnoringSafeArea(.all))  // Ensuring the entire background is black
        } else {
            PaywallView(isSubscribed: $isSubscribed)
        }
    }
}

class NavigationViewModel: ObservableObject {
    @Published var selectedTabIndex: Int = 1
    
    @Published var currentScreen: Screen = .introduction {
        didSet {
            UserDefaults.standard.set(currentScreen.rawValue, forKey: "lastScreen")
        }
    }

    init() {
        if let savedScreen = UserDefaults.standard.string(forKey: "lastScreen"),
           let screen = Screen(rawValue: savedScreen) {
            currentScreen = screen
        }
        selectedTabIndex = 1 //always default to ReportView
    }

    enum Screen: String {
        case introduction = "introduction"
        case mainTabView = "mainTabView"
    }
}
