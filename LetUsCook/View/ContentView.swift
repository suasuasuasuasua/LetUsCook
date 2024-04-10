//
//  ContentView.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/10/24.
//

import SwiftUI

struct ContentView: View {
    @Binding var selection: SidebarItem

    var body: some View {
        switch selection {
        case .Gallery:
            RecipeGalleryView()
        case .Calendar:
            CalendarView()
        case .Groceries:
            GroceriesView()
        }
    }
}

#Preview {
    ContentView(selection: .constant(.Gallery))
}
