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
    /// The recipe that we are currently viewing
    ///
    /// If the recipe is `nil`, that means we are creating a recipe in the view.
    /// Otherwise, we are editing a recipe.
    /// Regardless, the data entered by the user create or edit the recipe.
    let recipe: Recipe?

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
    @State private var selectedPhotoData: Data? = nil

    /// The categories that the recipe falls under
    ///
    /// For example, this might be "breakfast", "easy", etc.
    /// Ideally, these categories are unique and may be reused across other
    /// recipes as well
    @State private var categories: [String] = []

    // TODO: add validation for the the times; also don't use strings maybe
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

    /// The `instruction` string from the textfield as an array of `Instruction`
    ///
    /// Currently, we are separating by newlines but Mela does a cool thing
    /// where it seems a new textfield is created each time we press 'Enter'.
    /// The textfields are also automatically labelled with 1, 2, 3, etc.
    var instructionsArray: [Instruction] {
        instructions.components(separatedBy: .newlines)
            .map { instruction in
                Instruction(text: instruction.trimmingCharacters(
                    in: .whitespaces
                ))
            }
    }

    /// The `ingredient` string from the textfield as an array of `Ingredient`
    var ingredientsArray: [Ingredient] {
        ingredients.components(separatedBy: .newlines)
            .map { ingredient in
                Ingredient(name: ingredient.trimmingCharacters(
                    in: .whitespaces
                ))
            }
    }

    /// We can share the editor view for creating and editing recipes in.
    /// The title will just depend on whether there is a recipe yet or not
    ///
    /// https://developer.apple.com/documentation/swiftdata/adding-and-editing-persistent-data-in-your-app
    private var editorTitle: String {
        recipe == nil
            ? "Add Recipe"
            : "Edit Recipe"
    }

    /// Dismiss pushes away the current context
    @Environment(\.dismiss) private var dismiss

    /// The model context contains the data for the application
    @Environment(\.modelContext) private var modelContext
    
    /// The size of the preview image
    var imageSize = 50.0

    var body: some View {
        NavigationStack {
            Form {
                // The name of the proposed recipe
                TextField("Name:", text: $name)

                // Image Picker
                Section {
                    // Preview the photo if one has been selected
                    if let selectedPhotoData,
                       let image = NSImage(data: selectedPhotoData)
                    {
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageSize, height: imageSize)
                    }
                    HStack {
                        // Photo selector option
                        PhotosPicker(selection: $selectedPhoto,
                                     matching: .images,
                                     photoLibrary: .shared())
                        {
                            Label("Add Image", systemImage: "photo")
                        }
                        // Delete button
                        if selectedPhotoData != nil {
                            Button(role: .destructive) {
                                withAnimation {
                                    self.selectedPhoto = nil
                                    self.selectedPhotoData = nil
                                }
                            } label: {
                                Label("Remove Image", systemImage: "xmark")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }

                // TextField("TODO: Categories", text: $categories)

                // Time Related Attributes
                Section {
                    TextField("Preparation Time:", text: $prepTime)
                    TextField("Cooking Time:", text: $cookTime)
                }

                TextField("Comments:", text: $comments, axis: .vertical)
                    .lineLimit(1 ... 3)
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
            .onAppear {
                /// If we are editing a recipe, then we don't want to use
                /// default values in the editor. This ensures that we use
                /// up-to-date properties for the recipe when editing it
                if let recipe {
                    name = recipe.name
                    selectedPhotoData = recipe.image
                    categories = recipe.categories
                    prepTime = recipe.prepTime
                    cookTime = recipe.cookTime
                    comments = recipe.comments
                }
            }
            /// Perform an async function whenever the photo value changes
            .task(id: selectedPhoto) {
                // Try to turn the photo into data
                if let data = try? await selectedPhoto?
                    .loadTransferable(type: Data.self)
                {
                    selectedPhotoData = data
                } else {
                    print("Could not turn the photo into data!")
                }
            }
            .navigationTitle("Recipe Editor")

            // TODO: don't make it on another page like this...lol
            NavigationLink(
                "Instructions",
                destination: InstructionEditor(instructions: $instructions)
            )
            NavigationLink(
                "Ingredients",
                destination: IngredientEditor(ingredients: $ingredients)
            )
        }
        .frame(minWidth: 600)
        .padding()
    }

    /// Save the recipe in the model context
    /// If we are editing a recipe, then update the recipe's properties
    private func save() {
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)

        // TODO: do more input validation here...
        if name.isEmpty {
            return
        }

        if let recipe {
            // Edit the recipe
            recipe.name = name
            recipe.image = selectedPhotoData
            recipe.categories = categories
            recipe.prepTime = prepTime
            recipe.cookTime = cookTime
            recipe.comments = comments

            recipe.instructions = instructionsArray
            recipe.ingredients = ingredientsArray
        } else {
            // Add a new recipe.
            let newRecipe = Recipe(
                name: name,
                image: selectedPhotoData,
                categories: categories,
                prepTime: prepTime,
                cookTime: cookTime,
                comments: comments,
                ingredients: ingredientsArray
            )

            print(newRecipe.image == nil)

            // Remember to insert the recipe into the model context after
            modelContext.insert(newRecipe)

            // Update the instructions
            newRecipe.updateInstructions(withInstructions: instructionsArray)
        }
    }
}

struct InstructionEditor: View {
    @Binding var instructions: String

    var body: some View {
        TextEditor(text: $instructions)
            .foregroundStyle(.secondary)
            .navigationTitle("Instructions")
            .padding()
    }
}

struct IngredientEditor: View {
    @Binding var ingredients: String

    var body: some View {
        TextEditor(text: $ingredients)
            .foregroundStyle(.secondary)
            .navigationTitle("Ingredients")
            .padding()
    }
}
