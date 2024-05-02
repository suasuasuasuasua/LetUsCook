//
//  Recipe.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Recipe: Identifiable {
    /// The name of the recipe
    /// This name could be unique (well this may be a design decision because
    /// you can have multiple ways to cook the same dish according to different
    /// people)
    @Attribute(.unique)
    var id = UUID()

    var name: String

    var dateCreated: Date = Date.now

    /// Store a reference URL to the image on the users' system
    var imageURL: URL?

    /// The categories or tags that the recipe has
    var categories: [Category]

    /// The amount of time that it takes for you to prepare the dish
    var prepTime: String
    /// The amount of time that the dish takes to cook
    var cookTime: String

    /// Any final remarks about the dish
    var comments: String

    /// The list of ingredients for the recipe
    var ingredients: [Ingredient]

    /// The list of the instructions on how to make the recipe
    /// instructions one by one instead of adding all the instructions at once
    @Relationship(deleteRule: .cascade, inverse: \Instruction.recipe)
    var instructions: [Instruction]

    init(
        name: String,
        imageData: URL? = nil,
        categories: [Category] = [],
        prepTime: String = "",
        cookTime: String = "",
        comments: String = "",
        instructions: [Instruction] = [],
        ingredients: [Ingredient] = []
    ) {
        self.name = name
        self.categories = categories
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.comments = comments
        self.ingredients = ingredients
        self.instructions = instructions
    }
}

extension Recipe: CustomStringConvertible {
    var description: String {
        return """
        Recipe Name: \(name)
        Ingredients: \(ingredients)
        Instructions: \(instructions)
        """
    }
}

extension Recipe {
    /// Update the instructions for a recipe
    ///
    /// The reason why we need to update the `Instruction`s separately is
    /// because
    /// we want the `Instruction` to reference the `Recipe`, but technically the
    /// `Recipe` doesn't exist yet in the `modelContext`.
    func updateInstructions(withInstructions instructions: [Instruction]) {
        for (i, instruction) in instructions.enumerated() {
            instruction.index = i + 1
            instruction.recipe = self
        }
        self.instructions = instructions
    }

    func updateIngredients(withIngredients ingredients: [Ingredient]) {
//        https://stackoverflow.com/a/27624476
        var uniqueIngredients: [Ingredient] = []
        for item in ingredients {
            if !uniqueIngredients.contains(item) {
                uniqueIngredients.append(item)
            }
        }

        for (i, ingredient) in uniqueIngredients.enumerated() {
            ingredient.index = i + 1
        }

        self.ingredients = ingredients
    }
}

// https://stackoverflow.com/questions/27624331/unique-values-of-array-in-swift
extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
