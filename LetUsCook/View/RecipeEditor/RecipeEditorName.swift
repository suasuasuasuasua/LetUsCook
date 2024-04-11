//
//  RecipeEditorNameView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/3/24.
//

import SwiftUI

struct RecipeEditorNameView: View {
    @Binding var name: String

    var body: some View {
        Section("Name") {
            TextField(
                "",
                text: $name,
                prompt: Text("What is this recipe called?")
            )
        }
    }
}

#Preview {
    RecipeEditorNameView(name: .constant(""))
}
