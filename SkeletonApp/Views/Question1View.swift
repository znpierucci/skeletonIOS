//
//  Question1View.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI

struct Question1View: View {
    var uploadedImage: UIImage?
    @State private var answer1: String = ""  // Start with no selection
    @State private var isActive = false  // Manually control the navigation
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            CustomBackButtonView {
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding(.leading, 10)

            // Title and subtitle
            Text("Question 1")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.top, 30)

            Text("subtext paragraph")
                .font(.subheadline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
                .padding([.horizontal, .bottom], 40)

            
            Spacer()

            // Next button at the bottom
            Button(action: {
//                if answer1 != "" {
                    self.isActive = true  // Activate the link only if an option is selected
//                }
            }) {
                Text("Next")
                    .foregroundColor(answer1 == "" ? Color.gray.opacity(0.5) : Color.black)
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 50)
//            .disabled(answer1 == "")

            // NavigationLink to Question2View
            NavigationLink(destination: Question2View(answer1: answer1, uploadedImage: uploadedImage), isActive: $isActive) {
                EmptyView()
            }
        }
        .background(Constants.appGradient)
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden(true)
    }
}
