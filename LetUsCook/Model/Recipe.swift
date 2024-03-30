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
    /// TODO: should this be assigned at the end of the recipe?
    var ingredients: [Ingredient] = []

    /// The list of the instructions on how to make the recipe
    /// TODO: Probably need a helper function for this because we'll add
    /// instructions one by one instead of adding all the instructions at once
    var instructions: [Instruction] = []

    init(name: String) {
        self.name = name
    }
}
