//
//  RecipeCreationView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftUI

/// View for creating a recipe
///
/// The fields I am imagining are:
/// - Title - the name of the recipe
/// - Photo - just allow the user to upload one of their own or an online one --
///   hopefully it's something that they made themselves :)
/// - Categories for filtering -- this will probably be a comma separated list
///   of tags (global counter of course)
/// - Time required for the recipe divided up into prep and cooking time
///     - Mela doesn't seem to have any input validation here. We can put
///       hour and minute dials to ensure that the user always puts a valid
///       number
/// - Comments - a brief description about the recipe
///
/// - The instructions line by line
/// - The ingredients line by line -- this may have auto-complete or a similar
///   syntax highlighting to Mela for leading numbers like **1/4** quarts water
///   and **2** eggs
struct RecipeEditorView: View {
    let recipe: Recipe?

    /// Define all the variables that the user might be able to change as state
    /// variables. This ensure that SwiftData does not save changes until the
    /// user is ready to submit and save those changes. Moreover, the user can
    /// discard changes if they don't like what they have entered.
    @State private var name = ""
    // TODO: implement the photo picker
    @State private var photo = ""
    @State private var categories: [String] = []
    // TODO: add validation for the the times; also don't use strings maybe
    @State private var prepTime = ""
    @State private var cookTime = ""
    @State private var comments = ""

    /// We can share the editor view for creating and editing recipes in.
    /// The title will just depend on whether there is a recipe yet or not
    ///
    /// https://developer.apple.com/documentation/swiftdata/adding-and-editing-persistent-data-in-your-app
    private var editorTitle: String {
        recipe == nil
            ? "Add Recipe"
            : "Edit Recipe"
    }

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                TextField("TODO: Photo", text: $photo)
                // TextField("TODO: Categories", text: $categories)
                TextField("Preparation Time", text: $prepTime)
                TextField("Cooking Time", text: $cookTime)
                TextField("Comments", text: $comments)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
//                    // Require a category to save changes.
//                    .disabled($selectedCategory.wrappedValue == nil)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                /// If we are editing a recipe, then we don't want to use
                /// default values in the editor. This ensures that we use
                /// up-to-date properties for the recipe when editing it
                if let recipe {
                    name = recipe.name
                }
            }
        }
        .padding()
    }

    /// Save the recipe in the model context
    /// If we are editing a recipe, then update the recipe's properties
    private func save() {
        if let recipe {
            // Edit the recipe
            recipe.name = name
            recipe.photo = photo
            recipe.categories = categories
            recipe.prepTime = prepTime
            recipe.cookTime = cookTime
            recipe.comments = comments
        } else {
            // Add a new recipe.
            let newRecipe = Recipe(
                name: name,
                photo: photo,
                categories: categories,
                prepTime: prepTime,
                cookTime: cookTime,
                comments: comments,
                // TODO: figure out how to add a list of instructions and
                // ingredients
                ingredients: [],
                instructions: []
            )

            // Remember to insert the recipe into the model context after
            modelContext.insert(newRecipe)
        }
    }
}

// #Preview {
//    RecipeEditorView()
// }
