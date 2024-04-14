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

    @Binding var recipeSelection: Recipe?

    var body: some View {
        // Filter the recipes if there is a search term (i.e. the search
        // term is not empty
        // TODO: use data model instead of this
        let recipes = searchTerm.isEmpty
            ? recipes
            : filteredRecipes

        List(recipes, selection: $recipeSelection) { recipe in
            // Display each recipe as a navigation link
            RecipeGalleryIcon(recipe: recipe, iconSize: iconSize)
                .tag(recipe)
        }
        .searchable(text: $searchTerm, placement: .toolbar)

        // TODO: we should have this option in the menubar so that it's
        // obvious that these are commands we can use
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                NavigationLink {
                    RecipeEditorView()
                } label: {
                    Label("Create new recipe", systemImage: "plus")
                }
                .keyboardShortcut("n")
                Button {
                    do {
                        try modelContext.delete(model: Recipe.self)
                    } catch {
                        print("Failed to delete all the data")
                    }
                } label: {
                    Label("Clear all recipes", systemImage: "trash")
                        .help("Clear all recipes (DEBUG)")
                }
                .keyboardShortcut("d")
            }
        }
        .listStyle(.automatic)
        .padding()
        // TODO: i want this frame size to be global
        .frame(minWidth: iconSize * 4)
    }

    @State private var searchTerm: String = ""
    private let iconSize = 50.0
    private var filteredRecipes: [Recipe] {
        recipes.filter { recipe in
            recipe.name.contains(searchTerm)
        }
    }
}

#Preview {
    RecipeGalleryView(recipeSelection: .constant(nil))
        .modelContainer(previewContainer)
}
