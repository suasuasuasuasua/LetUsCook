//
//  RecipeImageView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/3/24.
//

import PhotosUI
import SwiftUI

struct RecipeEditorImageView: View {
    @Binding var recipe: Recipe
    @Binding var selectedPhotoItem: PhotosPickerItem?
    @State var selectedPhotoImage: Image?

    /// The size of the preview image
    private let imageSize = 50.0

    var body: some View {
        VStack {
            HeaderSectionText(text: "Add an image!")

            // Load the image when the photo has been selected
            selectedPhotoImage?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)

            // Add an option to pull images from the user's photos album
            PhotosPicker(selection: $selectedPhotoItem,
                         matching: .images,
                         photoLibrary: .shared())
            {
                Image(systemName: "pencil.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 30))
                    .foregroundStyle(.blue)
            }

            // TODO: add a file picker too
            // Add an option to pull images from the user's local files

            // Delete button
            if selectedPhotoImage != nil {
                Button(role: .destructive) {
                    selectedPhotoImage = nil
                } label: {
                    Label("Remove Image", systemImage: "xmark")
                        .foregroundStyle(.red)
                }
            }
        }
        /// Perform an async function whenever the photo value changes
        .task(id: selectedPhotoItem) {
            if let loadedImage = try? await selectedPhotoItem?
                .loadTransferable(type: Image.self),
               let loadedData = try? await selectedPhotoItem?
                .loadTransferable(type: Data.self)
            {
                selectedPhotoImage = loadedImage

                // TODO: save the image in a cache and point the recipe's
                // imageURL to it
                recipe.imageData = loadedData
            } else {
                print("Failed to load the image..")
            }
        }
    }
}
