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
        Grid {
            RecipeGalleryView()
        }
        .sheet(isPresented: $isEditorPresented) {
            RecipeEditorView(recipe: nil)
        }

        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                AddRecipeButton(isActive: $isEditorPresented)
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
            }
        }
        .padding()
    }
}

private struct AddRecipeButton: View {
    @Binding var isActive: Bool

    var body: some View {
        Button {
            isActive = true
        } label: {
            Label("Add a recipe", systemImage: "plus")
                .help("Add a recipe")
        }
    }
}

// TODO: ideally i want the delete all items to be in another struct like this
// too
// private struct AddClearButton: View {
//     @Binding var modelContext: ModelContext
//
//     var body: some View {}
// }
//
#Preview {
    ContentView()
}
