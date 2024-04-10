//
//  RecipeGalleryView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftData
import SwiftUI

/// View all the recipes that the user has in a gallery style.
///
/// The user should be able to...
/// - Allow list and grid view with fine tuner selector
/// - Show preview picture and estimated cooking time of the meal
/// - Quick edit or delete from the gallery using a right-click
struct RecipeGalleryView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Recipe.name) private var recipes: [Recipe]
    var iconSize = 150.0

    var body: some View {
        ScrollView(.vertical) {
            // TODO: refactor to make this less hardcoded in the future
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 200, maximum: 400))],
                spacing: 10
            ) {
                ForEach(recipes) { recipe in
                    NavigationLink(
                        destination: { RecipeView(recipe: recipe) },
                        label: {
                            VStack(alignment: .center) {
                                //                                    if let
                                //                                    imageData
                                //                                    = recipe.imageData,
                                //                                       let
                                //                                       image = NSImage(data:
                                //                                       imageData)
                                //                                    {
                                //                                        Image(nsImage: image)
                                //                                            .resizable()
                                //                                            .scaledToFit()
                                //                                            .clipShape(RoundedRectangle(
                                //                                                cornerRadius: 10,
                                //                                                style: .continuous
                                //                                            ))
                                //                                    }
                                Text("Image Here.")
                                Text("\(recipe.name)")
                                    .bold()
                            }
                            .frame(width: iconSize, height: iconSize)
                        }
                    )
                }
            }
            .navigationTitle("Recipe Gallery")
        }
        .padding()
    }
}
