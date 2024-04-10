//
//  RecipeEditorCategoriesView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/3/24.
//

import SwiftUI

struct RecipeEditorCategoriesView: View {
    @Binding var categories: [Category]

    var body: some View {
        List {
            ForEach(categories) { category in
                Text("\(category.name)")
            }
        }
    }
}

#Preview {
    let categories = [
        Category(name: "Breakfast"),
        Category(name: "Lunch"),
        Category(name: "Dinner"),
    ]

    return RecipeEditorCategoriesView(categories: .constant(categories))
}
