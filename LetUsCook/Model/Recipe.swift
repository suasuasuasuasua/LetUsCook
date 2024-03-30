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
    var name: String

    /// The list of ingredients for the recipe
    /// Use this `@Relationship(deleteRule: .cascade, inverse: \...)`
    // TODO: should this be assigned at the end of the recipe?
    var ingredients: [Ingredient] = []

    /// The list of the instructions on how to make the recipe
    /// instructions one by one instead of adding all the instructions at once
    // TODO: Probably need a helper function for this because we'll add the
    // instructions line by line
    var instructions: [Instruction] = []

    init(name: String) {
        self.name = name
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
