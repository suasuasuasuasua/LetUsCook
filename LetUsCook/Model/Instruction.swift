//
//  Instruction.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import Foundation
import SwiftData

@Model
final class Instruction {
    /// The recipe that this instruction belongs to
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
