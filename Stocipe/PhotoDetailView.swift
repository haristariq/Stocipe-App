//
//  PhotoDetailView.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/12/23.
//
 

import SwiftUI

struct PhotoDetailView: View {
    let image: UIImage

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .navigationTitle("Photo Detail")
        }
    }
}
