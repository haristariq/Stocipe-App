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
    @State private var searchText = ""
    @State private var showAddNewItemMenu = false
    @State private var capturedImage: UIImage?
    @State private var isCameraViewPresented = false
    @State private var folders = ["Folder 1", "Folder 2", "Folder 3", "Folder 4"]

    var filteredFolders: [String] {
        if searchText.isEmpty {
            return folders
        } else {
            return folders.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    var body: some View {
            ZStack {
                TabView(selection: $selectedTab) {
                    VStack {
                        HStack {
                            SearchBar(text: $searchText, onCommit: {
                                // Handle search commit event here
                            })
                            Menu {
                                Button(action: {
                                    isCameraViewPresented = true
                                }, label: {
                                    Label("Open Camera", systemImage: "camera")
                                })

                                Button(action: {
                                    // Handle scanning the barcode here
                                }, label: {
                                    Label("Scan Barcode", systemImage: "barcode.viewfinder")
                                })

                                Button(action: {
                                    // Handle manual search through API catalogue here
                                }, label: {
                                    Label("Manual Search", systemImage: "magnifyingglass")
                                })
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }
                        .padding(.horizontal)

                        List(filteredFolders, id: \.self) { folder in
                            Text(folder)
                        }
                    }
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Storage")
                    }
                    .tag(0)
                    .sheet(isPresented: $isCameraViewPresented) {
                        CameraView(capturedImage: $capturedImage)
                    }

                
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
