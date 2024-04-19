//
//  RecipeView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftData
import SwiftUI

/// Focus on a single recipe in the app
///
/// - Allow the user to read and scroll through the recipe
/// - The user should be able to preview everything about the recipe like...
///     - the creation date
///     - times referenced (maybe a stretch goal)
///     - the ingredients as a list (could put preview images pulled from some
///       database) or just used icons
///         - Could also figure out how Apple auto-categorizes the grocery list
///           in Reminders
///     - the instruction for the recipe
/// - The user should be able to edit the recipe by clicking a button
/// - The user should be able to delete the recipe by click another button
/// - The should be able to share the recipe, which exports the recipe to...
///     - A plaintext formatted string
///     - JSON (I like this idea)
///     - Some weird proprietary format that I choose
struct RecipeView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var isDeleting = false
    var recipe: Recipe?

    var body: some View {
        if let recipe {
            RecipeContent(recipe: recipe)
                // Define the toolbar when selecting a recipe
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        // If the user presses the delete button, set an alert
                        // boolean
                        Button {
                            isDeleting = true
                        } label: {
                            Label("Delete", systemImage: "minus")
                        }
                    }
                    ToolbarItem {
                        Button {
                            // TODO: implement the share option
                            print("Share!")
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                }
                // When the alert boolean is set, show the delete context
                .confirmationDialog(
                    // TODO: maybe I should move it to the trash instead?
                    "Are you sure you want to delete the recipe permanently?",
                    isPresented: $isDeleting,
                    presenting: recipe
                ) { recipe in
                    Button(role: .destructive) {
                        delete(recipe)
                    } label: {
                        Text("Delete")
                    }
                    Button("Cancel", role: .cancel) {}
                } message: { _ in
                    // TODO: but what if it could be undone?
                    // Maybe send to the trash instead
                    Text("You cannot undo this action.")
                }
                .padding()
        } else {
            ContentUnavailableView("Select a recipe!", image: "fork.knife")
        }
    }

    private func delete(_ recipe: Recipe) {
        // navigationContext.selectedRecipe = nil
        modelContext.delete(recipe)
    }
}

extension RecipeView {
    private struct RecipeContent: View {
        // https://stackoverflow.com/questions/61437905/swiftui-list-is-not-showing-any-items
        @Environment(\.defaultMinListRowHeight) var minRowHeight
        var recipe: Recipe

        @State private var name: String
        @State private var prepTime: String
        @State private var cookTime: String
        @State private var comments: String

        init(recipe: Recipe) {
            self.recipe = recipe
            name = recipe.name
            prepTime = recipe.prepTime
            cookTime = recipe.cookTime
            comments = recipe.comments
        }

        // TODO: should use a viewmodel instead
        var instructions: [Instruction] {
            recipe.instructions.sorted {
                $0.index < $1.index
            }
        }

        var ingredients: [Ingredient] {
            recipe.ingredients.sorted {
                $0.name < $1.name
            }
        }

        var body: some View {
            ScrollView {
                VStack(spacing: 20.0) {
                    TextField("", text: $name)
                        .onSubmit {
                            // TODO: we should only be able to save recipes that have
                            // unique names
                            recipe.name = name
                        }
                        .font(.title)
                    HStack(alignment: .top, spacing: 24.0) {
                        Image(systemName: "photo")
                            .resizable()
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(.white, lineWidth: 4)
                            }
                            .shadow(radius: 7)
                            .frame(width: 160, height: 160)

                        Divider()

                        VStack(alignment: .leading) {
                            Text("Preparation Time")
                                .font(.headline)
                            TextField("", text: $prepTime)
                                .onSubmit {
                                    recipe.prepTime = prepTime
                                }
                                .font(.subheadline)
                            Text("Cooking Time")
                                .font(.headline)
                            TextField("", text: $cookTime)
                                .onSubmit {
                                    recipe.cookTime = cookTime
                                }
                                .font(.subheadline)
                        }

                        Divider()

                        VStack(alignment: .leading) {
                            Text("Comments")
                                .font(.headline)
                            TextField("", text: $comments)
                                .onSubmit {
                                    recipe.comments = comments
                                }
                                .font(.subheadline)
                        }
                    }
                }

                Divider()

                VStack {
                    Text("Instructions")
                        .font(.title)
                    List(instructions) { instruction in
                        Text("\(instruction.index). \(instruction.text)")
                    }
                    .frame(minHeight: minRowHeight * 10)
                    Text("Ingredients")
                        .font(.title)
                    List(ingredients) { ingredient in
                        Text("\(ingredient.name)")
                    }
                    .frame(minHeight: minRowHeight * 10)
                }
            }
        }
    }
}
