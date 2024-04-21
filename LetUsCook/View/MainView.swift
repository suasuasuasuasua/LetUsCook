//
//  ContentView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        @Bindable var navigationContext = navigationContext

        NavigationSplitView(
            columnVisibility: $navigationContext.columnVisibility
        ) {
            SidebarView()
                .navigationTitle(navigationContext.sidebarTitle)
        }
        content: {
            ContentView(
                selectedSidebarItem: navigationContext.selectedSidebarItem
            )
            .navigationTitle(navigationContext.contentListTitle)
        }
        detail: {
            RecipeView(recipe: navigationContext.selectedRecipe)
        }
    }
}
