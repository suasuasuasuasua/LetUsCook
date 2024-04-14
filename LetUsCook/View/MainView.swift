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
            SidebarView(sidebarSelection: $sidebarSelection)
        }
        content: {
            ContentView(
                sidebarSelection: sidebarSelection,
                recipeSelection: $recipeSelection
            )
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
