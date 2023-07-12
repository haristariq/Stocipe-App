import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showLandingPage = true
    @State private var searchText = ""
    @State private var capturedImage: UIImage?
    @StateObject private var foodSearchService = FoodSearchService()
    @State private var selectedItems: [FoodItem] = []
    @State private var activeSheet: ActiveSheet?
    @State private var showRecipeBuilder = false
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

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
                        .onDelete(perform: deleteItem)
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

                VStack {
                    Button(action: {
                        foodSearchService.generateRecipes(selectedItems: selectedItems)
                        showRecipeBuilder.toggle()
                    }) {
                        Text("Generate Recipe")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .sheet(isPresented: $showRecipeBuilder) {
                        RecipeBuilderView(foodSearchService: foodSearchService)
                    }
                }
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Recipes")
                }
                .tag(2)

                ProfileView() // Replace the ImageGallery with ProfileView
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
                
            }
            .environment(\.colorScheme, isDarkMode ? .dark : .light) //dark light mode
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

    private func deleteItem(at offsets: IndexSet) {
        selectedItems.remove(atOffsets: offsets)
        saveSelectedItems()
    }

    func saveSelectedItems() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(selectedItems) {
            UserDefaults.standard.set(encodedData, forKey: "selectedItems")
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
