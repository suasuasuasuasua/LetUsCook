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
        HStack{
            Text("Image Here.")
                .frame(width: iconSize, height: iconSize)
                .border(.black)
            Text("\(recipe.name)")
                .bold()
        }
    }
}

#Preview {
    let recipe = Recipe(name: "Toast")
    let iconSize: CGFloat = 75

    return RecipeGalleryIcon(recipe: recipe, iconSize: iconSize)
}
