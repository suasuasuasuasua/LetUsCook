//
//  Item.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/28/24.
//

import Foundation
import SwiftData

@Model
final class Ingredient {
    /// The name of the ingredient
    // TODO: i want the ingredients to be unique
    //    @Attribute(.unique)
    var name: String

    init(name: String) {
        self.name = name
    }
}

extension Ingredient: CustomStringConvertible {
    var description: String {
        """
        Name: \(name)
        """
    }
}

extension Ingredient {
    /// The `ingredient` string from the textfield as an array of
    /// `Ingredient`
    static func parseIngredients(_ ingredients: String) -> [Ingredient] {
        return ingredients.isEmpty
            ? []
            : ingredients.components(separatedBy: .newlines)
            .map { ingredient in
                Ingredient(name: ingredient.trimmingCharacters(
                    in: .whitespaces
                ))
            }
    }
    
    static func asString(_ ingredients: [Ingredient]) -> String {
        return ingredients.reduce("") { acc, cur in
            acc + cur.name + "\n"
        }
    }
}
