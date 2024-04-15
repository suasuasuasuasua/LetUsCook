//
//  RecipeEditorForm.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/14/24.
//

import PhotosUI
import SwiftUI

extension RecipeEditorView {
    internal struct NameView: View {
        @Binding var name: String

        var body: some View {
            Section("Name") {
                TextField(
                    "",
                    text: $name,
                    prompt: Text("What is this recipe called?")
                )
            }
        }
    }

    internal struct TimeView: View {
        @Binding var prepTime: String
        @Binding var cookTime: String

        var body: some View {
            Section("Time") {
                TextField(
                    "Preparation Time",
                    text: $prepTime,
                    prompt: Text("How long does this recipe take to prepare?")
                )
                TextField(
                    "Cooking Time",
                    text: $cookTime,
                    prompt: Text("How long does this recipe take to cook?")
                )
            }
        }
    }

    internal struct CategoriesView: View {
        @Binding var categories: [Category]

        var body: some View {
            List {
                ForEach(categories) { category in
                    Text("\(category.name)")
                }
            }
        }
    }

    internal struct CommentsView: View {
        @Binding var comments: String

        var body: some View {
            Section("Comments") {
                TextField(
                    "",
                    text: $comments,
                    prompt: Text("Any final comments?"),
                    axis: .vertical
                )
                .lineLimit(1 ... 3)
            }
        }
    }

    internal struct EditorView: View {
        var title: String
        @Binding var input: String

        var body: some View {
            Section(title) {
                TextEditor(text: $input)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    internal struct ImageView: View {
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

                HStack {
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
}
