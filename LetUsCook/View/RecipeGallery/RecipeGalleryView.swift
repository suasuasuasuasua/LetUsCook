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

    @State private var selectedItem: Recipe? = nil
    @State private var searchItem: String = ""

    private let iconSize = 75.0

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(
                columns: [GridItem(.adaptive(
                    minimum: iconSize * 1.5,
                    maximum: iconSize * 2
                ))],
                spacing: 10
            ) {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeView(recipe: recipe)
                    }
                    label: {
                        VStack(alignment: .center) {
                            Text("Image Here.")
                            Text("\(recipe.name)")
                                .bold()
                        }
                        .frame(width: iconSize, height: iconSize)
                    }
                    // TODO: Save which item is selected so we can edit it
                    .onTapGesture {
                        selectedItem = recipe
                    }
                }
            }
            .navigationTitle("Recipe Gallery")
        }
        .searchable(text: $searchItem, placement: .toolbar)

        // TODO: we should have this option in the menubar so that it's
        // obvious that these are commands we can use
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    RecipeEditorView()
                } label: {
                    Label("Create new recipe", systemImage: "plus")
                }

                .keyboardShortcut("n")
            }
            if selectedItem != nil {
                ToolbarItem(placement: .automatic) {
                    NavigationLink {
                        Text("Edit!")
                    } label: {
                        Label("Edit the recipe", systemImage: "pencil")
                    }
                    .keyboardShortcut("e")
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    do {
                        try modelContext.delete(model: Recipe.self)
                    } catch {
                        print("Failed to delete all the data")
                    }
                } label: {
                    Label("Clear all recipes", systemImage: "minus")
                        .help("Clear all recipes (DEBUG)")
                }
                .keyboardShortcut("d")
            }
        }
        .padding()
    }
}
