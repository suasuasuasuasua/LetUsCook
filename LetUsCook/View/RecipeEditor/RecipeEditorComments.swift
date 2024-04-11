//
//  RecipeEditorCommentsView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/3/24.
//

import SwiftUI

struct RecipeEditorCommentsView: View {
    @Binding var comments: String

    var body: some View {
        Section("Comments") {
            TextField(
                "",
                text: $comments,
                prompt: Text("Any final comments?"),
                axis: .vertical
            )
            .lineLimit(1 ... 3)
        }
    }
}

#Preview {
    let comments = "Blah blah blah\nThis is a comment!"

    return RecipeEditorCommentsView(comments: .constant(comments))
}
