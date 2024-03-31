//
//  RecipeView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

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
    var recipe: Recipe

    var body: some View {
        Grid {
            GridRow {
                Text("Preparation Time: \(recipe.prepTime)")
                Text("Cook Time: \(recipe.cookTime)")
                Text("Comments: \(recipe.comments)")
            }
            GridRow {
                // TODO: these need to be sorted by index
                VStack {
                    if let instructions = recipe.instructions {
                        ForEach(instructions) { instruction in
                            let text = "\(instruction.index). \(instruction.text)"
                            Text("\(text)")
                        }
                    }
                }
                // TODO: these need to be sorted by alphabetically
                VStack {
                    if let ingredients = recipe.ingredients {
                        ForEach(ingredients) { ingredient in
                            let text = "\(ingredient.name)"
                            Text("\(text)")
                        }
                    }
                }
            }
        }
        .navigationTitle("\(recipe.name)")
    }
}
