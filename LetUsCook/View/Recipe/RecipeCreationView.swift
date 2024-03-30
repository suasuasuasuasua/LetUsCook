//
//  RecipeCreationView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftUI

/// View for creating a recipe
///
/// The fields I am imagining are:
/// - Title - the name of the recipe
/// - Photo - just allow the user to upload one of their own or an online one --
///   hopefully it's something that they made themselves :)
/// - Categories for filtering -- this will probably be a comma separated list
///   of tags (global counter of course)
/// - Time required for the recipe divided up into prep and cooking time
///     - Mela doesn't seem to have any input validation here. We can put
///       hour and minute dials to ensure that the user always puts a valid
///       number
/// - Comments - a brief description about the recipe
///
/// - The instructions line by line
/// - The ingredients line by line -- this may have auto-complete or a similar
///   syntax highlighting to Mela for leading numbers like **1/4** quarts water
///   and **2** eggs
struct RecipeCreationView: View {
    var body: some View {
        Text("Recipe Creation View")
    }
}

#Preview {
    RecipeCreationView()
}
