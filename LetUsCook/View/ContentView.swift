//
//  ContentView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(NavigationContext.self) private var navigationContext

    /// Check if the editor needs to be opened
    @State var isEditorPresented = false

    var body: some View {
        // TODO: put this in a NavigationSplitView
        RecipeGalleryView()
            .sheet(isPresented: $isEditorPresented) {
                RecipeEditorView(recipe: Recipe(name: "New Recipe.."))
            }
            // TODO: try to refactor to another struct view like AddXButton(...)
            // For some reason, the model context could not be found as a
            // binding
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isEditorPresented = true
                    } label: {
                        Label("Add a recipe", systemImage: "plus")
                            .help("Add a recipe")
                    }
                    // TODO: make this in the App itself so that we can put the hint
                    // in the menu bar
                    // cmd+n to create an entry
                    .keyboardShortcut("n")
                }
                // TODO: take this out when we're done debugging
                // Or leave it in with a warning
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
                    // TODO: remove this in practice
                    // cmd+d to delete all the entries
                    .keyboardShortcut("d")
                }
            }
            .padding()
    }
}
