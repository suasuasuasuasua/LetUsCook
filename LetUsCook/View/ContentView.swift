//
//  ContentView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftUI
import SwiftData

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

//func clearModel(modelContext: ModelContainer) {
//    do {
//        try modelContext.delete(model: Recipe.self)
//        try modelContext.delete(model: Instruction.self)
//        try modelContext.delete(model: Ingredient.self)
//    } catch {
//        print("Failed to delete all the data")
//    }
//}
//
#Preview {
    ContentView()
}
