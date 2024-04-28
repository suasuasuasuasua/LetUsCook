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
    @Attribute(.unique)
    var id = UUID()

    /// The instruction counter of the instruction
    var index: Int
    /// The recipe that this instruction belongs to
    var recipe: Recipe?
    /// The instruction as a description
    var text: String

    init(index: Int = 0, recipe: Recipe? = nil, text: String) {
        self.index = index
        self.recipe = recipe
        self.text = text
    }
}

extension Instruction: CustomStringConvertible {
    var description: String {
        """
        Recipe: \(String(describing: recipe?.name)), Index: \(index), \(text)
        """
    }
}
