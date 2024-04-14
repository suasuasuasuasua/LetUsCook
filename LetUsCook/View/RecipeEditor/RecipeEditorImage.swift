//
//  RecipeImageView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/3/24.
//

import PhotosUI
import SwiftUI

struct RecipeEditorImageView: View {
    @Binding var selectedPhotoItem: PhotosPickerItem?
    @Binding var selectedPhotoImage: Image?

    /// The size of the preview image
    private let imageSize = 50.0

    var body: some View {
        Section("Image") {
            // TODO: WHY IS IT ROTATING IMAGES RANDOMLY?!!?
            // Load the image when the photo has been selected
            selectedPhotoImage?
                .resizable()
                .scaledToFit()
                .frame(height: imageSize)

            HStack{
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
                Text("Pick a file")
                    .padding()
                    .border(.black)

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
        }
        
    }
}

#Preview {
    let recipe = Recipe(name: "Toast")

    return RecipeEditorImageView(
        selectedPhotoItem: .constant(nil),
        selectedPhotoImage: .constant(nil)
    )
}
