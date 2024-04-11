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

    @State private var searchTerm: String = ""
    @State private var selectedRecipe: Recipe? = nil

    private var filteredRecipes: [Recipe] {
        recipes.filter {
            $0.name.contains(searchTerm)
        }
    }

    private let iconSize = 75.0

    var body: some View {
        // Filter the recipes if there is a search term (i.e. the search
        // term is not empty
        let recipes = searchTerm.isEmpty
            ? recipes
            : filteredRecipes

        List(recipes, selection: $selectedRecipe) { recipe in
            // Display each recipe as a navigation link
            NavigationLink {
                RecipeView(recipe: recipe)
            }
            label: {
                RecipeGalleryIcon(recipe: recipe, iconSize: iconSize)
            }
        }
        .searchable(text: $searchTerm, placement: .toolbar)

        // TODO: we should have this option in the menubar so that it's
        // obvious that these are commands we can use
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink {
                    RecipeEditorView()
                } label: {
                    Label("Create new recipe", systemImage: "plus")
                }
                .keyboardShortcut("n")
            }
            ToolbarItem(placement: .destructiveAction) {
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
        .padding()
        .frame(minWidth: iconSize * 2)
    }
}

#Preview {
    RecipeGalleryView()
        .modelContainer(previewContainer)
}
