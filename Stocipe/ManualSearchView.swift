//
//  ManualSearchView.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/11/23.
//


// works but need indication that it an item is selected
/* import Foundation
import SwiftUI

struct ManualSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedItems: [FoodItem]
    @ObservedObject var foodSearchService: FoodSearchService
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchText)
                    .padding()
                    .border(Color.gray, width: 0.5)
                Button(action: {
                    foodSearchService.manualSearch(query: searchText)
                }) {
                    Text("Search")
                }
                List(foodSearchService.foodItems) { item in
                    Text(item.title)
                        .onTapGesture {
                            addItemToList(item: item)
                        }
                }
                Spacer()
            }
            .navigationBarTitle("Manual Search", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func addItemToList(item: FoodItem) {
        selectedItems.append(item)
        presentationMode.wrappedValue.dismiss()
    }
}
*/


/*
import Foundation
import SwiftUI

struct ManualSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedItems: [FoodItem]
    @ObservedObject var foodSearchService: FoodSearchService
    @State private var searchText = ""
    @State private var selectedItem: FoodItem?

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchText)
                    .padding()
                    .border(Color.gray, width: 0.5)
                Button(action: {
                    foodSearchService.manualSearch(query: searchText)
                }) {
                    Text("Search")
                }
                List(foodSearchService.foodItems) { item in
                    Text(item.title)
                        .padding()
                        .background(selectedItem?.id == item.id ? Color.gray.opacity(0.3) : Color.clear)
                        .onTapGesture {
                            addItemToList(item: item)
                        }
                }
                Spacer()
            }
            .navigationBarTitle("Manual Search", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func addItemToList(item: FoodItem) {
        selectedItem = item
        selectedItems.append(item)
    }
}

*/

import SwiftUI
import Combine

struct ManualSearchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedItems: [FoodItem]
    @ObservedObject var foodSearchService: FoodSearchService
    @State private var searchText = ""
    @State private var scaleValues: [String: CGFloat] = [:]
    private let debounceTime: TimeInterval = 0.3
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchText)
                    .padding()
                    .border(Color.gray, width: 0.5)
                    .submitLabel(.search)
                    .onChange(of: searchText) { newValue in
                        debounceSearch(query: newValue)
                    }
                List(foodSearchService.foodItems) { item in
                    Text(item.title)
                        .padding()
                        .scaleEffect(scaleValues[item.id] ?? 1)
                        .onTapGesture {
                            addItemToList(item: item)
                        }
                }
                Spacer()
            }
            .navigationBarTitle("Manual Search", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    @State private var lastSearchWorkItem: DispatchWorkItem?
    
    private func debounceSearch(query: String) {
        lastSearchWorkItem?.cancel()
        
        let task = DispatchWorkItem {
            self.foodSearchService.manualSearch(query: query)
        }
        
        lastSearchWorkItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceTime, execute: task)
    }
    
    private func addItemToList(item: FoodItem) {
        withAnimation(.easeInOut(duration: 0.15)) {
            scaleValues[item.id] = 1.1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.15)) {
                scaleValues[item.id] = 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            selectedItems.append(item)
            saveSelectedItems()
        }
    }
    
    func saveSelectedItems() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(selectedItems) {
            UserDefaults.standard.set(encodedData, forKey: "selectedItems")
        }
    }
}
