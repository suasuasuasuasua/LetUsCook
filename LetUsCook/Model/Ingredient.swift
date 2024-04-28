//
//  Item.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/28/24.
//

import Foundation
import SwiftData

@Model
final class Ingredient: Identifiable {
    /// The name of the ingredient
    @Attribute(.unique)
    var id = UUID()
    var name: String

    var index: Int

    init(name: String, index: Int = 0) {
        self.name = name
        self.index = index
    }
}

extension Ingredient: CustomStringConvertible {
    var description: String {
        """
        Name: \(name)
        """
    }
}
