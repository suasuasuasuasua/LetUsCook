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
    let recipe: Recipe

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
    @State private var photoSelected: Bool = false

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

    /// Dismiss pushes away the current context
    @Environment(\.dismiss) private var dismiss

    /// The model context contains the data for the application
    @Environment(\.modelContext) private var modelContext

    /// The size of the preview image
    var imageSize = 50.0

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // The name of the proposed recipe
                    TextField("Name:", text: $name)
                } header: {
                    HeaderSectionText(text: "What is this recipe called?")
                }

                // Image Picker
                Section {
//                    // TODO: if i display the image, it becomes hella laggy
//                    // At least for "larger images" like 2mb+
//                    if let imageData = recipe.imageData,
//                       let image = NSImage(data: imageData)
//                    {
//                        Text("Image size \(imageData.count)")
//                        Image(nsImage: image)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 100, height: 100)
//                    }

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
                    //                    EditableRectangularRecipeImage(
                    //                        selectedPhoto: $selectedPhoto,
                    //                        photoSelected: $photoSelected
                    //                    )
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

                // TextField("TODO: Categories", text: $categories)

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
            .onAppear {
                /// If we are editing a recipe, then we don't want to use
                /// default values in the editor. This ensures that we use
                /// up-to-date properties for the recipe when editing it
                name = recipe.name
            }
            /// Perform an async function whenever the photo value changes
            .task(id: selectedPhoto) {
                // Try to turn the photo into data
                if let data = try? await selectedPhoto?
                    .loadTransferable(type: Data.self)
                {
                    recipe.updateImageData(withData: data)
                } else {
                    print("Could not turn the photo into data!")
                }
            }
            .navigationTitle("Recipe Editor")
            .padding()

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

        /// The `instruction` string from the textfield as an array of
        /// `Instruction`
        ///
        /// Currently, we are separating by newlines but Mela does a cool thing
        /// where it seems a new textfield is created each time we press
        /// 'Enter'.
        /// The textfields are also automatically labelled with 1, 2, 3, etc.
        var instructionsArray: [Instruction] {
            instructions.components(separatedBy: .newlines)
                .map { instruction in
                    Instruction(text: instruction.trimmingCharacters(
                        in: .whitespaces
                    ))
                }
        }

        /// The `ingredient` string from the textfield as an array of
        /// `Ingredient`
        var ingredientsArray: [Ingredient] {
            ingredients.components(separatedBy: .newlines)
                .map { ingredient in
                    Ingredient(name: ingredient.trimmingCharacters(
                        in: .whitespaces
                    ))
                }
        }
        // TODO: do more input validation here...
        if name.isEmpty {
            return
        }
        // Add a new recipe.
        let newRecipe = Recipe(
            name: name,
            categories: categories,
            prepTime: prepTime,
            cookTime: cookTime,
            comments: comments,
            ingredients: ingredientsArray
        )

        // Remember to insert the recipe into the model context after
        modelContext.insert(newRecipe)

        // Update the instructions
        newRecipe.updateInstructions(withInstructions: instructionsArray)
        newRecipe.updateImageData(withData: recipe.imageData)
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

struct HeaderSectionText: View {
    var text: String

    var body: some View {
        Text("\(text)")
            .italic()
            .foregroundStyle(.secondary)
    }
}

struct RectangularRecipeImage: View {
    var body: some View {
        Image(systemName: "takeoutbag.and.cup.and.straw.fill")
            .font(.system(size: 40))
            .foregroundStyle(.white)
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .frame(width: 100, height: 100)
            .background {
                RoundedRectangle(cornerRadius: 10.0).fill(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
    }
}

struct EditableRectangularRecipeImage: View {
    @Binding var selectedPhoto: PhotosPickerItem?
    @Binding var photoSelected: Bool

    var body: some View {
        // TODO: do we really need a viewmodel for this?
        RectangularRecipeImage()
            .overlay(alignment: .bottomTrailing) {
                // Photo selector option
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
            }
    }
}

enum ImageState {
    case empty
    case loading(Progress)
    case success(Image)
    case failure(Error)
}
