//
//  CustomBackButtonView.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI

struct CustomBackButtonView: View {
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                self.action()
            }) {
                Image("CustomBackButton") // Ensure this image is in your assets
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(10)
                    .clipShape(Circle())
            }
            Spacer()
        }
    }
}
