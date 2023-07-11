//
//  ContentView.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            LandingPage()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            // Add other views for the remaining tab items
            Text("Second Tab")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)

            Text("Third Tab")
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Folders")
                }
                .tag(2)

            Text("Fourth Tab")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
