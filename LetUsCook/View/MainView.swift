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
            switch navigationContext.selectedSidebarItem {
            case .Gallery:
                RecipeView(recipe: navigationContext.selectedRecipe)
            case .Calendar:
                CalendarDetailedView()

            default:
                Text("Default")
            }
        }
        .onChange(of: navigationContext.selectedSidebarItem) {
            navigationContext.selectedRecipe = nil
            navigationContext.selectedDate = nil
        }
    }
}
