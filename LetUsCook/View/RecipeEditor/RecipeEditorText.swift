//
//  RecipeEditorText.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/10/24.
//

import SwiftUI

struct RecipeEditorText: View {
    var title: String
    @Binding var input: String

    var body: some View {
        Section(title) {
            TextEditor(text: $input)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    RecipeEditorText(
        title: "Ingredients",
        input: .constant("Ingredient 1\nIngredient 2")
    )
}
