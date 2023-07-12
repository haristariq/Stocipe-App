//
//  FoodSearchService.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/11/23.
//

import Foundation
import Combine

class FoodSearchService: ObservableObject {
    @Published var foodItems: [FoodItem] = []
    @Published var recipes: [Recipe] = []
    @Published var searchQuery = "" {
        didSet {
            search(query: searchQuery)
        }
    }
    
    private var searchCancellable: AnyCancellable?
    private var debounceTime: TimeInterval = 0.5
    
    init() {
        searchCancellable = $searchQuery
            .debounce(for: .seconds(debounceTime), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                guard let self = self else { return }
                self.fetchFoodItems(query)
            }
    }
    
    /// Searches for food items using the provided query string.
    func search(query: String) {
        // Check if the query is not empty before setting searchQuery
        guard !query.isEmpty else { return }
        
        DispatchQueue.main.async {
            self.searchQuery = query
        }
    }
    
    /// Manually fetches food items using the provided query string.
    func manualSearch(query: String) {
        fetchFoodItems(query)
    }
    
    /// Generates recipes based on the current search query.
    func generateRecipes(selectedItems: [FoodItem]) {
        guard !selectedItems.isEmpty else { return }
        let query = selectedItems.map { $0.title }.joined(separator: ",")
        fetchRecipes(query)
    }
    
    private func fetchFoodItems(_ query: String) {
        // Check if the query is not empty before making the API call
        guard !query.isEmpty else { return }
        
        // TODO: Replace these values with secure storage or configuration options
        let appId = "1f16ec19"
        let appKey = "14763beb1b497935ac6a9267c0b7ba3b"
        let urlString = "https://api.edamam.com/api/food-database/v2/parser?ingr=\(query)&app_id=\(appId)&app_key=\(appKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(EdamamFoodDatabaseResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.foodItems = decodedResponse.hints.map { $0.food }
                    }
                } catch {
                    // TODO: Replace with proper error handling
                    print("Error decoding data: \(error)")
                }
            } else if let error = error {
                // TODO: Replace with proper error handling
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
    
    private func fetchRecipes(_ query: String) {
        // Check if the query is not empty before making the API call
        guard !query.isEmpty else { return }

        // TODO: Replace these values with secure storage or configuration options
        let appId = "48e67202"
        let appKey = "3f66c6b90653f38a296536d28a493905"

        // Encode the query string
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        let urlString = "https://api.edamam.com/api/recipes/v2?type=public&q=\(encodedQuery)&app_id=\(appId)&app_key=\(appKey)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(EdamamRecipeSearchResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.recipes = decodedResponse.hits.map { $0.recipe }
                    }
                } catch {
                    // TODO: Replace with proper error handling
                    print("Error decoding recipe data: \(error)")
                }
            } else if let error = error {
                // TODO: Replace with proper error handling
                print("Error fetching recipe data: \(error)")
            }
        }.resume()
    }
}

struct FoodItem: Codable, Identifiable {
    let id: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case id = "foodId"
        case title = "label"
    }
}

struct EdamamFoodDatabaseResponse: Decodable {
    let hints: [Hint]
}

struct Hint: Decodable {
    let food: FoodItem
}

extension FoodItem: Hashable {
    static func == (lhs: FoodItem, rhs: FoodItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Recipe: Codable, Identifiable {
    let id: String
    let label: String
    let image: String
    let url: String
    let source: String
    let yield: Double
    let ingredientLines: [String]

    enum CodingKeys: String, CodingKey {
        case id = "uri"
        case label
        case image
        case url
        case source
        case yield
        case ingredientLines
    }
}

struct EdamamRecipeSearchResponse: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: Recipe
}

extension Recipe: Hashable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
