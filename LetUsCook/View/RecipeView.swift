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
    @Environment(\.modelContext) private var modelContext
    @State private var deleteRecipe = false

    var recipe: Recipe

    var body: some View {
        // TODO: use a HSplitView
        HStack {
            VStack(alignment: .leading) {
                Text("Image here.")
                    .padding()
                    .border(.black)
                LabeledContent("Preparation Time") {
                    Text("\(recipe.prepTime)")
                }.frame(alignment: .leading)
                LabeledContent("Cooking Time") {
                    Text("\(recipe.cookTime)")
                }.frame(alignment: .leading)
                LabeledContent("Comments") {
                    Text("\(recipe.comments)")
                }.frame(alignment: .leading)
            }
            .fontWeight(.semibold)
            .font(.system(size: 16.0))

            VStack {
                Text("Instructions")
                    .fontWeight(.heavy)
                    .font(.system(size: 30.0))
                List(recipe.instructions) { instruction in
                    Text("\(instruction.index). \(instruction.text)")
                }
                Text("Ingredients")
                    .fontWeight(.heavy)
                    .font(.system(size: 30.0))
                List(recipe.ingredients) { ingredient in
                    Text("\(ingredient.name)")
                }
            }
            .frame(idealHeight: .infinity)
        }
        .padding()
        .frame(
            minWidth: 600,
            maxWidth: .infinity,
            minHeight: 600,
            maxHeight: .infinity
        )

        // Define the toolbar when selecting a recipe
        // We want to be able to edit the current recipe or delete it
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    // TODO: add a way to edit the recipe
                    print("Edit!")
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                // If the user presses the delete button, set an alert boolean
                Button {
                    deleteRecipe = true
                } label: {
                    Label("Delete", systemImage: "minus")
                }
            }
        }
        // When the alert boolean is set, show the delete context
        .alert(
            "Are you sure you want to delete the recipe permanently?",
            isPresented: $deleteRecipe,
            presenting: recipe
        ) { recipe in
            Button(role: .destructive) {
                modelContext.delete(recipe)
            } label: {
                Text("Delete")
            }
            Button("Cancel", role: .cancel) {}
        } message: { _ in
            // TODO: but what if it could be undone?
            // Maybe send to the trash instead
            Text("You cannot undo this action.")
        }
    }
}

#Preview {
    let recipe = Recipe(
        name: "Toast",
        prepTime: "5 minutes",
        cookTime: "5 minutes",
        comments: "Some toast!"
    )

    return RecipeView(recipe: recipe)
}
