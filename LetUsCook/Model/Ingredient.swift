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
    /// TODO: should I figure out a way to single-ton'ify this? I imagine that
    /// we will have tons of repeat ingredients like sugar, salt, water, etc.
    /// I could track a global counter of all the ingredients in the app.
    var name: String

    init(name: String) {
        self.name = name
    }
}
