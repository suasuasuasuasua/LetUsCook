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
    /// The instruction counter
    var index: Int
    /// The recipe that this instruction belongs to
    var recipe: Recipe?
    
    /// The instruction
    var text: String
    
    init(index: Int, recipe: Recipe, text: String) {
        self.index = index
        self.recipe = recipe
        self.text = text
    }
}
