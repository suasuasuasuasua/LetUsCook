//
//  Category.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/31/24.
//

import Foundation
import SwiftData

@Model
final class Category {
    /// The name of the category
    /// I want this to be unique so that we can use the same categories globally
    @Attribute(.unique)
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
