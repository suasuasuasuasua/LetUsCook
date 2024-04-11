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

extension Instruction {
    /// The `instruction` string from the textfield as an array of
    /// `Instruction`
    ///
    /// Currently, we are separating by newlines but Mela does a cool thing
    /// where it seems a new textfield is created each time we press
    /// 'Enter'.
    /// The textfields are also automatically labelled with 1, 2, 3, etc.
    static func parseInstructions(_ instructions: String) -> [Instruction] {
        return instructions.isEmpty
            ? []
            : instructions.components(separatedBy: .newlines)
            .map { instruction in
                Instruction(text: instruction.trimmingCharacters(
                    in: .whitespaces
                ))
            }
    }
}
