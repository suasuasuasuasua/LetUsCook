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

    var body: some View {
        @Bindable var navigationContext = navigationContext

        if let selectedSidebarItem = navigationContext.selectedSidebarItem {
            switch selectedSidebarItem {
            case .Gallery:
                GalleryView()
                    .background(.white)
            case .Feed:
                FeedView()
                    .background(.white)
            case .Calendar:
                CalendarView()
                    .background(.white)
            case .Groceries:
                GroceriesView()
                    .background(.white)
            }
        } else {
            ContentUnavailableView {
                Text("Select a Category")
            }
        }
    }
}
