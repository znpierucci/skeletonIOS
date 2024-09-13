//
//  ReviewView.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI
import StoreKit

struct ReviewView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showPhotoUploadView = false
    
    var body: some View {
        VStack {
            CustomBackButtonView {
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding(.leading, 10) // Adjust the padding as needed
            
            Spacer()

            // Laurel Wreaths and Title in HStack
            HStack {
                Image(systemName: "laurel.leading")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 180)
                    .foregroundColor(Color.white.opacity(0.5))
                
                Text("motto here")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Image(systemName: "laurel.trailing")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 180)
                    .foregroundColor(Color.white.opacity(0.5))
            }
            .padding(.bottom, 20)
            
            Spacer()

            VStack {
                HStack(spacing: 10) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.bottom, 10)
                
                Text("Trusted by over")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("100K people")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Spacer()

            Button(action: {
                requestAppReview()
            }) {
                Text("Leave a Review")
                    .foregroundColor(.black)
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 40)
            
            // NavigationLink to PhotoUploadView
            NavigationLink(destination: PhotoUploadView(), isActive: $showPhotoUploadView) {
                EmptyView()
            }
        }
        .background(Constants.appGradient)
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden(true)
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
            
            // Delay navigation until the review prompt is closed
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showPhotoUploadView = true
            }
        }
    }
}
