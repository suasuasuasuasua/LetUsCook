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
final class Recipe {
    /// The name of the recipe
    /// This name could be unique (well this may be a design decision because
    /// you can have multiple ways to cook the same dish according to different
    /// people)
    @Attribute(.unique)
    var name: String

    /// Store the image as a string of bytes or just `Data`
    @Attribute(.externalStorage)
    var imageData: Data? = nil

//    // TODO: should we be tracking the dates for the recipes?
//    var creationDate: Date
//    var updatedDate: Date?

    // TODO: find a way to make categories unique as well
    var categories: [String]

    // TODO: add validation for the the times -- also don't make these strings
    /// The amount of time that it takes for you to prepare the dish
    var prepTime: String
    /// The amount of time that the dish takes to cook
    var cookTime: String

    /// Any remarks about the dish
    var comments: String

    /// The list of ingredients for the recipe
    @Relationship(deleteRule: .cascade)
    var ingredients: [Ingredient]?

    /// The list of the instructions on how to make the recipe
    /// instructions one by one instead of adding all the instructions at once
    @Relationship(deleteRule: .cascade, inverse: \Instruction.recipe)
    var instructions: [Instruction]?

    init(
        name: String,
        categories: [String] = [],
        prepTime: String = "",
        cookTime: String = "",
        comments: String = "",
        ingredients: [Ingredient]? = [],
        instructions: [Instruction]? = []
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
        return if let ingredients = ingredients,
                  let instructions = instructions
        {
            """
            Recipe Name: \(name)
            Ingredients: \(ingredients)
            Instructions: \(instructions)
            """
        } else {
            """
            Recipe Name: \(name)
            Ingredients or instructions is nil..
            """
        }
    }
}

/// Helper functions for the Recipe
extension Recipe {
    /// Update the instructions for a recipe
    ///
    /// The reason why we need to update the `Instrucion`s separately is because
    /// we want the `Instruction` to reference the `Recipe`, but technically the
    /// `Recipe` doesn't exist yet in the `modelContext`.
    func updateInstructions(withInstructions instructions: [Instruction]) {
        for (i, instruction) in instructions.enumerated() {
            // Start indexing from 1
            let i = i + 1
            instruction.index = i
            instruction.recipe = self
        }

        self.instructions = instructions
    }

    func updateImageData(withData data: Data?) {
        imageData = data
    }
}
