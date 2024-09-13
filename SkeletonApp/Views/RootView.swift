//
//  RootView.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var navigationViewModel: NavigationViewModel

    var body: some View {
        NavigationView {
            switch navigationViewModel.currentScreen {
            case .introduction:
                IntroductionView()
            case .mainTabView:
                MainTabView()
            }
        }
    }
}
