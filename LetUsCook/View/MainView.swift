//
//  ContentView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 3/30/24.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @State private var navigationContext = NavigationContext()

    var body: some View {
        ColumnView()
            .environment(navigationContext)
    }

    private struct ColumnView: View {
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
                NavigationStack {
                    RecipeView(recipe: navigationContext.selectedRecipe)
                }
            }
        }
    }
}
