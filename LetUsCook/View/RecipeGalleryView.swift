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
        @Bindable var navigationContext = navigationContext
//        List(selection: $navigationContext.sidebarTitle) {
//            
//        }
        Table(recipes) {
            TableColumn("Recipe Name") {
                Text("\($0.name)")
            }
        }
    }
}

#Preview {
    RecipeGalleryView()
}
