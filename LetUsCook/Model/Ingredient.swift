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
