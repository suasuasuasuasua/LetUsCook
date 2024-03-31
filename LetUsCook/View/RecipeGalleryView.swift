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
    @Environment(NavigationContext.self) private var navigationContext
    @Query(sort: \Recipe.name) private var recipes: [Recipe]

    var body: some View {
        NavigationStack {
            RecipeGallery(recipes: recipes)
        }
    }
}

struct RecipeGallery: View {
    var recipes: [Recipe]
//    @Binding var editing: Bool
//    let selectRecipe: (Recipe) -> Void
//    let addRecipe: () -> Void

    var body: some View {
        Text("Recipe Gallery")
        
        Table(recipes) {
            TableColumn("Name", value: \.name)
            TableColumn("Prep Time", value: \.prepTime)
            TableColumn("Cook Time", value: \.cookTime)
            TableColumn("Comments", value: \.comments)
        }
        
        
//        ScrollView {
//            LazyVGrid(
//                columns: RecipeGallery([GridItem(200)]),
//                spacing: 20
//            ) {
//                }
//            }
    }
}

#Preview {
    RecipeGalleryView()
}
