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
            NavigationStack {
                CalendarDetailedView(day: navigationContext.selectedDay)
                    .padding()
            }
        default:
            Text("Detailed View")
        }
    }
}

#Preview {
    DetailedView()
}
