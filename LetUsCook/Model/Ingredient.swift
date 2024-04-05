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
    @Attribute(.unique)
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
        return ingredients.components(separatedBy: .newlines)
            .map { ingredient in
                Ingredient(name: ingredient.trimmingCharacters(
                    in: .whitespaces
                ))
            }
    }
}

extension Array where Element == Ingredient {
    var description: String {
        return map(String.init)
            .joined(separator: ",")
    }
}
