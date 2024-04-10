//
//  RecipeGalleryIcon.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/10/24.
//

import SwiftUI

struct RecipeGalleryIcon: View {
    let recipe: Recipe
    let iconSize: CGFloat

    var body: some View {
        VStack(alignment: .center) {
            Text("Image Here.")
            Text("\(recipe.name)")
                .bold()
        }
        .frame(width: iconSize, height: iconSize)
    }
}

#Preview {
    let recipe = Recipe(name: "Toast")
    let iconSize: CGFloat = 50

    return RecipeGalleryIcon(recipe: recipe, iconSize: iconSize)
}
