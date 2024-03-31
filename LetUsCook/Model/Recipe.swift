//
//  Recipe.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import Foundation
import SwiftData

@Model
final class Recipe {
    /// The name of the recipe
    // This name could be unique (well this may be a design decision because you
    // can have multiple ways to cook the same dish according to different
    // people)
    @Attribute(.unique)
    var name: String

    // TODO: store the photo not as a string
    var photo: String

    // TODO: should we be tracking the dates for the recipes?
    var creationDate: Date = Date()
    var updatedDate: Date? = nil

    // TODO: find a way to make categories unique as well
    var categories: [String] = []

    // TODO: add validation for the the times -- also don't make these strings
    /// The amount of time that it takes for you to prepare the dish
    var prepTime: String
    /// The amount of time that the dish takes to cook
    var cookTime: String

    /// Any remarks about the dish
    var comments: String

    /// The list of ingredients for the recipe
    // TODO: Probably need a helper function for this because we'll add the
    // ingredients line by line
    @Relationship(deleteRule: .cascade, inverse: \Ingredient.recipe)
    var ingredients: [Ingredient]

    /// The list of the instructions on how to make the recipe
    /// instructions one by one instead of adding all the instructions at once
    // TODO: Probably need a helper function for this because we'll add the
    // instructions line by line
//    @Relationship(deleteRule: .cascade, inverse: \Instruction.recipe)
    var instructions: [Instruction]

    init(
        name: String,
        photo: String,
        categories: [String],
        prepTime: String,
        cookTime: String,
        comments: String,
        ingredients: [Ingredient] = [],
        instructions: [Instruction] = []
    ) {
        self.name = name
        self.photo = photo
        self.categories = categories
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.comments = comments
        self.ingredients = ingredients
        self.instructions = instructions

        // TODO: cannot change mutable thing i guess
        // Point the ingredients and instructions back to the recipe
        for ingredient in ingredients {
            ingredient.recipe = self
        }
        
        for (i, instruction) in instructions.enumerated() {
            instruction.index = i
            instruction.recipe = self
        }
    }
}

extension Recipe: CustomStringConvertible {
    var description: String {
        """
        Recipe Name: \(name)
        Ingredients: \(ingredients)
        Instructions: \(instructions)
        """
    }
}
