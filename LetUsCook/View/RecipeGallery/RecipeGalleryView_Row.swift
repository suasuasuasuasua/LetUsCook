//
//  RecipeGalleryIcon.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/10/24.
//

import SwiftUI

extension RecipeGalleryView {
    internal struct GalleryRow: View {
        let recipe: Recipe
        let iconSize: CGFloat

        var body: some View {
            HStack {
                // TODO add the image
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                    .cornerRadius(5)
                VStack(alignment: .leading) {
                    Text("\(recipe.name)")
                        .bold()
                    Group {
                        Text("Preparation Time: \(recipe.prepTime)")
                        Text("Cook: \(recipe.cookTime)")
                    }
                    .font(.caption)
                }
            }
            .padding(.vertical, 10)
        }
    }

}
