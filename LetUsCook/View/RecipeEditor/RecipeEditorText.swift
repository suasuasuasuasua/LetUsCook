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
        HeaderSectionText(text: title)
        TextEditor(text: $input)
            .foregroundStyle(.secondary)
            .navigationTitle(title)
    }
}

struct HeaderSectionText: View {
    var text: String

    var body: some View {
        Text("\(text)")
            .italic()
            .foregroundStyle(.secondary)
    }
}

#Preview {
    RecipeEditorText(
        title: "Ingredients",
        input: .constant("Ingredient 1\nIngredient 2")
    )
}
