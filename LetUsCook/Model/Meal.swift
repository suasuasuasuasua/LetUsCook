//
//  Meals.swift
//  LetUsCook
//
//  Created by Justin Hoang on 5/2/24.
//

import Foundation
import SwiftData

@Model
final class Meal: Identifiable {
    var id = UUID()
    var recipe: Recipe?

    init(recipe: Recipe? = nil) {
        self.recipe = recipe
    }
}
