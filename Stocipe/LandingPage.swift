//
//  LandingPage.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/10/23.
//

import SwiftUI

struct LandingPage: View {
    @State private var showNextView = false

    var body: some View {
        VStack {
            Text("Your App Name")
                .font(.largeTitle)
                .bold()

            Image(systemName: "appicon") // Replace with your app's logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)

            Button(action: {
                showNextView.toggle()
            }) {
                Text("Tap to Begin")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .sheet(isPresented: $showNextView) {
            // Replace with the view to be displayed after tapping "Tap to Begin"
            Text("Next View")
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
