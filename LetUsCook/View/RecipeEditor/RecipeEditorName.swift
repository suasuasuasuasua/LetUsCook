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
        HeaderSectionText(text: "What is this recipe called?")
        TextField("Name:", text: $name)
    }
}
