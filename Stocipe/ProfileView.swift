//
//  ProfileView.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/12/23.
//
import SwiftUI

struct ProfileView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

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

                Toggle(isOn: $isDarkMode) {
                    HStack {
                        Image(systemName: "circle.lefthalf.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 20, weight: .regular))
                        Text("Dark Mode")
                            .font(.system(size: 20, weight: .regular))
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
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
