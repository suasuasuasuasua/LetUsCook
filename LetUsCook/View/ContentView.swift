//
//  ContentView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/10/24.
//

import SwiftUI

struct ContentView: View {
    @Binding var sidebarSelection: SidebarItem

    var body: some View {
        switch sidebarSelection {
        case .Gallery:
            RecipeGalleryView()
                .navigationTitle(sidebarSelection.rawValue)
        case .Calendar:
            CalendarView()
                .navigationTitle(sidebarSelection.rawValue)
        case .Groceries:
            GroceriesView()
                .navigationTitle(sidebarSelection.rawValue)
        }
    }
}

#Preview {
    ContentView(sidebarSelection: .constant(.Gallery))
}
