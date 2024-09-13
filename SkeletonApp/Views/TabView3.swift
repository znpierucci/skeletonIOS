//
//  TabView3.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI

struct TabView3: View {
    @EnvironmentObject var navigationViewModel: NavigationViewModel

    var body: some View {
        VStack {
            //VIEW GOES HERE
            
            // Reset Data Button
            Button("Reset Data") {
                resetData()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(10)
            .padding(.bottom, 30)
        }
        .background(Constants.appGradient)
        .preferredColorScheme(.light)
        .onAppear {
        }
    }
    
    private func resetData() {
        DataManager.shared.clearData()
        navigationViewModel.currentScreen = .introduction
    }
}
