//
//  ContentView.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/10/23.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showLandingPage = true

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                Text("Landing Page")
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Storage")
                    }
                    .tag(0)
                
                Text("Shopping List")
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Shopping List")
                    }
                    .tag(1)
                
                Text("Recipe Builder")
                    .tabItem {
                        Image(systemName: "folder.fill")
                        Text("Recipes")
                    }
                    .tag(2)
                
                Text("Settings")
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Settings")
                    }
                    .tag(3)
            }
            .disabled(showLandingPage)

            if showLandingPage {
                LandingPage(showLandingPage: $showLandingPage)
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
