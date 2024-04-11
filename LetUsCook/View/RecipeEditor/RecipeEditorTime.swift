//
//  RecipeTimeView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/3/24.
//

import SwiftUI

struct RecipeEditorTimeView: View {
    @Binding var prepTime: String
    @Binding var cookTime: String

    var body: some View {
        Section("Time") {
            TextField(
                "Preparation Time",
                text: $prepTime,
                prompt: Text("How long does this recipe take to prepare?")
            )
            TextField(
                "Cooking Time",
                text: $cookTime,
                prompt: Text("How long does this recipe take to cook?")
            )
        }
    }
}

#Preview {
    RecipeEditorTimeView(
        prepTime: .constant("Prep Time"),
        cookTime: .constant("Cook Time")
    )
}
