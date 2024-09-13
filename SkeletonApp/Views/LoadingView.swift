//
//  LoadingView.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var currentEmoji: String = "😁"
    @State private var currentText: String = "Loading Message 1"
    
    var body: some View {
        VStack {
            Spacer()
            
            // Emoji and Loading Text
            VStack {
                Text(currentEmoji)
                    .font(.system(size: 80))  // Increase the emoji size to match the design
                    .padding(.bottom, 20)

                Text(currentText)
                    .padding(.top, 20)
                    .font(.system(size: 20, weight: .bold))  // Using .system font with specified weight
                    .foregroundColor(.white)
            }

            Spacer()
            
            // Instruction Text
            Text("Please do not leave or close the app")
                .foregroundColor(.white)
                .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.appGradient)
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            //TODO: generate whatever information we need for the main app core loop
            // Change the emoji after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.currentEmoji = "🤓"
                self.currentText = "Loading Message 2"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.currentEmoji = "📈"
                    self.currentText = "Loading Message 3"
                }
            }
        }
    }
}
