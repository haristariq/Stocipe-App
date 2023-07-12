//
//  SelectedItemsView.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/11/23.
//

import SwiftUI

struct SelectedItemsView: View {
    @Binding var selectedItems: [FoodItem]

    var body: some View {
        List(selectedItems) { item in
            Text(item.title)
        }
    }
}
