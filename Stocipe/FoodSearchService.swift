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
    
    func search(query: String) {
        // Check if the query is not empty before setting searchQuery
        guard !query.isEmpty else { return }
        
        print("search called with query: \(query)")
        
        DispatchQueue.main.async {
            self.searchQuery = query
        }
    }
    
    func manualSearch(query: String) {
        fetchFoodItems(query)
    }
    
    private func fetchFoodItems(_ query: String) {
        // Check if the query is not empty before making the API call
        guard !query.isEmpty else { return }
        
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
                    print("Error decoding data: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
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
