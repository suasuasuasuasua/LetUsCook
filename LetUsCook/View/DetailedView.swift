//
//  DetailedView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 5/2/24.
//

import SwiftUI

struct DetailedView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        @Bindable var navigationContext = navigationContext

        switch navigationContext.selectedSidebarItem {
        case .Gallery:
            RecipeView(recipe: navigationContext.selectedRecipe)
                .padding()
        case .Calendar:
            if let selectedDay = navigationContext.selectedDay {
                CalendarDetailedView(selectedDay: selectedDay)
                    .padding()
            } else {
                ContentUnavailableView(
                    "Select a date!",
                    systemImage: "calendar"
                )
            }
        case .Groceries:
            GroceriesDetailedView()
        default:
            Text("Detailed View")
        }
    }
}

#Preview {
    DetailedView()
}
