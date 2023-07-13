//
//  ImageGallery.swift
//  Stocipe
//
//  Created by Haris Tariq on 7/12/23.
//
import SwiftUI

struct ImageGallery: View {
    @State private var images: [UIImage] = []
    @State private var selectedImage: UIImage?
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(images, id: \.self) { image in
                    NavigationLink(destination: PhotoDetailView(image: image)) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button(action: {
                            selectedImage = image
                            showDeleteAlert.toggle()
                        }, label: {
                            Label("Delete", systemImage: "trash")
                        })
                    }
                }
            }
            .padding()
        }
        .alert(isPresented: $showDeleteAlert, content: {
            Alert(title: Text("Are you sure you want to delete this photo?"),
                  primaryButton: .destructive(Text("Delete")) {
                if let image = selectedImage {
                    deleteImage(image: image)
                }
            },
                  secondaryButton: .cancel())
        })
        .navigationTitle("Image Gallery")
        .onAppear {
            loadImages()
        }
}
    
    func deleteImage(image: UIImage) {
        if let index = images.firstIndex(of: image) {
            images.remove(at: index)

            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

            let fileName = "image_\(index).jpg"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)

            do {
                try fileManager.removeItem(at: fileURL)
                loadImages() // Refresh the images array after deleting the image
            } catch {
                print("Error deleting image: \(error.localizedDescription)")
            }
        }
    }

    private func loadImages() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        do {
            let files = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])

            images = files.compactMap { url -> UIImage? in
                if url.pathExtension == "jpg" {
                    return UIImage(contentsOfFile: url.path)
                }
                return nil
            }
        } catch {
            print("Error loading images from Documents directory: \(error)")
        }
    }
}
