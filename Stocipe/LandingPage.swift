//
//  LandingPage.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/11/23.
//

//
//  LandingPage.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/11/23.
//

import SwiftUI

struct LandingPage: View {
    @Binding var showLandingPage: Bool

    var body: some View {
        ZStack {
            Color(hex: "668E47") // Set the background color
                .ignoresSafeArea() // Make sure the color takes up the entire screen

            VStack {
                Text("Stocipe")
                    .font(Font.custom("IndieFlower", size: 64))
                    .bold()
                    .padding(.bottom, 10)

                Image("artwork") // Replace with your app's logo
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 100)

                Text("Tap to Begin")
                    .font(Font.custom("IndieFlower", size: 34))
                    .foregroundColor(.black)
                    .padding(.top, 150
                    )
                  
            }
        }
        .onTapGesture {
            showLandingPage.toggle()
        }
    }
}


struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage(showLandingPage: .constant(true))
    }
}

// ... (Color extension code)

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
