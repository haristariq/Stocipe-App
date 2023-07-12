//
//  ProfileView.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/12/23.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ImageGallery()) {
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .foregroundColor(.blue)
                            .font(.system(size: 20, weight: .regular))
                        Text("Image Gallery")
                            .font(.system(size: 20, weight: .regular))
                    }
                }
                // Add more items to the list as needed
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
