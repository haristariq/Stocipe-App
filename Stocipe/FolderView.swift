//
//  FolderView.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/11/23.
//

import SwiftUI

struct FolderView: View {
    @Binding var selectedItems: [FoodItem]

    var body: some View {
        VStack {
            Text("Selected Items")
                .font(.largeTitle)
                .padding()

            List(selectedItems) { item in
                Text(item.title)
            }
        }
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(selectedItems: .constant([FoodItem(id: 1, title: "Sample Item 1"), FoodItem(id: 2, title: "Sample Item 2")]))
    }
}
