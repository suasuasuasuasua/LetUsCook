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

    // - cache the photos and ask the user where to store the images
    // - look into ApplicationSupport
    // - look into urlcache
    /// Store a reference URL to the image on the users' system
    // TODO: we should ask the user where they want to store the data
    @Attribute(.externalStorage)
    var imageData: Data?

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
        imageData: Data? = nil,
        categories: [Category] = [],
        prepTime: String = "",
        cookTime: String = "",
        comments: String = "",
        instructions: [Instruction] = [],
        ingredients: [Ingredient] = []
    ) {
        self.name = name
        self.imageData = imageData
        self.categories = categories
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.comments = comments
        self.instructions = instructions
        self.ingredients = ingredients
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
    /// The reason why we need to update the `Instruction`s separately is because
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
}
