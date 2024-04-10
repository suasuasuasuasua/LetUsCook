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
        HeaderSectionText(
            text: "How long does this recipe take to cook?"
        )
        TextField("Preparation Time", text: $prepTime)
        TextField("Cooking Time", text: $cookTime)
    }
}
