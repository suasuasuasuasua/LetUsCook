//
//  ContentView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/10/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext

    var selectedSidebarItem: SidebarItem?

    var body: some View {
        @Bindable var navigationContext = navigationContext

        if let selectedSidebarItem {
            switch selectedSidebarItem {
            case .Gallery:
                RecipeGalleryView()
            case .Feed:
                RecipeFeedView()
            case .Calendar:
                CalendarView()
            case .Groceries:
                GroceriesView()
            }
        } else {
            ContentUnavailableView {
                Text("Select a Category")
            }
        }
    }
}
