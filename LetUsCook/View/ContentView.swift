//
//  ContentView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftUI

struct ContentView: View {
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

#Preview {
    ContentView()
}
