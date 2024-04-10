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
    let recipe: Recipe = Recipe(name: "New Recipe")

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
        NavigationStack {
            Form {
                Section {
                    TextField("Name:", text: $name)
                } header: {
                    HeaderSectionText(text: "What is this recipe called?")
                }

                // Image Picker
                Section {
                    PhotosPicker(selection: $selectedPhoto,
                                 matching: .images,
                                 photoLibrary: .shared())
                    {
                        Image(systemName: "pencil.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 30))
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.borderless)
                } header: {
                    HeaderSectionText(text: "Add an image!")
                } footer: {
                    // Delete button
                    if recipe.imageData != nil {
                        Button(role: .destructive) {
                            withAnimation {
                                self.selectedPhoto = nil
                                recipe.updateImageData(withData: nil)
                            }
                        } label: {
                            Label("Remove Image", systemImage: "xmark")
                                .foregroundStyle(.red)
                        }
                    }
                }

//                 TextField("TODO: Categories", text: $categories)

                // Time Related Attributes
                Section {
                    TextField("Preparation Time", text: $prepTime)
                    TextField("Cooking Time", text: $cookTime)
                } header: {
                    HeaderSectionText(
                        text: "How long does this recipe take to cook?"
                    )
                    .italic()
                    .foregroundStyle(.secondary)
                }.frame(alignment: .leading)

                Section {
                    TextField("Comments:", text: $comments, axis: .vertical)
                        .lineLimit(1 ... 3)
                } header: {
                    HeaderSectionText(
                        text: "Any final comments about the recipe?"
                    )
                }
            }
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

            // TODO: don't make it on another page like this
            NavigationLink(
                "Instructions",
                destination: RecipeTextEditorView(
                    title: "Instruction",
                    input: $instructions
                )
            )
            NavigationLink(
                "Ingredients",
                destination: RecipeTextEditorView(
                    title: "Ingredients",
                    input: $ingredients
                )
            )
        }
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

        // Update the instructions
        newRecipe.updateInstructions(withInstructions: instructions)
    }
}

struct RecipeTextEditorView: View {
    var title: String
    @Binding var input: String

    var body: some View {
        TextEditor(text: $input)
            .foregroundStyle(.secondary)
            .navigationTitle(title)
            .padding()
    }
}

struct HeaderSectionText: View {
    var text: String

    var body: some View {
        Text("\(text)")
            .italic()
            .foregroundStyle(.secondary)
    }
}
