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

    // TODO: I think an ingredient should point to many recipes, but I'm not
    // sure about how to annotate that
    var recipe: Recipe?

    init(name: String) {
        self.name = name
    }
}

extension Ingredient: CustomStringConvertible {
    var description: String {
        """
        Name: \(name)
            Recipe: \(String(describing: recipe?.name))
        """
    }
}

extension Array where Element == Ingredient {
    var description: String {
        return map(String.init)
            .joined(separator: ",")
    }
}
