//
//  RecipeBuilderView.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/12/23.
//

import SwiftUI

struct RecipeBuilderView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var foodSearchService: FoodSearchService
    @State private var searchText = ""
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return foodSearchService.recipes
        } else {
            return foodSearchService.recipes.filter { $0.label.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onCommit: {
                    // You can perform any action after committing the search here
                })
                List {
                    ForEach(filteredRecipes) { recipe in
                        VStack(alignment: .leading) {
                            Text(recipe.label)
                                .font(.headline)
                            Text(recipe.source)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationBarTitle("Recipe Builder", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct RecipeBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeBuilderView(foodSearchService: FoodSearchService())
    }
}
