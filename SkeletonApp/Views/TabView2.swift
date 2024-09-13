//
//  TabView2.swift
//  SkeletonApp
//
//  Created by zpier on 9/12/24.
//

import SwiftUI

struct TabView2: View {
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var displayedImage: UIImage?
    
    var body: some View {
        VStack {
           //VIEW GOES HERE
        }
        .background(Constants.appGradient)
        .preferredColorScheme(.light)
        .onAppear {
            self.displayedImage = loadImage()
        }
    }
}
