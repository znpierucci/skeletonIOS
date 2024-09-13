//
//  Question2View.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI

struct Question2View: View {
    var answer1: String
    var uploadedImage: UIImage?
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var answer2: String = ""
    @State private var navigateToLoading = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            CustomBackButtonView {
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding(.leading, 10)

            // Title and Subtitle
            Text("Question 2")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)

            Text("subtext paragraph")
                .font(.subheadline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            
            Spacer()

            // Navigation Link to Loading View
            NavigationLink(destination: LoadingView().navigationBarBackButtonHidden(true), isActive: $navigateToLoading) {
                EmptyView()
            }

            // Next Button
            Button(action: {
//                if answer2 != "" {
                    saveData()
                    navigateToLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                        navigationViewModel.currentScreen = .mainTabView
                    }
//                }
            }) {
                Text("Next")
                    .foregroundColor(answer2 == "" ? Color.gray.opacity(0.5) : Color.black)
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 50)
//            .disabled(answer2 == "")
        }
        .background(Constants.appGradient)
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden(true)
    }

    // Function to save data
    private func saveData() {
        let results = QuestionnaireResults(
            answer1: answer1,
            answer2: answer2
        )
        results.save()
        
        if let image = uploadedImage {
            saveImage(image)
        }
    }
    
    private func saveImage(_ image: UIImage) {
        if ImageSaver.saveImage(image, forKey: "uploadedImage") {
            UserDefaults.standard.set("uploadedImage", forKey: "savedImageKey")
        }
    }
}
