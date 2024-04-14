//
//  ContentView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var sidebarSelection: SidebarItem? = .Gallery
    @State private var recipeSelection: Recipe?

    var body: some View {
        NavigationSplitView {
            // Make a selection from the sidebar
            SidebarView(sidebarSelection: $sidebarSelection)
        }
        content: {
            if let sidebarSelection {
                ContentView(
                    sidebarSelection: sidebarSelection,
                    recipeSelection: $recipeSelection
                )
            } else {
                Text("Select a sidebar item!")
            }
        }
        detail: {
            RecipeView(recipe: recipeSelection)
        }
    }
}

#Preview {
    MainView()
        .modelContainer(previewContainer)
}
