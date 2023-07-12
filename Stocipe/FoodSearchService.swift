//
//  FoodSearchService.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/11/23.
//

import Foundation
import Combine

struct FoodItem: Decodable, Identifiable {
    let id: Int
    let title: String
}

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
    
    /* private func fetchFoodItems(_ query: String) {
     // Check if the query is not empty before making the API call
     guard !query.isEmpty else { return }
     
     let apiKey = "e383f49d344b4fe991fb30d39bc4f2a3"
     let urlString = "https://api.spoonacular.com/recipes/complexSearch?query=\(query)&apiKey=\(apiKey)"
     
     guard let url = URL(string: urlString) else { return }
     
     URLSession.shared.dataTask(with: url) { data, response, error in
     if let data = data {
     do {
     let decodedResponse = try JSONDecoder().decode(SpoonacularResponse.self, from: data)
     DispatchQueue.main.async {
     self.foodItems = decodedResponse.results
     }
     } catch {
     print("Error decoding data: \(error)")
     }
     } else if let error = error {
     print("Error fetching data: \(error)")
     }
     }.resume()
     }
     } */
    
    private func fetchFoodItems(_ query: String) {
        // Check if the query is not empty before making the API call
        guard !query.isEmpty else { return }
        
        let apiKey = "a4258a3a62534026a8acc217b91d2a7d"
        let urlString = "https://api.spoonacular.com/recipes/complexSearch?query=\(query)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(SpoonacularResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.foodItems = Array(decodedResponse.results.prefix(10))
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

struct SpoonacularResponse: Decodable {
    let results: [FoodItem]
}
