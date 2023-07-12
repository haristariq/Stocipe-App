import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showLandingPage = true
    @State private var searchText = ""
    @State private var capturedImage: UIImage?
    @StateObject private var foodSearchService = FoodSearchService()
    @State private var selectedItems: [FoodItem] = []
    @State private var activeSheet: ActiveSheet?

    enum ActiveSheet: Identifiable {
        case cameraView, manualSearch

        var id: Int {
            hashValue
        }
    }

    var filteredItems: [FoodItem] {
        if searchText.isEmpty {
            return selectedItems
        } else {
            return selectedItems.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                VStack {
                    HeaderView(searchText: $searchText, activeSheet: $activeSheet)

                    List {
                        ForEach(filteredItems) { foodItem in
                            Text(foodItem.title)
                        }
                    }
                    .onAppear {
                        loadSelectedItems()
                    }
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Storage")
                }
                .tag(0)

                Text("Shopping List")
                    .tabItem {
                        Image(systemName: "folder.fill")
                        Text("Folder")
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
            .sheet(item: $activeSheet) { item in
                switch item {
                case .cameraView:
                    CameraView(capturedImage: $capturedImage)
                case .manualSearch:
                    ManualSearchView(selectedItems: $selectedItems, foodSearchService: foodSearchService)
                }
            }

            if showLandingPage {
                LandingPage(showLandingPage: $showLandingPage)
            }
        }
    }

    func loadSelectedItems() {
        if let savedData = UserDefaults.standard.data(forKey: "selectedItems") {
            let decoder = JSONDecoder()
            if let decodedItems = try? decoder.decode([FoodItem].self, from: savedData) {
                selectedItems = decodedItems
            }
        }
    }
}

struct HeaderView: View {
    @Binding var searchText: String
    @Binding var activeSheet: ContentView.ActiveSheet?

    var body: some View {
        HStack {
            SearchBar(text: $searchText, onCommit: {
                // You can perform any action after committing the search here
            })
            Menu {
                Button(action: {
                    activeSheet = .manualSearch
                }, label: {
                    Label("Manual Search", systemImage: "magnifyingglass")
                })
                Button(action: {
                    activeSheet = .cameraView
                }, label: {
                    Label("Open Camera", systemImage: "camera")
                })

                Button(action: {
                    // Handle scanning the barcode here
                }, label: {
                    Label("Scan Barcode", systemImage: "barcode.viewfinder")
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
