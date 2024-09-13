//
//  IntroductionView.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI

struct IntroductionView: View {
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var selectedImage: UIImage? = nil
    @State private var shouldNavigateToMain = false
    
    var body: some View {
        VStack {
            Spacer()

            // Title and subtitle
            Text("AppName")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom, 8)
            
            Text("Motto goes here")
                .font(.system(size: 20))
                .foregroundColor(.white)
            
            Spacer()
            
            // Get Started button
            NavigationLink(destination: ReviewView()) {
                Text("Get Started")
                    .foregroundColor(.black)
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 40)
        }
        .background(Constants.appGradient)
        .preferredColorScheme(.light)
        .onAppear {
            loadInitialData()
        }
    }

    func loadInitialData() {
        let resultsLoaded = QuestionnaireResults.load() != nil
        let imageLoaded = loadImage() != nil
        if resultsLoaded && imageLoaded {
            selectedImage = loadImage()
            shouldNavigateToMain = true
            checkNavigation()
        }
    }
    
    func checkNavigation() {
        if shouldNavigateToMain {
            navigationViewModel.currentScreen = .mainTabView
        }
    }
}
