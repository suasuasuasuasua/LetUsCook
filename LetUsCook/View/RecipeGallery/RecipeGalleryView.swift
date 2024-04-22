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
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Recipe.name) private var recipes: [Recipe]
    private var filteredRecipes: [Recipe] {
        recipes.filter {
            if searchTerm.isEmpty {
                // Return all the elements if there isn't a search term
                return true
            } else {
                // Return elemnts that contain the search term
                return $0.name.localizedStandardContains(searchTerm)
            }
        }
    }

    @State private var searchTerm: String
    private let iconSize = 50.0

    // https://www.hackingwithswift.com/quick-start/swiftdata/filtering-the-results-from-a-swiftdata-query
    init(searchTerm: String = "") {
        self.searchTerm = searchTerm
    }

    var body: some View {
        @Bindable var navigationContext = navigationContext

        // Display each recipe as a clickable element
        List(filteredRecipes, selection: $navigationContext.selectedRecipe) { recipe in
            GalleryRow(recipe: recipe, iconSize: iconSize)
                .tag(recipe)
        }
        .searchable(text: $searchTerm, placement: .automatic)
        // TODO: we should have this option in the menubar so that it's
        // obvious that these are commands we can use
        .toolbar {
            // Create a new recipe with the plus button
            ToolbarItem(placement: .primaryAction) {
                Button {
                    let newRecipe = Recipe(
                        name: "New Recipe \(recipes.count + 1)"
                    )

                    modelContext.insert(newRecipe)
                    navigationContext.selectedRecipe = newRecipe
                }
                label: {
                    Label("Create new recipe", systemImage: "plus")
                }
                .keyboardShortcut("n")
            }
        }
        .padding()
        // TODO: i want this frame size to be global
        .frame(minWidth: iconSize * 6)
    }
}
