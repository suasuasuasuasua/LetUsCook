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
        HSplitView {
            VStack {
                if let imageData = recipe.image,
                   let image = NSImage(data: imageData)
                {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
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
            .frame(minWidth: 200, maxHeight: .infinity)
            Grid {
                GridRow {
                    Text("Instructions")
                    Text("Ingredients")
                }
                .fontWeight(.heavy)
                .font(.system(size: 30.0))
                GridRow {
                    List {
                        if let instructions = recipe.instructions {
                            ForEach(instructions.sorted(by: { i1, i2 in
                                i1.index < i2.index
                            })) { instruction in
                                let text =
                                    "\(instruction.index). \(instruction.text)"
                                Text("\(text)")
                            }
                        }
                    }
                    List {
                        if let ingredients = recipe.ingredients {
                            ForEach(ingredients.sorted(by: { i1, i2 in
                                i1.name < i2.name
                            })) { ingredient in
                                let text = "\(ingredient.name)"
                                Text("\(text)")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("\(recipe.name)")
        .padding()
    }
}
