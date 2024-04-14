//
//  ContentView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/10/24.
//

import SwiftUI

struct ContentView: View {
    var sidebarSelection: SidebarItem?
    @Binding var recipeSelection: Recipe?

    var body: some View {
        if let sidebarSelection {
            // TODO: this does feel kind of icky but not sure of a better way to
            // manage switching the views
            switch sidebarSelection {
            case .Gallery:
                RecipeGalleryView(recipeSelection: $recipeSelection)
            case .Feed:
                RecipeFeedView()
            case .Calendar:
                CalendarView()
            case .Groceries:
                GroceriesView()
            }
        } else {
            Text("Select a sidebar item!")
        }
    }
}

#Preview {
    ContentView(sidebarSelection: .Gallery, recipeSelection: .constant(nil))
}
