//
//  RecipeCreationView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import PhotosUI
import SwiftUI

/// View for creating a recipe
///
/// Define all the variables that the user might be able to change as state
/// variables.
/// This ensure that SwiftData does not save changes until the
/// user is ready to submit and save those changes. Moreover, the user can
/// discard changes if they don't like what they have entered.

struct RecipeEditorView: View {
    /// The recipe that we are currently viewing
    ///
    /// If the recipe is `nil`, that means we are creating a recipe in the view.
    /// Otherwise, we are editing a recipe.
    /// Regardless, the data entered by the user create or edit the recipe.
    @State var recipe: Recipe = .init(name: "New Recipe")

    /// Define all the variables that the user might be able to change as state
    /// variables.
    ///
    /// This ensure that SwiftData does not save changes until the
    /// user is ready to submit and save those changes. Moreover, the user can
    /// discard changes if they don't like what they have entered.

    /// The name of the recipe
    @State private var name = ""

    /// An image for the recipe.
    ///
    /// Note that the photo is nullable because they don't have to include one.
    /// Or maybe they can add a picture of their own dish after they've cooked
    /// it once
    @State private var selectedPhoto: PhotosPickerItem? = nil

    /// The categories that the recipe falls under
    ///
    /// For example, this might be "breakfast", "easy", etc.
    /// Ideally, these categories are unique and may be reused across other
    /// recipes as well
    @State private var categories: [Category] = []

    /// The amount of time that it takes to prepare the recipe
    @State private var prepTime = ""

    /// The amount of time that it takes to cook the recipe
    @State private var cookTime = ""

    /// Any final remarks about the recipe
    @State private var comments = ""

    /// Describes how to make the recipe
    ///
    /// The instructions are parsed into an array of `Instruction` in
    /// `instructionArray`. It just needs to be a string so that we can use a
    /// text field
    @State private var instructions = ""

    /// Describes which ingredients are needed for the recipe
    ///
    /// The ingredients are parsed into an array of `Ingredient` in
    /// `ingredientArray`. It just needs to be a string so that we can use a
    /// text field
    @State private var ingredients = ""

    /// Dismiss pushes away the current context
    @Environment(\.dismiss) private var dismiss

    /// The model context contains the data for the application
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Form {
            RecipeEditorNameView(name: $name)
            RecipeEditorImageView(
                recipe: $recipe,
                selectedPhotoItem: $selectedPhoto
            )
            RecipeEditorTimeView(prepTime: $prepTime, cookTime: $cookTime)
            RecipeEditorCommentsView(comments: $comments)

            // TODO: I think it's better to use a different textfield because
            // we can't tab into it
            RecipeEditorText(
                title: "Instruction",
                input: $instructions
            )
            RecipeEditorText(
                title: "Ingredients",
                input: $ingredients
            )
        }
        .textFieldStyle(.roundedBorder)
        
        // Add buttons to the toolbar
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    withAnimation {
                        save()
                        dismiss()
                    }
                }
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
        .navigationTitle("Recipe Editor")
        .frame(minWidth: 600)
        .padding()
    }

    /// Save the recipe in the model context
    /// If we are editing a recipe, then update the recipe's properties
    private func save() {
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)

        // Get the instructinos and ingredients as arrays
        let instructions = Instruction.parseInstructions(instructions)
        let ingredients = Ingredient.parseIngredients(ingredients)

        // TODO: do more input validation here...
        if name.isEmpty {
            return
        }

        // Add a new recipe.
        let newRecipe = Recipe(
            name: name,
            imageData: recipe.imageData,
            categories: categories,
            prepTime: prepTime,
            cookTime: cookTime,
            comments: comments,
            ingredients: ingredients
        )

        // Remember to insert the recipe into the model context after
        modelContext.insert(newRecipe)

        // The item has to first exist in the model context before we can create
        // any links to other existing items!!
        newRecipe.updateInstructions(withInstructions: instructions)
    }
}

#Preview {
    RecipeEditorView()
}
